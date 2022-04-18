Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73520505D91
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 19:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241994AbiDRRmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 13:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237365AbiDRRmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 13:42:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3035234665
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 10:39:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c23so12947823plo.0
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/6jEswmwOAmnHJw/Z7NeFz92t2kSVNLzcVtS0Sf4kA=;
        b=RIdfh/Cx5VQRx41iMREwtJZLMcZj0gF41mm2ff3l/BFEvW8d773E2rDfXT6Zj+p18P
         wGUyW1kl9TUd9wp14H7XQTV/CR4M1q9fgf2giFEmt4e56IyhoHqQVKjEAtlo/Ha9mXey
         bbUNisaaxbYWoQgdxdq7vmNibfYgXZkBoib8/ZdspXWolt45K7+jg4RGzQoP9OYhGDKI
         KDhNbao0ELHEW2R/WXRIahnszeb/Y0B1PCwXWSa/Iv7W1VqpSs/J/2oDnrDFYwDcnVU1
         LysHLHDVFf77gH3neJkj97FDN7mbJpKqrJt9Rb4IXWwK8g+ieNRJucPdnSjU/PlInR0c
         YXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/6jEswmwOAmnHJw/Z7NeFz92t2kSVNLzcVtS0Sf4kA=;
        b=EaXhBFcP+bvD5Y+imf5xkY4P5huCpr1hIV+hfMD3/QtZ4simO6iYu8mjv/BZcne2v9
         RJJOAiSGynaZ/u0lDEHx1QWtnA1u6i49R5jznV/Y7YU4ZzXyRCbM8d/dHhuw7xMnS/xl
         N0wWx8qtzKX6T4LwokiwjwRJ9GSsHvOVAhwBiu1Cf5h2NKzcCf/frT8mw4eLTVn+IzIB
         hYks9NoK3EKg+O/+7Y0eCEX07GA+L1TnP7jydWC7vu9xJks7+MBgMoCSr13DZkjwDmKR
         d10OZT5Vcw/MzW15hP5P91WBDPjzAOkSeVh1iTnmHkdCi1kayT+uz/UaLCoqVyW0+c19
         QwLw==
X-Gm-Message-State: AOAM533WT/lLVxp1usGS1azwk5sxSA+jwTm3Gy6tjobSDyS8OChsrY7f
        gZAuLmLQnifU4opV3VAgEBrHUw==
X-Google-Smtp-Source: ABdhPJx7X8qxRF/0CUmEkmDMmpwMka7fQnEnV5qlU+xAcna/NC7jX6aXDDXnHzq5S4ArvSDg2uZBFQ==
X-Received: by 2002:a17:90b:17c6:b0:1d2:8450:49b3 with SMTP id me6-20020a17090b17c600b001d2845049b3mr8724918pjb.246.1650303581711;
        Mon, 18 Apr 2022 10:39:41 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090a294600b001cba3274bd0sm17159326pjf.28.2022.04.18.10.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 10:39:41 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Subject: [PATCH] exfat: check if cluster num is valid
Date:   Mon, 18 Apr 2022 10:39:23 -0700
Message-Id: <20220418173923.193173-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
This was triggered by reproducer calling truncate with size 0,
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
 fs/exfat/balloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 03f142307174..4ed81f86f993 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -149,6 +149,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (clu > EXFAT_DATA_CLUSTER_COUNT(sbi))
+		return -EINVAL;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
@@ -167,6 +170,9 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct exfat_mount_options *opts = &sbi->options;
 
 	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (clu > EXFAT_DATA_CLUSTER_COUNT(sbi))
+		return;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
-- 
2.35.1

