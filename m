Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB704266670
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIKR1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgIKM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 338DB204EC;
        Fri, 11 Sep 2020 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828930;
        bh=8be14t6toKkJ2ugaHUTaO+IyU8RtEwtyfH4schRWzNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHrsT0Vrmgy/ObS8WiY8AcGPbqoKM388w5Eo/uNs8cU+R0sjNXAro4aD6slgqsTGU
         UhtYJs0MD4YumjySvQWyEkgn7Y3AZmhuloLBRzkfjmaevIzEmaZfECdSMh4krPv4Vx
         02KUW8oyJ2bHwRL3PSnRkvy5keR9RkvKZLz+JnE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Staudt <max@enpas.org>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 55/62] affs: fix basic permission bits to actually work
Date:   Fri, 11 Sep 2020 14:46:38 +0200
Message-Id: <20200911122505.136472573@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Staudt <max@enpas.org>

[ Upstream commit d3a84a8d0dde4e26bc084b36ffcbdc5932ac85e2 ]

The basic permission bits (protection bits in AmigaOS) have been broken
in Linux' AFFS - it would only set bits, but never delete them.
Also, contrary to the documentation, the Archived bit was not handled.

Let's fix this for good, and set the bits such that Linux and classic
AmigaOS can coexist in the most peaceful manner.

Also, update the documentation to represent the current state of things.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Max Staudt <max@enpas.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/affs.txt | 16 ++++++++++------
 fs/affs/amigaffs.c                 | 27 +++++++++++++++++++++++++++
 fs/affs/file.c                     | 26 +++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/affs.txt b/Documentation/filesystems/affs.txt
index 71b63c2b98410..a8f1a58e36922 100644
--- a/Documentation/filesystems/affs.txt
+++ b/Documentation/filesystems/affs.txt
@@ -93,13 +93,15 @@ The Amiga protection flags RWEDRWEDHSPARWED are handled as follows:
 
   - R maps to r for user, group and others. On directories, R implies x.
 
-  - If both W and D are allowed, w will be set.
+  - W maps to w.
 
   - E maps to x.
 
-  - H and P are always retained and ignored under Linux.
+  - D is ignored.
 
-  - A is always reset when a file is written to.
+  - H, S and P are always retained and ignored under Linux.
+
+  - A is cleared when a file is written to.
 
 User id and group id will be used unless set[gu]id are given as mount
 options. Since most of the Amiga file systems are single user systems
@@ -111,11 +113,13 @@ Linux -> Amiga:
 
 The Linux rwxrwxrwx file mode is handled as follows:
 
-  - r permission will set R for user, group and others.
+  - r permission will allow R for user, group and others.
+
+  - w permission will allow W for user, group and others.
 
-  - w permission will set W and D for user, group and others.
+  - x permission of the user will allow E for plain files.
 
-  - x permission of the user will set E for plain files.
+  - D will be allowed for user, group and others.
 
   - All other flags (suid, sgid, ...) are ignored and will
     not be retained.
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index a148c7ecb35d3..c1b344e56e855 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -417,24 +417,51 @@ mode_to_prot(struct inode *inode)
 	u32 prot = AFFS_I(inode)->i_protect;
 	umode_t mode = inode->i_mode;
 
+	/*
+	 * First, clear all RWED bits for owner, group, other.
+	 * Then, recalculate them afresh.
+	 *
+	 * We'll always clear the delete-inhibit bit for the owner, as that is
+	 * the classic single-user mode AmigaOS protection bit and we need to
+	 * stay compatible with all scenarios.
+	 *
+	 * Since multi-user AmigaOS is an extension, we'll only set the
+	 * delete-allow bit if any of the other bits in the same user class
+	 * (group/other) are used.
+	 */
+	prot &= ~(FIBF_NOEXECUTE | FIBF_NOREAD
+		  | FIBF_NOWRITE | FIBF_NODELETE
+		  | FIBF_GRP_EXECUTE | FIBF_GRP_READ
+		  | FIBF_GRP_WRITE   | FIBF_GRP_DELETE
+		  | FIBF_OTR_EXECUTE | FIBF_OTR_READ
+		  | FIBF_OTR_WRITE   | FIBF_OTR_DELETE);
+
+	/* Classic single-user AmigaOS flags. These are inverted. */
 	if (!(mode & 0100))
 		prot |= FIBF_NOEXECUTE;
 	if (!(mode & 0400))
 		prot |= FIBF_NOREAD;
 	if (!(mode & 0200))
 		prot |= FIBF_NOWRITE;
+
+	/* Multi-user extended flags. Not inverted. */
 	if (mode & 0010)
 		prot |= FIBF_GRP_EXECUTE;
 	if (mode & 0040)
 		prot |= FIBF_GRP_READ;
 	if (mode & 0020)
 		prot |= FIBF_GRP_WRITE;
+	if (mode & 0070)
+		prot |= FIBF_GRP_DELETE;
+
 	if (mode & 0001)
 		prot |= FIBF_OTR_EXECUTE;
 	if (mode & 0004)
 		prot |= FIBF_OTR_READ;
 	if (mode & 0002)
 		prot |= FIBF_OTR_WRITE;
+	if (mode & 0007)
+		prot |= FIBF_OTR_DELETE;
 
 	AFFS_I(inode)->i_protect = prot;
 }
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 659c579c4588b..38e0fd4caf2bb 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -426,6 +426,24 @@ static int affs_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+static int affs_write_end(struct file *file, struct address_space *mapping,
+			  loff_t pos, unsigned int len, unsigned int copied,
+			  struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	int ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+
+	/* Clear Archived bit on file writes, as AmigaOS would do */
+	if (AFFS_I(inode)->i_protect & FIBF_ARCHIVED) {
+		AFFS_I(inode)->i_protect &= ~FIBF_ARCHIVED;
+		mark_inode_dirty(inode);
+	}
+
+	return ret;
+}
+
 static sector_t _affs_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,affs_get_block);
@@ -435,7 +453,7 @@ const struct address_space_operations affs_aops = {
 	.readpage = affs_readpage,
 	.writepage = affs_writepage,
 	.write_begin = affs_write_begin,
-	.write_end = generic_write_end,
+	.write_end = affs_write_end,
 	.direct_IO = affs_direct_IO,
 	.bmap = _affs_bmap
 };
@@ -793,6 +811,12 @@ done:
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
+	/* Clear Archived bit on file writes, as AmigaOS would do */
+	if (AFFS_I(inode)->i_protect & FIBF_ARCHIVED) {
+		AFFS_I(inode)->i_protect &= ~FIBF_ARCHIVED;
+		mark_inode_dirty(inode);
+	}
+
 err_first_bh:
 	unlock_page(page);
 	page_cache_release(page);
-- 
2.25.1



