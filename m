Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FCE2D0D29
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 10:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLGJiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 04:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgLGJiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 04:38:10 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6931AC0613D1;
        Mon,  7 Dec 2020 01:37:30 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id a8so2349574lfb.3;
        Mon, 07 Dec 2020 01:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RnNkd2vYhvmjED9WJj2Nxdy4XlHuVtV7w1DANTVG2FI=;
        b=rh1WFl2WLrhE3ofzat0xeXZC+PtATDeAU/P6F9cLERB999UMGkd86Kypyttndnt4BP
         LnZU+EJi4fy3fOUvRq8ktoo9AnyB/F+f+a/p46GO8fMlfxgHTB4DNwXozokFEf/68ivC
         jn9JcA54mmpIPxqudMS2g3E5W96QeC8DV2zzTPhjLutcS6XkKa89enWpnq4+oMxDkapI
         gC0yUPsyK/ZA3stvSKH6RqpPtEpBv05gSTTKDSGFpfhcmfsVjuilhnPqki6znBTFgrQd
         4LHMzvDtiPAWR4mbwBJTIjzVhJOIxQ3RX9A8ZyRveLwudK8LpTmhNh0Lsp1f6mRQXRcy
         q3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnNkd2vYhvmjED9WJj2Nxdy4XlHuVtV7w1DANTVG2FI=;
        b=eNTNuEBnxmhkI+z74xTALu8u0RKUsJTj1mXlI9OxrUNcthkG+Srw9OB63GgL9d/f0w
         +1hiT7eHamvPyimlZQmoae+FlUziKuCfMN8+hyI4zevXbWb1z5IabsSex9OuZRV9yjZk
         O3MIbuuZi+wBK1+xsSGaUH6uNd7agXNgVJcnDRn5HXR26kADdD7tQpFQGB/oZ26i69WK
         GTHRvBMDa0nq5sfeO+hE8jX7Lo+pfbNDRpK4Ym97iqjr4liVbjQ+GtXqA3Uv3yYxequX
         afg7wWrNe2fVdyo3SdIeNuSSv+iRXr0682vFUXrYvnNXDo64dp5ICjIQzamD/JVXUpcU
         SBOw==
X-Gm-Message-State: AOAM533bz1kPlqXi/UxbIpDsl3z+iUWdRNGNuBoYn2VRUw21/1XbRXQw
        48pra/Wj7kqD5YmRQiblWdfFGjjdY3c3xw==
X-Google-Smtp-Source: ABdhPJxEcaykCb36ckt6dJ+g8AlQOFCGFaGSQjoNu9cPe8H9vffXm0tJ6T4ccMwMHd3yL5xWs/y99A==
X-Received: by 2002:a19:197:: with SMTP id 145mr7980815lfb.483.1607333848927;
        Mon, 07 Dec 2020 01:37:28 -0800 (PST)
Received: from localhost.localdomain ([85.174.193.195])
        by smtp.gmail.com with ESMTPSA id y15sm397014lfg.209.2020.12.07.01.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:37:27 -0800 (PST)
From:   Artem Labazov <123321artyom@gmail.com>
Cc:     123321artyom@gmail.com, stable@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] exfat: Avoid allocating upcase table using kcalloc()
Date:   Mon,  7 Dec 2020 12:34:23 +0300
Message-Id: <20201207093424.833542-1-123321artyom@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <40be01d6cc61$7d23cac0$776b6040$@samsung.com>
References: <40be01d6cc61$7d23cac0$776b6040$@samsung.com>
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

Convert kcalloc/kfree to their kv* variants to eliminate the issue.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Artem Labazov <123321artyom@gmail.com>
---
v2: replace vmalloc with vzalloc to avoid uninitialized memory access
v3: use kv* functions to attempt kmalloc first

 fs/exfat/nls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 675d0e7058c5..314d5407a1be 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -659,7 +659,7 @@ static int exfat_load_upcase_table(struct super_block *sb,
 	unsigned char skip = false;
 	unsigned short *upcase_table;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = kvcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -715,7 +715,7 @@ static int exfat_load_default_upcase_table(struct super_block *sb)
 	unsigned short uni = 0, *upcase_table;
 	unsigned int index = 0;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = kvcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -803,5 +803,5 @@ int exfat_create_upcase_table(struct super_block *sb)
 
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
-	kfree(sbi->vol_utbl);
+	kvfree(sbi->vol_utbl);
 }
-- 
2.26.2

