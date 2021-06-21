Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF983AF161
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFURIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhFURIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 13:08:45 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617C9C0610FF;
        Mon, 21 Jun 2021 09:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bOe6jT5eUt1cXtTFFddI27UAhUWivIDNOJt+S9Sax0Q=; b=ookFBmp1vq9wQTqp4jOhTBIyiY
        3Y22zs+UR/pWlAKfnb5F/xnVeJUHN+r+xLDGOeFfaGaqiFmu4WXbObFKGlwdH2gHnhu9EYr7ewhCM
        3Iwn2nIFjQI03BEKtrG0IE6GqRJ5miNjd6nvNiq4/GNVjz/HMOyYGuE8VdXrbVZlVB3ptzRP0orOU
        4jnedK4FPtf6l+xr4+WPFsHkcdwyaIqvaJOw21Vuhq3ZYSTduYR2OOe5EuuAPm9LBcWeth5k5wkPl
        IGLKQeI0qiYp7hsMa6kI+UQDGiaS/eb83z8THTWtYqe9RWlu9AGMjsriCFamXjtMsO0NMPEazPNNs
        7TjN1Gbg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvNFC-00AIXS-Qr; Mon, 21 Jun 2021 16:58:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 22E03300204;
        Mon, 21 Jun 2021 18:57:59 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0C3E1200C0CCA; Mon, 21 Jun 2021 18:57:59 +0200 (CEST)
Date:   Mon, 21 Jun 2021 18:57:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Odin Ugedal <odin@uged.al>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 095/146] sched/fair: Correctly insert cfs_rqs to
 list on unthrottle
Message-ID: <YNDFFkh2Dn0hMqS8@hirez.programming.kicks-ass.net>
References: <20210621154911.244649123@linuxfoundation.org>
 <20210621154917.185551238@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154917.185551238@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:15:25PM +0200, Greg Kroah-Hartman wrote:
> From: Odin Ugedal <odin@uged.al>
> 
> [ Upstream commit a7b359fc6a37faaf472125867c8dc5a068c90982 ]
> 
> Fix an issue where fairness is decreased since cfs_rq's can end up not
> being decayed properly. For two sibling control groups with the same
> priority, this can often lead to a load ratio of 99/1 (!!).
> 
> This happens because when a cfs_rq is throttled, all the descendant
> cfs_rq's will be removed from the leaf list. When they initial cfs_rq
> is unthrottled, it will currently only re add descendant cfs_rq's if
> they have one or more entities enqueued. This is not a perfect
> heuristic.
> 
> Instead, we insert all cfs_rq's that contain one or more enqueued
> entities, or it its load is not completely decayed.
> 
> Can often lead to situations like this for equally weighted control
> groups:
> 
>   $ ps u -C stress
>   USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>   root       10009 88.8  0.0   3676   100 pts/1    R+   11:04   0:13 stress --cpu 1
>   root       10023  3.0  0.0   3676   104 pts/1    R+   11:04   0:00 stress --cpu 1
> 
> Fixes: 31bc6aeaab1d ("sched/fair: Optimize update_blocked_averages()")
> [vingo: !SMP build fix]
> Signed-off-by: Odin Ugedal <odin@uged.al>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> Link: https://lore.kernel.org/r/20210612112815.61678-1-odin@uged.al
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This one is currently known to cause some LTP fail, fixes are being
discussed, please hold off for now.
