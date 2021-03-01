Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB75132920C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbhCAUii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240483AbhCAUbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:31:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A062D64EE9;
        Mon,  1 Mar 2021 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622121;
        bh=TH1FbZt92s+UcTZJK66IxQhicJvP3lj3ntXyCPqj3kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpPeCDXeVq2qN8iGw/SzR9q4ndifI+6VcgvHsXy7kkXmo1BC9Y74pUzMxDogyaN90
         ty18wNG5mVaikzObYvTUfgFdho82aFV1/O4lrJ3An7XKFzAZ6TTSgcnqF6OzIG5+39
         XiOM917BW+lbRCYksv5aywdNrS4EvCsX40mglbus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+da4fe66aaadd3c2e2d1c@syzkaller.appspotmail.com,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.11 724/775] exfat: fix shift-out-of-bounds in exfat_fill_super()
Date:   Mon,  1 Mar 2021 17:14:52 +0100
Message-Id: <20210301161237.114078624@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 78c276f5495aa53a8beebb627e5bf6a54f0af34f upstream.

syzbot reported a warning which could cause shift-out-of-bounds issue.

Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x183/0x22e lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 exfat_read_boot_sector fs/exfat/super.c:471 [inline]
 __exfat_fill_super fs/exfat/super.c:556 [inline]
 exfat_fill_super+0x2acb/0x2d00 fs/exfat/super.c:624
 get_tree_bdev+0x406/0x630 fs/super.c:1291
 vfs_get_tree+0x86/0x270 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x1937/0x2c50 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

exfat specification describe sect_per_clus_bits field of boot sector
could be at most 25 - sect_size_bits and at least 0. And sect_size_bits
can also affect this calculation, It also needs validation.
This patch add validation for sect_per_clus_bits and sect_size_bits
field of boot sector.

Fixes: 719c1e182916 ("exfat: add super block operations")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: syzbot+da4fe66aaadd3c2e2d1c@syzkaller.appspotmail.com
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/exfat_raw.h |    4 ++++
 fs/exfat/super.c     |   31 ++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

--- a/fs/exfat/exfat_raw.h
+++ b/fs/exfat/exfat_raw.h
@@ -77,6 +77,10 @@
 
 #define EXFAT_FILE_NAME_LEN		15
 
+#define EXFAT_MIN_SECT_SIZE_BITS		9
+#define EXFAT_MAX_SECT_SIZE_BITS		12
+#define EXFAT_MAX_SECT_PER_CLUS_BITS(x)		(25 - (x)->sect_size_bits)
+
 /* EXFAT: Main and Backup Boot Sector (512 bytes) */
 struct boot_sector {
 	__u8	jmp_boot[BOOTSEC_JUMP_BOOT_LEN];
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -381,8 +381,7 @@ static int exfat_calibrate_blocksize(str
 {
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
-	if (!is_power_of_2(logical_sect) ||
-	    logical_sect < 512 || logical_sect > 4096) {
+	if (!is_power_of_2(logical_sect)) {
 		exfat_err(sb, "bogus logical sector size %u", logical_sect);
 		return -EIO;
 	}
@@ -451,6 +450,25 @@ static int exfat_read_boot_sector(struct
 		return -EINVAL;
 	}
 
+	/*
+	 * sect_size_bits could be at least 9 and at most 12.
+	 */
+	if (p_boot->sect_size_bits < EXFAT_MIN_SECT_SIZE_BITS ||
+	    p_boot->sect_size_bits > EXFAT_MAX_SECT_SIZE_BITS) {
+		exfat_err(sb, "bogus sector size bits : %u\n",
+				p_boot->sect_size_bits);
+		return -EINVAL;
+	}
+
+	/*
+	 * sect_per_clus_bits could be at least 0 and at most 25 - sect_size_bits.
+	 */
+	if (p_boot->sect_per_clus_bits > EXFAT_MAX_SECT_PER_CLUS_BITS(p_boot)) {
+		exfat_err(sb, "bogus sectors bits per cluster : %u\n",
+				p_boot->sect_per_clus_bits);
+		return -EINVAL;
+	}
+
 	sbi->sect_per_clus = 1 << p_boot->sect_per_clus_bits;
 	sbi->sect_per_clus_bits = p_boot->sect_per_clus_bits;
 	sbi->cluster_size_bits = p_boot->sect_per_clus_bits +
@@ -477,16 +495,19 @@ static int exfat_read_boot_sector(struct
 	sbi->used_clusters = EXFAT_CLUSTERS_UNTRACKED;
 
 	/* check consistencies */
-	if (sbi->num_FAT_sectors << p_boot->sect_size_bits <
-	    sbi->num_clusters * 4) {
+	if ((u64)sbi->num_FAT_sectors << p_boot->sect_size_bits <
+	    (u64)sbi->num_clusters * 4) {
 		exfat_err(sb, "bogus fat length");
 		return -EINVAL;
 	}
+
 	if (sbi->data_start_sector <
-	    sbi->FAT1_start_sector + sbi->num_FAT_sectors * p_boot->num_fats) {
+	    (u64)sbi->FAT1_start_sector +
+	    (u64)sbi->num_FAT_sectors * p_boot->num_fats) {
 		exfat_err(sb, "bogus data start sector");
 		return -EINVAL;
 	}
+
 	if (sbi->vol_flags & VOLUME_DIRTY)
 		exfat_warn(sb, "Volume was not properly unmounted. Some data may be corrupt. Please run fsck.");
 	if (sbi->vol_flags & MEDIA_FAILURE)


