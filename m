Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3FA23A5DE
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgHCMm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgHCMbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:31:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE8E42054F;
        Mon,  3 Aug 2020 12:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457866;
        bh=KPEQdRBWpj2++NzmpX3wevXP1Ga9IyqWe51CLg9gI0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKBZgNKGVGU/8ZE+cSZN+jN5SsWSL5IvZd5r54pUV0Gm2ehFldtzyBIEJlTVY4Ud7
         Aej7EK8rvFev7868wOT/eiCfEAclAIfPQGVQRU93Cw4lxtxHL8YHVPJ27G60H+lhf6
         /SurIz2l4ARWV2yL9nPfXjdpElFX+Jyfq/brFOrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/56] Btrfs: fix selftests failure due to uninitialized i_mode in test inodes
Date:   Mon,  3 Aug 2020 14:19:26 +0200
Message-Id: <20200803121850.868864740@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9f7fec0ba89108b9385f1b9fb167861224912a4a ]

Some of the self tests create a test inode, setup some extents and then do
calls to btrfs_get_extent() to test that the corresponding extent maps
exist and are correct. However btrfs_get_extent(), since the 5.2 merge
window, now errors out when it finds a regular or prealloc extent for an
inode that does not correspond to a regular file (its ->i_mode is not
S_IFREG). This causes the self tests to fail sometimes, specially when
KASAN, slub_debug and page poisoning are enabled:

  $ modprobe btrfs
  modprobe: ERROR: could not insert 'btrfs': Invalid argument

  $ dmesg
  [ 9414.691648] Btrfs loaded, crc32c=crc32c-intel, debug=on, assert=on, integrity-checker=on, ref-verify=on
  [ 9414.692655] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
  [ 9414.692658] BTRFS: selftest: running btrfs free space cache tests
  [ 9414.692918] BTRFS: selftest: running extent only tests
  [ 9414.693061] BTRFS: selftest: running bitmap only tests
  [ 9414.693366] BTRFS: selftest: running bitmap and extent tests
  [ 9414.696455] BTRFS: selftest: running space stealing from bitmap to extent tests
  [ 9414.697131] BTRFS: selftest: running extent buffer operation tests
  [ 9414.697133] BTRFS: selftest: running btrfs_split_item tests
  [ 9414.697564] BTRFS: selftest: running extent I/O tests
  [ 9414.697583] BTRFS: selftest: running find delalloc tests
  [ 9415.081125] BTRFS: selftest: running find_first_clear_extent_bit test
  [ 9415.081278] BTRFS: selftest: running extent buffer bitmap tests
  [ 9415.124192] BTRFS: selftest: running inode tests
  [ 9415.124195] BTRFS: selftest: running btrfs_get_extent tests
  [ 9415.127909] BTRFS: selftest: running hole first btrfs_get_extent test
  [ 9415.128343] BTRFS critical (device (efault)): regular/prealloc extent found for non-regular inode 256
  [ 9415.131428] BTRFS: selftest: fs/btrfs/tests/inode-tests.c:904 expected a real extent, got 0

This happens because the test inodes are created without ever initializing
the i_mode field of the inode, and neither VFS's new_inode() nor the btrfs
callback btrfs_alloc_inode() initialize the i_mode. Initialization of the
i_mode is done through the various callbacks used by the VFS to create
new inodes (regular files, directories, symlinks, tmpfiles, etc), which
all call btrfs_new_inode() which in turn calls inode_init_owner(), which
sets the inode's i_mode. Since the tests only uses new_inode() to create
the test inodes, the i_mode was never initialized.

This always happens on a VM I used with kasan, slub_debug and many other
debug facilities enabled. It also happened to someone who reported this
on bugzilla (on a 5.3-rc).

Fix this by setting i_mode to S_IFREG at btrfs_new_test_inode().

Fixes: 6bf9e4bd6a2778 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204397
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tests/btrfs-tests.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 2eec1dd3803af..82d874b104383 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -38,7 +38,13 @@ static struct file_system_type test_type = {
 
 struct inode *btrfs_new_test_inode(void)
 {
-	return new_inode(test_mnt->mnt_sb);
+	struct inode *inode;
+
+	inode = new_inode(test_mnt->mnt_sb);
+	if (inode)
+		inode_init_owner(inode, NULL, S_IFREG);
+
+	return inode;
 }
 
 static int btrfs_init_test_fs(void)
-- 
2.25.1



