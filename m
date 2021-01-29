Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E423308658
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 08:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhA2HWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 02:22:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55809 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhA2HWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 02:22:05 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210129072120epoutp04a49d9da12b413a92b32c08c1d3afa5f3~eovLqH92g0140301403epoutp04x
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 07:21:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210129072120epoutp04a49d9da12b413a92b32c08c1d3afa5f3~eovLqH92g0140301403epoutp04x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611904880;
        bh=ZxUrhT4XL07XoRUNd+S7dt9dlQeeyIZW/iU9uD3HH7w=;
        h=From:To:Cc:Subject:Date:References:From;
        b=PAvZ1apRc8JRBO5v3rHTpHBkb5s2qXgfrLkNg8D7WX1UKXgdC/odOZgxUTcfa6PVo
         x/WnKBJg4tC4B0fxPFRz/cuayOUuEjdIjNU+Y0U4lgYjZCo9aT1z5qb2mpaPnP1HNr
         yozcRLxQ3ub/+8psEefkI0twgfd79ntKFDR2pECQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210129072120epcas1p1e3f86d83e9259d06dc8c30e3c4ccb6e4~eovLGo8vf0192401924epcas1p12;
        Fri, 29 Jan 2021 07:21:20 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.160]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DRpfl2bJ9z4x9Q1; Fri, 29 Jan
        2021 07:21:19 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.D3.63458.E67B3106; Fri, 29 Jan 2021 16:21:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210129072117epcas1p29cfb23f0ff88f659b404b1d54fb44ee8~eovI7NpQm0549805498epcas1p2l;
        Fri, 29 Jan 2021 07:21:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210129072117epsmtrp207fd2d2ecd1e7d4710a918ef042602be~eovI6h68I0251502515epsmtrp2K;
        Fri, 29 Jan 2021 07:21:17 +0000 (GMT)
X-AuditID: b6c32a36-6dfff7000000f7e2-e5-6013b76e4740
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.63.08745.D67B3106; Fri, 29 Jan 2021 16:21:17 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210129072117epsmtip1cd58d4e706a6f6603289a2b94cf4e57f~eovIwxIoa0277902779epsmtip16;
        Fri, 29 Jan 2021 07:21:17 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     willy@infradead.org, rdunlap@infradead.org, sj1557.seo@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] exfat: fix shift-out-of-bounds in exfat_fill_super()
Date:   Fri, 29 Jan 2021 16:12:21 +0900
Message-Id: <20210129071222.7582-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmnm7eduEEgzkzhS327D3JYvFjer3F
        2zvTWSy2/DvCarFg4yNGi98/5rA5sHlsXqHl0bdlFaPH501yAcxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGBgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GU8P/mMvmKxYMeHxAqYG
        xhfSXYycHBICJhIvFi5l6mLk4hAS2MEoMfPrXmYI5xOjxO0v3VDOZ0aJ2X0L2WFazt3ZywqR
        2MUosabrEwtIAqxl9/uaLkYODjYBbYk/W0RBTBEBRYnL751AypkF2hklZh2czwxSLizgKrF+
        /RlWEJtFQFViy+l9YGN4Bawl7jzfxwixS15i9YYDYEdICExnl9g77SMTRMJFYvKbWVAHCUu8
        Or4FypaS+PxuLxvIYgmBaomP+5khwh2MEi++20LYxhI3129gBSlhFtCUWL9LHyKsKLHz91yw
        tcwCfBLvvvawQkzhlehoE4IoUZXou3QY6gBpia72D1BLPSSerfzMCAmEWIlHT9+wT2CUnYWw
        YAEj4ypGsdSC4tz01GLDAiPkKNrECE5HWmY7GCe9/aB3iJGJg/EQowQHs5II79s5QglCvCmJ
        lVWpRfnxRaU5qcWHGE2BwTWRWUo0OR+YEPNK4g1NjYyNjS1MzMzNTI2VxHkTDR7ECwmkJ5ak
        ZqemFqQWwfQxcXBKNTCJK+R88Srg8BN38n65x5o1+6nfBok5q/46B00wPb9t1++8dJUYu2Db
        LZxCSzKvKT9hD/wl9XGlhXpx3vQeadXfCw5fT987g+ed86onlifWT0v5t2wF/z43tehp6o35
        K8J2/e+OLLp2ok5M0tG07MD3f+e6yhf/2CuV2pilv3XVxN630XLuJx+L2esvuVGmWLCPf7ad
        3szqG/e1c4xs+wVLRZ0iDrhvDTxQZ7PwyuzSszwrti6xXrCBrSZQ8v4boTNzimaWTu589d60
        e4fL5Ydvyu7mMHXPCFAsW2iTm6mV3Whz6Oo1y+tr1rAfmiPi8PJtBCtb56YOPe47z7OTPXje
        rHSq/cr0g/fdtkv2SaFKLMUZiYZazEXFiQD/ITyR0AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsWy7bCSnG7uduEEg4bZxhZ79p5ksfgxvd7i
        7Z3pLBZb/h1htViw8RGjxe8fc9gc2Dw2r9Dy6NuyitHj8ya5AOYoLpuU1JzMstQifbsEroyn
        B/+xF0xWrJjweAFTA+ML6S5GTg4JAROJc3f2soLYQgI7GCU+HROAiEtLHDtxhrmLkQPIFpY4
        fLgYouQDo8SRB/IgYTYBbYk/W0RBTBEBRYnL7526GLk4mAV6GSWaWrYyg5QLC7hKrF9/Bmw6
        i4CqxJbT+1hAbF4Ba4k7z/cxQmySl1i94QDzBEaeBYwMqxglUwuKc9Nziw0LjPJSy/WKE3OL
        S/PS9ZLzczcxgoNDS2sH455VH/QOMTJxMB5ilOBgVhLhfTtHKEGINyWxsiq1KD++qDQntfgQ
        ozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGppklMlEXvhj/7Tjk4lYdeXVvs53TT52X
        259JzzozYeZBq0frjkzRPrfI5f5m1rzafxmG9lvF+gRaz+6cefXT2lcyyX0Vye9bUwtCb6ye
        Z3/DuY37zITKY1p6heuXbeSZNWnug/WmS04sziv8Oen9kq0XFd90mJ6dPOFczPkwSy9loxtl
        Mss3BAn2xkj+Oj2b/1qOzoWFVWmG75LPnWF2TXT4dWPSw5YPV6ZIKx/7s2mdg+jleSKPvkg+
        rpMy+L9m5/r+XJvc7Fv2GV9kEt67X+f6s3aFsdOZ888Fc1atyD7YdKGdq/RJ09Ni8btXGi3u
        efYY/z4Tmjo/1qB76aRzy822PdUqDfq+7mNNJS//arupSizFGYmGWsxFxYkArwc/CX0CAAA=
