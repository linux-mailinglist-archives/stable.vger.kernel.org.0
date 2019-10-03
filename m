Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660DAC9F98
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfJCNlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJCNlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 09:41:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D12020865;
        Thu,  3 Oct 2019 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570110096;
        bh=yRxzVsfeJ3KZt8CQmRSjCw2u/c1hrTkgYN5NecdUw+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZ2L8DDfav9hjMZfQRK3bRnoZNTzjKxFyZMw08c4mFK92JSd+UEhynD296mDBPf86
         /9YNJtcMW5SKMOztJB34KmeBG3G1ktwqxbiXvoJ4uSPiuJLbU8cTyFYbPmtHY1S8OB
         vXcr6/c6rQHu8oOXVAmTGQ2wFXDzGem8yOzlT2pA=
Date:   Thu, 3 Oct 2019 09:41:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     laoar.shao@gmail.com, akpm@linux-foundation.org,
        mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com,
        shaoyafang@didiglobal.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/compaction.c: clear
 total_{migrate,free}_scanned before" failed to apply to 4.19-stable tree
Message-ID: <20191003134135.GY17454@sasha-vm>
References: <157010272680112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157010272680112@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 01:38:46PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From a94b525241c0fff3598809131d7cfcfe1d572d8c Mon Sep 17 00:00:00 2001
>From: Yafang Shao <laoar.shao@gmail.com>
>Date: Mon, 23 Sep 2019 15:36:54 -0700
>Subject: [PATCH] mm/compaction.c: clear total_{migrate,free}_scanned before
> scanning a new zone
>
>total_{migrate,free}_scanned will be added to COMPACTMIGRATE_SCANNED and
>COMPACTFREE_SCANNED in compact_zone().  We should clear them before
>scanning a new zone.  In the proc triggered compaction, we forgot clearing
>them.
>
>[laoar.shao@gmail.com: introduce a helper compact_zone_counters_init()]
>  Link: http://lkml.kernel.org/r/1563869295-25748-1-git-send-email-laoar.shao@gmail.com
>[akpm@linux-foundation.org: expand compact_zone_counters_init() into its single callsite, per mhocko]
>[vbabka@suse.cz: squash compact_zone() list_head init as well]
>  Link: http://lkml.kernel.org/r/1fb6f7da-f776-9e42-22f8-bbb79b030b98@suse.cz
>[akpm@linux-foundation.org: kcompactd_do_work(): avoid unnecessary initialization of cc.zone]
>Link: http://lkml.kernel.org/r/1563789275-9639-1-git-send-email-laoar.shao@gmail.com
>Fixes: 7f354a548d1c ("mm, compaction: add vmstats for kcompactd work")
>Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>Cc: David Rientjes <rientjes@google.com>
>Cc: Yafang Shao <shaoyafang@didiglobal.com>
>Cc: Mel Gorman <mgorman@techsingularity.net>
>Cc: Michal Hocko <mhocko@suse.com>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This was mostly due to unrelated code cleanups. I've queued up a
backport for 4.19 and 4.14, it's not needed on older kernels.

--
Thanks,
Sasha
