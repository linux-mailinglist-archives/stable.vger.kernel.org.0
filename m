Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90193156BDA
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgBIRox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbgBIRox (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 12:44:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CB6020726;
        Sun,  9 Feb 2020 17:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581270292;
        bh=H2u1GPwTZr7dXWqUbGxhlia0dWafp6RtD6wWYFaWoY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ztCxigyCi8wTxHRv4G6lZ2gjtrVl1nbB8RhkxPzKsH/CRisWwqz9l2AmAIxaKSnTj
         5gIRE35ROmOAh8NLXJlESBRkx6vTxkQyrutLP0eO9v5n5duICR8MjkNPKFaFTJGLXq
         ZXsKV5QpwXx0FPFHodull6B/EqmZxhwPDHFc6s5U=
Date:   Sun, 9 Feb 2020 12:44:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, martin@lichtvoll.de,
        wqu@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: do not zero f_bavail if we have
 available space" failed to apply to 5.4-stable tree
Message-ID: <20200209174451.GH3584@sasha-vm>
References: <158124801318473@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124801318473@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:33:33PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Fri, 31 Jan 2020 09:31:05 -0500
>Subject: [PATCH] btrfs: do not zero f_bavail if we have available space
>
>There was some logic added a while ago to clear out f_bavail in statfs()
>if we did not have enough free metadata space to satisfy our global
>reserve.  This was incorrect at the time, however didn't really pose a
>problem for normal file systems because we would often allocate chunks
>if we got this low on free metadata space, and thus wouldn't really hit
>this case unless we were actually full.
>
>Fast forward to today and now we are much better about not allocating
>metadata chunks all of the time.  Couple this with d792b0f19711 ("btrfs:
>always reserve our entire size for the global reserve") which now means
>we'll easily have a larger global reserve than our free space, we are
>now more likely to trip over this while still having plenty of space.
>
>Fix this by skipping this logic if the global rsv's space_info is not
>full.  space_info->full is 0 unless we've attempted to allocate a chunk
>for that space_info and that has failed.  If this happens then the space
>for the global reserve is definitely sacred and we need to report
>b_avail == 0, but before then we can just use our calculated b_avail.
>
>Reported-by: Martin Steigerwald <martin@lichtvoll.de>
>Fixes: ca8a51b3a979 ("btrfs: statfs: report zero available if metadata are exhausted")
>CC: stable@vger.kernel.org # 4.5+
>Reviewed-by: Qu Wenruo <wqu@suse.com>
>Tested-By: Martin Steigerwald <martin@lichtvoll.de>
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

This one is queued up already :)

-- 
Thanks,
Sasha
