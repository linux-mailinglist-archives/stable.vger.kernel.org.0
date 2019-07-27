Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA59577C04
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfG0VYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 17:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfG0VYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jul 2019 17:24:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544B820657;
        Sat, 27 Jul 2019 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564262661;
        bh=qoE6ptOEb4ULRj1Rw05H1bmDm81qtxOhZ4CxCKq7DKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXz/4F4yJJ1k+lSXFJfJQyElubb42wUxO4un+dZzd6/squ5M3/mqyv7ZuZ8kl6GWR
         yiYaOMJTny1lJ0+OI9E/z4nKemRQjgA3bJfxqybEhUkaVFefvauc0lzfVR8h3byeos
         hnRuZRewNOIIzW96DIxkqn2w66J2x6eZ9GDVJDFU=
Date:   Sat, 27 Jul 2019 17:24:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.2 14/66] net_sched: unset TCQ_F_CAN_BYPASS when adding
 filters
Message-ID: <20190727212420.GA8637@sasha-vm>
References: <20190726152301.936055394@linuxfoundation.org>
 <20190726152303.389623216@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190726152303.389623216@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 05:24:13PM +0200, Greg Kroah-Hartman wrote:
>From: Cong Wang <xiyou.wangcong@gmail.com>
>
>[ Upstream commit 3f05e6886a595c9a29a309c52f45326be917823c ]
>
>For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
>notably fq_codel, it makes no sense to let packets bypass the TC
>filters we setup in any scenario, otherwise our packets steering
>policy could not be enforced.
>
>This can be reproduced easily with the following script:
>
> ip li add dev dummy0 type dummy
> ifconfig dummy0 up
> tc qd add dev dummy0 root fq_codel
> tc filter add dev dummy0 parent 8001: protocol arp basic action mirred egress redirect dev lo
> tc filter add dev dummy0 parent 8001: protocol ip basic action mirred egress redirect dev lo
> ping -I dummy0 192.168.112.1
>
>Without this patch, packets are sent directly to dummy0 without
>hitting any of the filters. With this patch, packets are redirected
>to loopback as expected.
>
>This fix is not perfect, it only unsets the flag but does not set it back
>because we have to save the information somewhere in the qdisc if we
>really want that. Note, both fq_codel and sfq clear this flag in their
>->bind_tcf() but this is clearly not sufficient when we don't use any
>class ID.
>
>Fixes: 23624935e0c4 ("net_sched: TCQ_F_CAN_BYPASS generalization")
>Cc: Eric Dumazet <edumazet@google.com>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>Reviewed-by: Eric Dumazet <edumazet@google.com>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

There's a fix for this one:

	503d81d428bd5 ("net: sched: verify that q!=NULL before setting
	q->flags").

--
Thanks,
Sasha
