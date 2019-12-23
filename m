Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF41129B11
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 22:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLWV2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 16:28:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfLWV2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 16:28:15 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149E3206D3;
        Mon, 23 Dec 2019 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577136494;
        bh=VvBuU2g7lkmTYMjbae7Ut9GSVzNxzuMwrzuyzihJqgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYJpyll/fSjxmVm4iNCSHAL+HjgzXEcbHEr4X5lQ299wiSgW+YPjfkqK7RDqpmy7P
         Kmng6B261IvoDi3j4ev2td932eKXlte3lWQMV/y1aZIrLiG4qCTN4jvNZq9tQJyFFo
         f6jWv3pT95N4NdYVqrHElHY4dpx6d7CHWuNQXKHg=
Date:   Mon, 23 Dec 2019 16:28:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: do not call synchronize_srcu() in
 inode_tree_del" failed to apply to 4.9-stable tree
Message-ID: <20191223212812.GZ17708@sasha-vm>
References: <1577121107178231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577121107178231@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 23, 2019 at 12:11:47PM -0500, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From f72ff01df9cf5db25c76674cac16605992d15467 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Tue, 19 Nov 2019 13:59:35 -0500
>Subject: [PATCH] btrfs: do not call synchronize_srcu() in inode_tree_del
>
>Testing with the new fsstress uncovered a pretty nasty deadlock with
>lookup and snapshot deletion.
>
>Process A
>unlink
> -> final iput
>   -> inode_tree_del
>     -> synchronize_srcu(subvol_srcu)
>
>Process B
>btrfs_lookup  <- srcu_read_lock() acquired here
>  -> btrfs_iget
>    -> find inode that has I_FREEING set
>      -> __wait_on_freeing_inode()
>
>We're holding the srcu_read_lock() while doing the iget in order to make
>sure our fs root doesn't go away, and then we are waiting for the inode
>to finish freeing.  However because the free'ing process is doing a
>synchronize_srcu() we deadlock.
>
>Fix this by dropping the synchronize_srcu() in inode_tree_del().  We
>don't need people to stop accessing the fs root at this point, we're
>only adding our empty root to the dead roots list.
>
>A larger much more invasive fix is forthcoming to address how we deal
>with fs roots, but this fixes the immediate problem.
>
>Fixes: 76dda93c6ae2 ("Btrfs: add snapshot/subvolume destroy ioctl")
>CC: stable@vger.kernel.org # 4.4+
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Fixed up to work around missing 0b246afa62b0 ("btrfs: root->fs_info
cleanup, add fs_info convenience variables") and queued for 4.9 and 4.4.

-- 
Thanks,
Sasha
