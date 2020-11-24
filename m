Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1812C302F
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404104AbgKXSvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 13:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgKXSu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 13:50:59 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A49C0613D6;
        Tue, 24 Nov 2020 10:50:59 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a9so30370056lfh.2;
        Tue, 24 Nov 2020 10:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0c/j8cf2nONRA2feQDC3TPehXhvut6OEozhckJatQg=;
        b=tlV+wnM4g4VAxsaddCvjmefIUTYV9ByW3YpTxHnnHOId0pZny8veyAKKUvd8l2qFOw
         rHrnvqkXyxskNtCQcu1gVARTckemeR/UTIrlMsv6aaeXLXkCc1qllmZ4M6OCNfa5+cvR
         hSubX+eoE20ZyG+VDCiK8jUnXF9U2uZHL9qfGII82YZI9vqkRDxjIs57xECz1GuBy59l
         jGmBnUqAamJVMONCkHS7KhBz+ISXIsMXAAGEZYxdb6zIa/RwcTamE+VGm1gBI0/Ldi3J
         fMjTGD5X+ybM4TzIldjLXkNzrxx00VayedVMuCljUoxcBPKup05EKZMvox5rCTWjs+GZ
         cGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0c/j8cf2nONRA2feQDC3TPehXhvut6OEozhckJatQg=;
        b=VDYnoYYIh3HU2rbZOTPbmHSIG6tcOKT77+inOC9IJtYMupIIXiR/WzkbYLfqj6cMv+
         qcJkJZ0MuWcV365o5bNphOotDeJMst2r0Tu+OTvyqzPIi4UDYQGELqbupYHsb2kUnzPU
         cGxTOlDmZb+c0GWf+sUPxsrj3CGjX/xWWnslkZvuog+sahHhvix/YDDTien7sViFMfsm
         2/JOlMwNVGVpkbqd01NScDm+eZpFr1hyLVWnNjp8kY64AUit6lluqnKjtlrsFUKOYepS
         TBJxeV47F4OIQnnUmWg3mXWJENzoBts9P77JS2tsmBoTZa6Ftj7PtTiBtAZ4/oTwWbUr
         rZYg==
X-Gm-Message-State: AOAM530N88MpccUhG9W5ph3pp/dahyOe6Yj4sOUSycSCvBfpqMXwEvyB
        3R7N0L0SkGjRPbB0QQvaTcqyFu0PbQqV4WJ7jeo=
X-Google-Smtp-Source: ABdhPJzt3TLdBN/P4Eq+DV7SDtt4yLBGLaOX/Hm1GZNn2g9gFOHpibQKVx+y8dvkGOMMAHQ8E2lmPw==
X-Received: by 2002:a19:549:: with SMTP id 70mr2081436lff.112.1606243857364;
        Tue, 24 Nov 2020 10:50:57 -0800 (PST)
Received: from localhost.localdomain ([95.153.130.48])
        by smtp.gmail.com with ESMTPSA id d11sm1820698lfa.143.2020.11.24.10.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 10:50:56 -0800 (PST)
From:   Artem Labazov <123321artyom@gmail.com>
Cc:     123321artyom@gmail.com, stable@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Date:   Tue, 24 Nov 2020 21:50:43 +0300
Message-Id: <20201124185043.4037182-1-123321artyom@gmail.com>
X-Mailer: git-send-email 2.26.2
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

Make the driver use vmalloc() to eliminate the issue.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Artem Labazov <123321artyom@gmail.com>
---
 fs/exfat/nls.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 675d0e7058c5..e415794e3ffc 100644
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
+	upcase_table = vmalloc(UTBL_COUNT * sizeof(unsigned short));
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -715,7 +716,7 @@ static int exfat_load_default_upcase_table(struct super_block *sb)
 	unsigned short uni = 0, *upcase_table;
 	unsigned int index = 0;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = vmalloc(UTBL_COUNT * sizeof(unsigned short));
 	if (!upcase_table)
 		return -ENOMEM;
 
-- 
2.26.2

