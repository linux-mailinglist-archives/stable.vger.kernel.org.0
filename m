Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850A0156BC6
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgBIRUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgBIRUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 12:20:22 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C855920715;
        Sun,  9 Feb 2020 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581268822;
        bh=SQxG9JHU7M0JpvNpGmW2KhG9/UKbFfZNFDTIRfHh9SY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecNqKmiA2k5/aFCG1jn8RdI0C0jCLN3RVaiUtjlWWoga7KJ3cVf/jkbacFRZmMrBZ
         fx2VpObGqG6IZbP8yoI3EvA+ZmYBGT3MpAIHknWIRORhIvZz82hiQN2BYp7BbznSMw
         I5iGhfYoHNirkY7ayyDqE6O5FReuhnvPXToMlaU0=
Date:   Sun, 9 Feb 2020 12:20:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: free block groups after free'ing
 fs trees" failed to apply to 5.4-stable tree
Message-ID: <20200209172020.GF3584@sasha-vm>
References: <1581247841121239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581247841121239@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:30:41PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 4e19443da1941050b346f8fc4c368aa68413bc88 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Tue, 21 Jan 2020 09:17:06 -0500
>Subject: [PATCH] btrfs: free block groups after free'ing fs trees
>
>Sometimes when running generic/475 we would trip the
>WARN_ON(cache->reserved) check when free'ing the block groups on umount.
>This is because sometimes we don't commit the transaction because of IO
>errors and thus do not cleanup the tree logs until at umount time.
>
>These blocks are still reserved until they are cleaned up, but they
>aren't cleaned up until _after_ we do the free block groups work.  Fix
>this by moving the free after free'ing the fs roots, that way all of the
>tree logs are cleaned up and we have a properly cleaned fs.  A bunch of
>loops of generic/475 confirmed this fixes the problem.
>
>CC: stable@vger.kernel.org # 4.9+
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

I took 4273eaff9b8d ("btrfs: use bool argument in free_root_pointers()")
too and queued both for 5.4-4.9.

-- 
Thanks,
Sasha
