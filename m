Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5519B299F91
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410317AbgJZXyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410312AbgJZXyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCD2221FA;
        Mon, 26 Oct 2020 23:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756445;
        bh=dbIidrHvO2LTZ1rtd68b6hEu80AhIwSMM0OmTrHsQ/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu3jCKoj/KPfng9JBS5B/VZU0QdNQoN3Cav6gmw7WCJmHNuubPsgZuMEW+GPajtIi
         HkGsh3M4LOGWwmj43wRFtAZQNr+3YImFYBGcVH6t4sE8+6N9Rj7ttkvNpnB2FDzXst
         wO0IRO6LCnv96Te7taKh7i3c8SxzmpPrYUv0Zm2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.8 098/132] f2fs: fix to set SBI_NEED_FSCK flag for inconsistent inode
Date:   Mon, 26 Oct 2020 19:51:30 -0400
Message-Id: <20201026235205.1023962-98-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit d662fad143c0470ad7f46ea7b02da539f613d7d7 ]

If compressed inode has inconsistent fields on i_compress_algorithm,
i_compr_blocks and i_log_cluster_size, we missed to set SBI_NEED_FSCK
to notice fsck to repair the inode, fix it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 44582a4db513e..657a39c82e57d 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -292,6 +292,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 			F2FS_FITS_IN_INODE(ri, fi->i_extra_isize,
 						i_log_cluster_size)) {
 		if (ri->i_compress_algorithm >= COMPRESS_MAX) {
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			f2fs_warn(sbi, "%s: inode (ino=%lx) has unsupported "
 				"compress algorithm: %u, run fsck to fix",
 				  __func__, inode->i_ino,
@@ -300,6 +301,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 		if (le64_to_cpu(ri->i_compr_blocks) >
 				SECTOR_TO_BLOCK(inode->i_blocks)) {
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			f2fs_warn(sbi, "%s: inode (ino=%lx) has inconsistent "
 				"i_compr_blocks:%llu, i_blocks:%llu, run fsck to fix",
 				  __func__, inode->i_ino,
@@ -309,6 +311,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 		if (ri->i_log_cluster_size < MIN_COMPRESS_LOG_SIZE ||
 			ri->i_log_cluster_size > MAX_COMPRESS_LOG_SIZE) {
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			f2fs_warn(sbi, "%s: inode (ino=%lx) has unsupported "
 				"log cluster size: %u, run fsck to fix",
 				  __func__, inode->i_ino,
-- 
2.25.1

