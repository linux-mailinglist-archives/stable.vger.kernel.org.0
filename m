Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1145E30A064
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 03:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhBACyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 21:54:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31095 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhBACyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 21:54:45 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210201025403epoutp039922529c6e5cc52273afa15430388483~fgBqJPfHb1288212882epoutp03Y
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:54:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210201025403epoutp039922529c6e5cc52273afa15430388483~fgBqJPfHb1288212882epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612148043;
        bh=VEZOXoRkxLtN6V/2vzrL9humPSo75IDKZ3zXpu5YMqg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=h8IpR0uLm6tgHU35NHuwX9IDWrqBI1uWI10t8suQztojaoGK4b7pK5OUmAdnD/XBx
         wXDCi50sjdhkvceioKqUgiGjiQdatRADEGEOBWvYsC9tP/LEzDZFC9rZ2skcB1ntI/
         r47iQQWfZNC71FqUkWvv/t2OwV2SG8268QyGIzNw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210201025402epcas1p27edc871f378ca195afdae6d6b17e1bd4~fgBpsMpKX0607906079epcas1p2f;
        Mon,  1 Feb 2021 02:54:02 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.160]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DTXZw3L7Lz4x9QB; Mon,  1 Feb
        2021 02:54:00 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.A4.09577.74D67106; Mon,  1 Feb 2021 11:53:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210201025358epcas1p46c6943424d296e8ba46b361d637d0068~fgBmLdLg42965529655epcas1p4h;
        Mon,  1 Feb 2021 02:53:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210201025358epsmtrp2ec2b520dea05056e78ec793433d5c05d~fgBmK3iY43115131151epsmtrp2J;
        Mon,  1 Feb 2021 02:53:58 +0000 (GMT)
X-AuditID: b6c32a39-bfdff70000002569-27-60176d47c6d0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.96.13470.64D67106; Mon,  1 Feb 2021 11:53:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210201025358epsmtip164cac168eca42918c833f98fabcc70bd~fgBl8UTbD2829228292epsmtip1x;
        Mon,  1 Feb 2021 02:53:58 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     rdunlap@infradead.org, sj1557.seo@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] exfat: fix shift-out-of-bounds in exfat_fill_super()
Date:   Mon,  1 Feb 2021 11:46:20 +0900
Message-Id: <20210201024620.2178-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7bCmga57rniCwZOvnBZ79p5ksfgxvd7i
        7Z3pLBZb/h1htViw8RGjA6vH5hVaHn1bVjF6fN4kF8AclWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFCgV5yYW1yal66XnJ9rZWhgYGQKVJmQkzF9wUf2gptKFYt7XzA3MPbLdjFy
        cEgImEh8u8jZxcjFISSwg1FictdGJgjnE6PEhgkv2SCcb4wSXz9OZu9i5ITouLeEHSKxl1Hi
        592pjHAtT9a9ZgOZyyagLfFniyiIKSKgKHH5vRNIL7NAkcTqe8+ZQGxhAQ+J97cPsoHYLAKq
        EluebWYCKecVsJZYPM8TYpW8xOoNB5hBpksItLNL3D33mgUi4SJxeE0LI4QtLPHq+Bao26Qk
        Pr/bywbxWbXEx/3MEOEORokX320hbGOJm+s3sIKUMAtoSqzfpQ8RVpTY+XsuI8SVfBLvvvaw
        QkzhlehoE4IoUZXou3SYCcKWluhq/wC11ENizqlvYK1CArESc/uaGScwys5CWLCAkXEVo1hq
        QXFuemqxYYEpcgRtYgQnIC3LHYzT337QO8TIxMF4iFGCg1lJhPfUJLEEId6UxMqq1KL8+KLS
        nNTiQ4ymwNCayCwlmpwPTIF5JfGGpkbGxsYWJmbmZqbGSuK8SQYP4oUE0hNLUrNTUwtSi2D6
        mDg4pRqYnB7K9bMsbrW36OXYtTtdivnpFU4334eHDs3ZyHfJg5+7qmb97LcVTO8jG74+f5n/
        Wc5PZBVfynrPmiWfyuXj3s3zvfo4Vk98hUL9PB5TvpDWyK/+vWVNRZH/i/79Ynl4XkfU3y97
        ksM69pv6llmTKue/66my13pw91DMwc7ZBQpvNk87x+p+cOI7zYVKdwrf9XBtOBW7JefBguTl
        E7YUSF46GqpQyRXJ1NZn8fqfsuiGKSYrdzLcKrnk5c5VUXJ+aam0VfL3tw88K2y7b/YermVt
        2XOJd/2ueYc6W8v3aDSt0hdYJ6Fx/NC0Mzsermnr3Plq7uUteQ5KP4UuOObO6/z7R1jumiKv
        00mbwJhdSizFGYmGWsxFxYkAjYPP2MkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsWy7bCSnK5brniCwcndGhZ79p5ksfgxvd7i
        7Z3pLBZb/h1htViw8RGjA6vH5hVaHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJUxfcFH9oKb
        ShWLe18wNzD2y3YxcnJICJhIfLu3hB3EFhLYzSixaQU3RFxa4tiJM8xdjBxAtrDE4cPFECUf
        GCXabkqDhNkEtCX+bBEFMUUEFCUuv3cCqWAWKJNoWNsMNlBYwEPi/e2DbCA2i4CqxJZnm5lA
        ynkFrCUWz/OE2CMvsXrDAeYJjDwLGBlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIE
        h4OW5g7G7as+6B1iZOJgPMQowcGsJMJ7apJYghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n
        44UE0hNLUrNTUwtSi2CyTBycUg1ME06+81z+RHfOgYhbs46E11g1lxj+yozc6atS1e1hw8e/
        OlDNdb/b27YHkus9a1MPPXzL91ck4PuDfFPv5D2BlZ/nys5bsTVzg/Mk8aSfTHxrvjNUi559
        cMa4vN8q1C9W1+SZjePnW1lJJf1m8f13619HnTi7fk3Hoa7WBZVT6teea5+WLvBHvy7IbPta
        tXylyl9vNUR+9Mk8+7J4m9+mlWX6+WFS+e7ftyh9vMN7JLb9189Y32sdldaMymySMjt+OW2r
        +afVXp2v5vzud87XBbNVJrIcPlN/S/Hr3h6hmoMzt4ly9d9aPePaNzOHK3w71lp82mXS0XnT
        6m1wMcsyeYmmXRlc2YbBAiGnbRcqsRRnJBpqMRcVJwIAT/f4tHYCAAA=
X-CMS-MailID: 20210201025358epcas1p46c6943424d296e8ba46b361d637d0068
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210201025358epcas1p46c6943424d296e8ba46b361d637d0068
References: <CGME20210201025358epcas1p46c6943424d296e8ba46b361d637d0068@epcas1p4.samsung.com>
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
---
v2:
 - change at most sect_per_clus_bits from 16 to 25 - sect_size_bits.

 fs/exfat/exfat_raw.h |  4 ++++
 fs/exfat/super.c     | 31 ++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/exfat_raw.h b/fs/exfat/exfat_raw.h
index 6aec6288e1f2..7f39b1c6469c 100644
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
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 87be5bfc31eb..c6d8d2e53486 100644
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

