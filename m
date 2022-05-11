Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07BB523CF3
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 20:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346525AbiEKS7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346511AbiEKS7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 14:59:38 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE956D3A6
        for <stable@vger.kernel.org>; Wed, 11 May 2022 11:59:37 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 204so2770693pfx.3
        for <stable@vger.kernel.org>; Wed, 11 May 2022 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sGAQG8dHMKLn+nlsPe/05icv+DfBZPnqj5ZoB1g/UQ=;
        b=wZV2E92PHLNHqME2ISGsoc8JZxSNdYWfG7d8y4/9sA4UeBrjX1Vx2Lace/4dA85wk/
         ILfvKj3XjG9cZVCAMKPAxH9lD20VM/AU9unfqDjD87cKBUMCZlomMOd4AzaKSK1xKvNB
         CkTgogQZZzeMoIua3YYxVoJXzIihcZkqfezwAmDOP8/yQ3R/96KXJ5qMJzs/OBEn9VBc
         k518IQ6IuQmkA1P0vgEWvo/UhHsLVcrx/az0T5DjM4u7YSmsRzDE2s2fZV91WspwRWnj
         yW9jzGWJ71P0TFhoqwFQFiMNKF9y1j5QfYjC3RP1tqfnt40r4lgH8M8gjv7h1+kYa12i
         CaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sGAQG8dHMKLn+nlsPe/05icv+DfBZPnqj5ZoB1g/UQ=;
        b=JWVClmCG2Kn7iPX2btLFuOSFx6jRr8AZktCi7txG4u+fUUs1CP/6uuzvGDEmeTOjc6
         OTbG4y8odwraRPs6j+6O571b45lwIFpnOtui4/E2VgvOnxgNzhwMJ0mgl+stcleaa/Vi
         1jgIPOV+OxNk4LG4VXlNODsSU92Ezg7WcsxyoJa9/08lIOaB+gpdFXYVGvqn8n0qwnG2
         6hg0tS5LJrIZmRytpJP164EXg/idbrfdXaDg+M3CfI3Ppw5MZvOb1JWcwVIzyusVkG87
         N2+rq5+E7nqiVBTevBmgByXgIGdib13g9WwIhPMzH0TyGEpnMzCv1tl8a2KvFc8L1EuJ
         hGPg==
X-Gm-Message-State: AOAM531FOxxYzLs/8bFNduakVo9avENCJi8g+ZWVbTEbGaFVvq8LOGpB
        Eurxipt7K3qicY8pdhcQX7COZw==
X-Google-Smtp-Source: ABdhPJyuiOoKNfa17Y3IGmkUvslc+8XNXB9vnFmRfrQOBJZ+U4wDOk7Wf89qsDxFqO0T+kIsUYQY7Q==
X-Received: by 2002:a05:6a00:15d3:b0:510:3c69:b387 with SMTP id o19-20020a056a0015d300b005103c69b387mr26214468pfu.30.1652295576885;
        Wed, 11 May 2022 11:59:36 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id a19-20020a17090aa51300b001d5c571f487sm280709pjq.25.2022.05.11.11.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 11:59:36 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     linkinjeon@kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] exfat: move is_valid_cluster to a common header
Date:   Wed, 11 May 2022 11:59:08 -0700
Message-Id: <20220511185909.175110-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Move the is_valid_cluster() helper from fatent.c to a common
header to make it reusable in other *.c files.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 fs/exfat/exfat_fs.h | 6 ++++++
 fs/exfat/fatent.c   | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index c6800b880920..42d06c68d5c5 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -381,6 +381,12 @@ static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		EXFAT_RESERVED_CLUSTERS;
 }
 
+static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
+		unsigned int clus)
+{
+	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
+}
+
 /* super.c */
 int exfat_set_volume_dirty(struct super_block *sb);
 int exfat_clear_volume_dirty(struct super_block *sb);
diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index a3464e56a7e1..421c27353104 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -81,12 +81,6 @@ int exfat_ent_set(struct super_block *sb, unsigned int loc,
 	return 0;
 }
 
-static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
-		unsigned int clus)
-{
-	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
-}
-
 int exfat_ent_get(struct super_block *sb, unsigned int loc,
 		unsigned int *content)
 {
-- 
2.36.1

