Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421742C3159
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 20:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgKXTs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 14:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgKXTs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 14:48:56 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0970FC0613D6;
        Tue, 24 Nov 2020 11:48:55 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l11so30651028lfg.0;
        Tue, 24 Nov 2020 11:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ABczXePjWBXVIgsHwJzVxBg/ziA6ahdg050i6s0ToQ=;
        b=vJBXe9q4Zp32NaiUYF3dR8NC6Vb6CZGE6HXje6hPOVG+BTWi9h7q/G6NeNY32UHhyH
         wv8SG+Riq/WygAE6bVhFUoOCczobyiqzYPdBk8No8vAD/WrrTkDKSejZx+kKeG4LuCeL
         Ngc9GzWptvm7UOXIr6RA0WIO94TUcHfqsrKwMfLngDTPNDdLfxygcf1rgTVNDUo7ngd7
         Oea/TBG5pF03LgACcpdkTPX9uC+CjeAL1Uh8FrwAc1W3LgW4CcKUzyyQ+XxE5wsdJjrH
         CSqoxgdQCJkhtQ2bsAYABhbOLDXS9NvQGVZVWKaKdYsyEbtyhsnTde5VvSs8fI34ZGZG
         BGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ABczXePjWBXVIgsHwJzVxBg/ziA6ahdg050i6s0ToQ=;
        b=bM0agFCUHj1EmuUfPRNNiymQjOUi9yAFbFgHz+9zoW4kw0uMBGcytDtIzSSgmxDHbe
         L/lJxmAfNvjoUvMhSOZhHYk7BbjJMAwI+hgtUj+Get+Kkd1QGe90i6eZYbszSOoFSYrU
         pcC4zlMyfRwH311lte3uztgXpXBo4l/rlC8oJSLEtH4F0RZzIxgQSWH28n7crTFbxfqP
         BEhu/NPSU6oP3ET6av6GAZiolv4Hpyxt07XciqLaOgRo0ZgpffMBrkr28NvDUg69iIec
         2wF+6xw8sZbLheYnbBCkDCFDLPPndAaqh6SME0bnuEyV4YckXMkNMlriaUui+HbXYBh6
         lfvA==
X-Gm-Message-State: AOAM533Z3v2/CAjU+Xqo0xZluo1tB0uVpdW5UJ4CZk6Vw6WQBiPNcdRJ
        B4UkZAW4wLd4ezZfM6Iai84=
X-Google-Smtp-Source: ABdhPJxBjXEKhp5+OLH51KVWid1l1B3nwnTj57EAEXlliB9/hvXXKRA7BVKGdv5VkOKDzpknbhSwSg==
X-Received: by 2002:a19:98d:: with SMTP id 135mr2592195lfj.357.1606247333515;
        Tue, 24 Nov 2020 11:48:53 -0800 (PST)
Received: from localhost.localdomain ([95.153.130.48])
        by smtp.gmail.com with ESMTPSA id f17sm1833232lfc.158.2020.11.24.11.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 11:48:52 -0800 (PST)
From:   Artem Labazov <123321artyom@gmail.com>
Cc:     123321artyom@gmail.com, stable@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Date:   Tue, 24 Nov 2020 22:47:49 +0300
Message-Id: <20201124194749.4041176-1-123321artyom@gmail.com>
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
 fs/exfat/nls.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 675d0e7058c5..0582faf8de77 100644
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
+	upcase_table = vmalloc(UTBL_COUNT*sizeof(unsigned short));
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -715,7 +716,7 @@ static int exfat_load_default_upcase_table(struct super_block *sb)
 	unsigned short uni = 0, *upcase_table;
 	unsigned int index = 0;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = vmalloc(UTBL_COUNT*sizeof(unsigned short));
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

