Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D26C2CEED3
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 14:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgLDNfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 08:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgLDNfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 08:35:55 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8A4C061A4F;
        Fri,  4 Dec 2020 05:35:08 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l11so7692314lfg.0;
        Fri, 04 Dec 2020 05:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=grbMzTsJqcDR4Cd4hiQ/1qOHj8Oznc7epGwz752bRVo=;
        b=Son2LjQB49gbEZK5xarS9GWUCArTZ2juhOq7BAj4Luw8JIVr0y0vV5bY9x5djKrFA6
         NB7AlKvOTO0HHUXeGRe9j+bq6EVJAge4Fk1ns7yZ7H20bNM84nQ78I4g5xujwIvOcuC5
         y6xVNAro4O7AQbMJxDR2pGegf2s1fWFQ/hV3DIrDQisf9mHjJ+zFDUXB4bR0uRb8q86v
         IIOnyU2LAqgtSMkAnMJuctzCJusmKwHi7D7nrBjrCGKmmfEcm7FTsqlH/blJ5wSfkSkC
         f94sRyUgJM0LoOpxfKrr0CvmgJVeb8FcNpFWwUwKtADQlKhP15hU+ENH//pYKUlMz/NE
         0KtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=grbMzTsJqcDR4Cd4hiQ/1qOHj8Oznc7epGwz752bRVo=;
        b=osn1QHx4oBk5X4oNty2ejeHGUNjnwowuxYoflven34up638fnApgh9BdGBZK/jhuPs
         WehZt4IFe1MKG32bjS3ot2nuVRiVXr/RiBiQ3roOT29ayMGyJJHuFxj39N2PprFja+pG
         iEr0HudtQzUZU6RjMWZXgedt4aJpLRtPWnbZlXW/k4ri3inVMLXLSbou4Vqdb/a8f01F
         Omv50RZQYvltOqCK5MUq1VT8pIXBOVMiWu7I+L+nIPoeFWtFfgjkLQkUOPXin1Wj62v4
         /NKJIP82iVras4PGUzK6xw9qE99xfzqZjY3/xTQOrMuZS/HbXgqHxkSnYuL1G/FRV/L6
         GtXQ==
X-Gm-Message-State: AOAM533dEqQU9uExrwK9eWcJmzumv3TFftVAUANe2+fjNIKOc8NhcmDl
        +BG2ss6w4/XEX4YaULpyjNw=
X-Google-Smtp-Source: ABdhPJxCRHJZ/uYvkJwOq2N/K+wEY3Ou0eI6N3ulQn+0iNOiJFDoj6EZkf/Ks1W4dnZuBZvMAK52ig==
X-Received: by 2002:a19:4293:: with SMTP id p141mr3190551lfa.591.1607088907233;
        Fri, 04 Dec 2020 05:35:07 -0800 (PST)
Received: from localhost.localdomain ([37.78.35.64])
        by smtp.gmail.com with ESMTPSA id u17sm1695146lfq.144.2020.12.04.05.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 05:35:06 -0800 (PST)
From:   Artem Labazov <123321artyom@gmail.com>
Cc:     123321artyom@gmail.com, stable@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] exfat: Avoid allocating upcase table using kcalloc()
Date:   Fri,  4 Dec 2020 16:33:48 +0300
Message-Id: <20201204133348.555024-1-123321artyom@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <001101d6c867$ca8c5730$5fa50590$@samsung.com>
References: <001101d6c867$ca8c5730$5fa50590$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The table for Unicode upcase conversion requires an order-5 allocation,
which may fail on a highly-fragmented system:

 pool-udisksd: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0
 CPU: 4 PID: 3756880 Comm: pool-udisksd Tainted: G     U            5.8.10-200.fc32.x86_64 #1
 Hardware name: Dell Inc. XPS 13 9360/0PVG6D, BIOS 2.13.0 11/14/2019
 Call Trace:
  dump_stack+0x6b/0x88
  warn_alloc.cold+0x75/0xd9
  ? _cond_resched+0x16/0x40
  ? __alloc_pages_direct_compact+0x144/0x150
  __alloc_pages_slowpath.constprop.0+0xcfa/0xd30
  ? __schedule+0x28a/0x840
  ? __wait_on_bit_lock+0x92/0xa0
  __alloc_pages_nodemask+0x2df/0x320
  kmalloc_order+0x1b/0x80
  kmalloc_order_trace+0x1d/0xa0
  exfat_create_upcase_table+0x115/0x390 [exfat]
  exfat_fill_super+0x3ef/0x7f0 [exfat]
  ? sget_fc+0x1d0/0x240
  ? exfat_init_fs_context+0x120/0x120 [exfat]
  get_tree_bdev+0x15c/0x250
  vfs_get_tree+0x25/0xb0
  do_mount+0x7c3/0xaf0
  ? copy_mount_options+0xab/0x180
  __x64_sys_mount+0x8e/0xd0
  do_syscall_64+0x4d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Make the driver use vzalloc() to eliminate the issue.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Artem Labazov <123321artyom@gmail.com>
---
v2: replace vmalloc with vzalloc to avoid uninitialized memory access

 fs/exfat/nls.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 675d0e7058c5..4cb2e2bc8cad 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -6,6 +6,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
+#include <linux/vmalloc.h>
 #include <asm/unaligned.h>
 
 #include "exfat_raw.h"
@@ -659,7 +660,7 @@ static int exfat_load_upcase_table(struct super_block *sb,
 	unsigned char skip = false;
 	unsigned short *upcase_table;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = vzalloc(UTBL_COUNT * sizeof(unsigned short));
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -715,7 +716,7 @@ static int exfat_load_default_upcase_table(struct super_block *sb)
 	unsigned short uni = 0, *upcase_table;
 	unsigned int index = 0;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = vzalloc(UTBL_COUNT * sizeof(unsigned short));
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -803,5 +804,5 @@ int exfat_create_upcase_table(struct super_block *sb)
 
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
-	kfree(sbi->vol_utbl);
+	vfree(sbi->vol_utbl);
 }
-- 
2.26.2

