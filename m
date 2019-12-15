Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF2E11FA85
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLOSpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfLOSpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:45:32 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86431206D7;
        Sun, 15 Dec 2019 18:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576435531;
        bh=h/OLaQKT+1rR5tZ/iYhxP1WQssZLOHof734IyGgm09U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZtbK2Ynp0gacxWWVMJU++cLPk5qJYFOahuV61UizwcrkNDIKai0oDsyvC4gBTDO6
         O+s4O1eDLKSEXyuNnjcdk7W4DlW9Sqe3A1GVzWqtQMRLv6WxTNUPKfit8N4iTBbE27
         hvGyaZ8x8Z997ltl8T9J0o0gx27q/TsiPeRj8zbo=
Date:   Sun, 15 Dec 2019 13:45:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, nborisov@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: use btrfs_block_group_cache_done
 in update_block_group" failed to apply to 5.3-stable tree
Message-ID: <20191215184530.GO18043@sasha-vm>
References: <1576408118186153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576408118186153@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 12:08:38PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From a60adce85f4bb5c1ef8ffcebadd702cafa2f3696 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Tue, 24 Sep 2019 16:50:44 -0400
>Subject: [PATCH] btrfs: use btrfs_block_group_cache_done in update_block_group
>
>When free'ing extents in a block group we check to see if the block
>group is not cached, and then cache it if we need to.  However we'll
>just carry on as long as we're loading the cache.  This is problematic
>because we are dirtying the block group here.  If we are fast enough we
>could do a transaction commit and clear the free space cache while we're
>still loading the space cache in another thread.  This truncates the
>free space inode, which will keep it from loading the space cache.
>
>Fix this by using the btrfs_block_group_cache_done helper so that we try
>to load the space cache unconditionally here, which will result in the
>caller waiting for the fast caching to complete and keep us from
>truncating the free space inode.
>
>CC: stable@vger.kernel.org # 4.4+
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

The code just moved around a lot. I've fixed it up and queued for all
branches.

-- 
Thanks,
Sasha
