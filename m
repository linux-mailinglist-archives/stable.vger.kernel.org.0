Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A953FDBAB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344824AbhIAMnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345183AbhIAMkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E5D4611BD;
        Wed,  1 Sep 2021 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499838;
        bh=GFhM3rqhV9emy2YD5wjh9wrL/4dZOq30hY0urLDQG3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCr4pPq8gFCB/qpY5fJWZZ2Qt2QhumPw5Cdtb78z2h0syhRqgFIRM6R2oEKfJbrhE
         ey8qCqwheDEPme6iiw00tTd8JgNrSB8bDqcFquZurz3cwxi5RLgDOUiaWortP0mJuK
         iOfxg1B97yElKYGuNXE8Pp/taRUp/v3LrB/A9SPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 098/103] btrfs: fix NULL pointer dereference when deleting device by invalid id
Date:   Wed,  1 Sep 2021 14:28:48 +0200
Message-Id: <20210901122303.830382327@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit e4571b8c5e9ffa1e85c0c671995bd4dcc5c75091 upstream.

[BUG]
It's easy to trigger NULL pointer dereference, just by removing a
non-existing device id:

 # mkfs.btrfs -f -m single -d single /dev/test/scratch1 \
				     /dev/test/scratch2
 # mount /dev/test/scratch1 /mnt/btrfs
 # btrfs device remove 3 /mnt/btrfs

Then we have the following kernel NULL pointer dereference:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 9 PID: 649 Comm: btrfs Not tainted 5.14.0-rc3-custom+ #35
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 RIP: 0010:btrfs_rm_device+0x4de/0x6b0 [btrfs]
  btrfs_ioctl+0x18bb/0x3190 [btrfs]
  ? lock_is_held_type+0xa5/0x120
  ? find_held_lock.constprop.0+0x2b/0x80
  ? do_user_addr_fault+0x201/0x6a0
  ? lock_release+0xd2/0x2d0
  ? __x64_sys_ioctl+0x83/0xb0
  __x64_sys_ioctl+0x83/0xb0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

[CAUSE]
Commit a27a94c2b0c7 ("btrfs: Make btrfs_find_device_by_devspec return
btrfs_device directly") moves the "missing" device path check into
btrfs_rm_device().

But btrfs_rm_device() itself can have case where it only receives
@devid, with NULL as @device_path.

In that case, calling strcmp() on NULL will trigger the NULL pointer
dereference.

Before that commit, we handle the "missing" case inside
btrfs_find_device_by_devspec(), which will not check @device_path at all
if @devid is provided, thus no way to trigger the bug.

[FIX]
Before calling strcmp(), also make sure @device_path is not NULL.

Fixes: a27a94c2b0c7 ("btrfs: Make btrfs_find_device_by_devspec return btrfs_device directly")
CC: stable@vger.kernel.org # 5.4+
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2059,7 +2059,7 @@ int btrfs_rm_device(struct btrfs_fs_info
 
 	if (IS_ERR(device)) {
 		if (PTR_ERR(device) == -ENOENT &&
-		    strcmp(device_path, "missing") == 0)
+		    device_path && strcmp(device_path, "missing") == 0)
 			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 		else
 			ret = PTR_ERR(device);


