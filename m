Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE23523CF5
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 20:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346511AbiEKS7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346524AbiEKS7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 14:59:39 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229036D4D5
        for <stable@vger.kernel.org>; Wed, 11 May 2022 11:59:38 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q76so2556040pgq.10
        for <stable@vger.kernel.org>; Wed, 11 May 2022 11:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2MbxQToswSlU3uGoWcNi5INJYQyZuFk9/eAJQ7cdhmM=;
        b=CAnupYTRbk5GC5fKicsn72UhgiuO5+FGnHpN87ZAcpAMVTT4w/YH0sYOJ9/Tc0RzxO
         lQCza6ElQrlD7hiEde2IBjhNwEFNRpfIueSDbPkO7C+mO/Nl7pyoMf/XiMK/Bs8vcn+s
         31Yx8MEdBlvr8VlIy/C27slzdi8rukc9+gAXnIE284BO3FYVBjNKVIlJ7W0eB5J9VuYJ
         8KXyHs1ICf3Hn/Q1lEQWNtVn8DP8lwdxoO+lq9VY7lOInslCI7HV00mzbUq8bxf57lVE
         uVZrHtFwPw3FGwLhoXTPPLgl5vO4eQnTL0pqdJZsUITCwcR3xQVeYjkdmHCnGk0PH94h
         BN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MbxQToswSlU3uGoWcNi5INJYQyZuFk9/eAJQ7cdhmM=;
        b=CFm2TiKMUeCdI/uAWTqIqWZkCJoTWH56Xwn+0cQsssmrh3gCV83VFAGswgoTR8iz/r
         5xNly1YyrwKheFwghx9zV46x9ZDnmUJOesNK62Y0AfLpo2OiD3GEmjOnQ4HvcedeWXNk
         chjq+VOIgyNoT405npvXVHCIeViOYOjE6aC4zYG2E5GPAc4WdshCOJf6+5xeVVdPpHrI
         y0AFVZjb69hU/3mVSO8I+1u+PRtPu2xxuOWvnhNttVMAoAsq4P7RGzp1eZ3huerfm3U+
         WN7PMCiJ1HFqLKjuA85OKu/TBcJ7uWCjQRqMb/Qp7Y+e83oN55VehDrnYtZ5Q/zjguqE
         jYJw==
X-Gm-Message-State: AOAM530JsFGO2imPOc6PUjnZ5thO7nEUCb+9wDcq6EMK2Stzjlxdn2Yh
        ryzO/m4ZZhFUwhw4ey/1Vtqy2g==
X-Google-Smtp-Source: ABdhPJz9bBTfcx7W1OwKidWuK66EB5cdlNK1lVelNf4ILnzBY58KVHr7ms6mzbrWQdITVzEymsyxoA==
X-Received: by 2002:a63:5552:0:b0:3c2:363b:abe1 with SMTP id f18-20020a635552000000b003c2363babe1mr21396007pgm.304.1652295577623;
        Wed, 11 May 2022 11:59:37 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id a19-20020a17090aa51300b001d5c571f487sm280709pjq.25.2022.05.11.11.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 11:59:37 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     linkinjeon@kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] exfat: check if cluster num is valid
Date:   Wed, 11 May 2022 11:59:09 -0700
Message-Id: <20220511185909.175110-2-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220511185909.175110-1-tadeusz.struk@linaro.org>
References: <20220511185909.175110-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
This was triggered by reproducer calling truncute with size 0,
which causes the following trace:

BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
Read of size 8 at addr ffff888115aa9508 by task syz-executor251/365

Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
 print_address_description+0x81/0x3c0 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
 exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
 exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
 __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
 exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
 exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
 notify_change+0xb76/0xe10 fs/attr.c:336
 do_truncate+0x1ea/0x2d0 fs/open.c:65

Add checks to validate if cluster number is within valid range in
exfat_clear_bitmap() and exfat_set_bitmap()

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Link: https://syzkaller.appspot.com/bug?id=50381fc73821ecae743b8cf24b4c9a04776f767c
Reported-by: syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2:
 - Use is_valid_cluster() helper to validate clu
---
 fs/exfat/balloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 03f142307174..92f5b5b5a0d0 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -149,6 +149,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return -EINVAL;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
@@ -167,6 +170,9 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct exfat_mount_options *opts = &sbi->options;
 
 	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
-- 
2.36.1