X-CMS-MailID: 20210129072117epcas1p29cfb23f0ff88f659b404b1d54fb44ee8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129072117epcas1p29cfb23f0ff88f659b404b1d54fb44ee8
References: <CGME20210129072117epcas1p29cfb23f0ff88f659b404b1d54fb44ee8@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
could be at most 16 and at least 0. And sect_size_bits can also
affect this calculation, It also needs validation.
This patch add validation for sect_per_clus_bits and sect_size_bits
field of boot sector.

Fixes: 719c1e182916 ("exfat: add super block operations")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: syzbot+da4fe66aaadd3c2e2d1c@syzkaller.appspotmail.com
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/exfat_raw.h |  4 ++++
 fs/exfat/super.c     | 31 ++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/exfat_raw.h b/fs/exfat/exfat_raw.h
index 6aec6288e1f2..7c4c356efa5f 100644
--- a/fs/exfat/exfat_raw.h
+++ b/fs/exfat/exfat_raw.h
@@ -77,6 +77,10 @@
 
 #define EXFAT_FILE_NAME_LEN		15
 
+#define EXFAT_MIN_SECT_SIZE_BITS	9
+#define EXFAT_MAX_SECT_SIZE_BITS	12
+#define EXFAT_MAX_SECT_PER_CLUS_BITS	16
+
 /* EXFAT: Main and Backup Boot Sector (512 bytes) */
 struct boot_sector {
 	__u8	jmp_boot[BOOTSEC_JUMP_BOOT_LEN];
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 87be5bfc31eb..ac5a8f7d2397 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -381,8 +381,7 @@ static int exfat_calibrate_blocksize(struct super_block *sb, int logical_sect)
 {
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
-	if (!is_power_of_2(logical_sect) ||
-	    logical_sect < 512 || logical_sect > 4096) {
+	if (!is_power_of_2(logical_sect)) {
 		exfat_err(sb, "bogus logical sector size %u", logical_sect);
 		return -EIO;
 	}
@@ -451,6 +450,25 @@ static int exfat_read_boot_sector(struct super_block *sb)
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
+	 * sect_per_clus_bits could be at least 0 and at most 16.
+	 */
+	if (p_boot->sect_per_clus_bits > EXFAT_MAX_SECT_PER_CLUS_BITS) {
+		exfat_err(sb, "bogus sectors bits per cluster : %u\n",
+				p_boot->sect_per_clus_bits);
+		return -EINVAL;
+	}
+
 	sbi->sect_per_clus = 1 << p_boot->sect_per_clus_bits;
 	sbi->sect_per_clus_bits = p_boot->sect_per_clus_bits;
 	sbi->cluster_size_bits = p_boot->sect_per_clus_bits +
@@ -477,16 +495,19 @@ static int exfat_read_boot_sector(struct super_block *sb)
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
-- 
2.17.1

