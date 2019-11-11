Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497C3F7542
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfKKNog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfKKNog (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:44:36 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C3321872;
        Mon, 11 Nov 2019 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573479875;
        bh=KV4bt2Wfl+veD7/Pppenh2Uh9bsOMBNvLTLE75mI2XM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VE7ipGlJc7mdayt2VwLWWxHQcrFFp+97tENLX6zzjtTCcXuuZ5KvnxxzHYV3GeWGo
         1lM0em9AaKDiyQ4aYdxi3vohbkOlWxeBDP+kOeNGhyfD6gGnMayEIPdb/o1LDLUKNr
         5F8dvc46rjgTZdDxW19F72TZv9okoAI4VItY4WHY=
Date:   Mon, 11 Nov 2019 08:44:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tj@kernel.org, axboe@kernel.dk, guro@fb.com, jbacik@fb.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] blkcg: make blkcg_print_stat() print
 stats only for online" failed to apply to 4.19-stable tree
Message-ID: <20191111134434.GA8496@sasha-vm>
References: <1573452744205173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1573452744205173@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:12:24AM +0100, gregkh@linuxfoundation.org wrote:
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
>From b0814361a25cba73a224548843ed92d8ea78715a Mon Sep 17 00:00:00 2001
>From: Tejun Heo <tj@kernel.org>
>Date: Tue, 5 Nov 2019 08:09:51 -0800
>Subject: [PATCH] blkcg: make blkcg_print_stat() print stats only for online
> blkgs
>
>blkcg_print_stat() iterates blkgs under RCU and doesn't test whether
>the blkg is online.  This can call into pd_stat_fn() on a pd which is
>still being initialized leading to an oops.
>
>The heaviest operation - recursively summing up rwstat counters - is
>already done while holding the queue_lock.  Expand queue_lock to cover
>the other operations and skip the blkg if it isn't online yet.  The
>online state is protected by both blkcg and queue locks, so this
>guarantees that only online blkgs are processed.
>
>Signed-off-by: Tejun Heo <tj@kernel.org>
>Reported-by: Roman Gushchin <guro@fb.com>
>Cc: Josef Bacik <jbacik@fb.com>
>Fixes: 903d23f0a354 ("blk-cgroup: allow controllers to output their own stats")
>Cc: stable@vger.kernel.org # v4.19+
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

I've adjusted the patch for not having 0d945c1f966b ("block: remove the
queue_lock indirection") and queued it for 4.19.

-- 
Thanks,
Sasha
