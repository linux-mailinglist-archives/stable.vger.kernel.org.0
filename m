Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3C8330E48
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCHMg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhCHMgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D48D651D3;
        Mon,  8 Mar 2021 12:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206964;
        bh=UmnkXUqyfdgiK+RwUog45/cxDFGRZwQzWG+yd57ROZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTVqyP1007MK1f/JSctEWwxCi8qpJAlE3MUtfD12PCMxfWVcif99ZSZ1zBT/7eh0Q
         uxECn6epgyIczdCsj6xTKXrgYg5SHnvJlM1xs6HQABpF2poyM5jg4Ps4dhpA2j/kA3
         7h6DZM1MLGaitRx2X7MSTBTlWRrOkOyJ8rrLMtEY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Boris Burkov <boris@bur.io>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 17/44] btrfs: fix spurious free_space_tree remount warning
Date:   Mon,  8 Mar 2021 13:34:55 +0100
Message-Id: <20210308122719.428529761@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Boris Burkov <boris@bur.io>

commit c55a4319c4f2c3ba0a385b1ebc454fa283cfe920 upstream.

The intended logic of the check is to catch cases where the desired
free_space_tree setting doesn't match the mounted setting, and the
remount is anything but ro->rw. However, it makes the mistake of
checking equality on a masked integer (btrfs_test_opt) against a boolean
(btrfs_fs_compat_ro).

If you run the reproducer:
  $ mount -o space_cache=v2 dev mnt
  $ mount -o remount,ro mnt

you would expect no warning, because the remount is not attempting to
change the free space tree setting, but we do see the warning.

To fix this, add explicit bool type casts to the condition.

I tested a variety of transitions:
sudo mount -o space_cache=v2 /dev/vg0/lv0 mnt/lol
(fst enabled)
mount -o remount,ro mnt/lol
(no warning, no fst change)
sudo mount -o remount,rw,space_cache=v1,clear_cache
(no warning, ro->rw)
sudo mount -o remount,rw,space_cache=v2 mnt
(warning, rw->rw with change)
sudo mount -o remount,ro mnt
(no warning, no fst change)
sudo mount -o remount,rw,space_cache=v2 mnt
(no warning, no fst change)

Reported-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 5.11
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1919,8 +1919,8 @@ static int btrfs_remount(struct super_bl
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
 
-	if (btrfs_test_opt(fs_info, FREE_SPACE_TREE) !=
-	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
+	if ((bool)btrfs_test_opt(fs_info, FREE_SPACE_TREE) !=
+	    (bool)btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
 	    (!sb_rdonly(sb) || (*flags & SB_RDONLY))) {
 		btrfs_warn(fs_info,
 		"remount supports changing free space tree only from ro to rw");


