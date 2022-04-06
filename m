Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5AF4F68AF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbiDFSNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbiDFSNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:13:10 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEBFD3737
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 09:50:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t13so2670822pgn.8
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 09:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GW2h7uu/G+YD6BBAeZyxfMtvERVI7M6Q3BgRXDcSV4A=;
        b=a1KL0Vafp4K4XREnlA3e1N5MECziD/SZsjf2K+Hpuv5hfmogDWxNdlysx3Ekb7TEdn
         5wsbHuueaPKFcONHLT/5VJHooiOyzZquXUwtNyRKM4phqPPG0GKMoM1XtreweA3Ixn8Z
         mKYJZREC9gTSGJAxjq4/9OA3961nSCP+Jzi+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GW2h7uu/G+YD6BBAeZyxfMtvERVI7M6Q3BgRXDcSV4A=;
        b=V+nvlLAsk2RC8FWxTC9/X3Z5knyOV+VLdCEMmrhO+hSHh2+nLhkzoDMLm7aayEOkva
         niNCRYDa4SbV6LrtnKDlAmrv5v+bSc8ogZOpyjpWeJU+8t6C8Xx4T1paogEHlNlZLuQg
         vgs/8ynhOrWDcC/FxVV5Y0lavEP374LNiQ0q+2q9DkxorgY93jxXou5zWdWi7sFsZCo5
         +ZBFC/Rj0ZfSWizoqWLDZT2OBaP8LYZ12d8ZDOXlyJ7hUuoKoehtTn4iuTigxkUT6Gii
         8mW2I7JXZTdt6UIg/DxwcCjadyOV4Tc619HU1VSjyiahvHZM+77aPHe7fwhrcNtLDBKb
         It1w==
X-Gm-Message-State: AOAM531eAuu2urJbNmOhScsIm4gB17+H+9dRhxFpmcIOxfxvFtI7Iz6P
        mPBu0SqvK8NIXZxnnLOZEdnlGw==
X-Google-Smtp-Source: ABdhPJzw8im6C+w2FNo2HMIGFsmoGHqaaZ0XpHY9mxxQOUtuyAq8unohXz0ANiytA4yABbl1dnmDtw==
X-Received: by 2002:a63:5023:0:b0:399:2202:2f80 with SMTP id e35-20020a635023000000b0039922022f80mr7766059pgb.621.1649263830920;
        Wed, 06 Apr 2022 09:50:30 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:c9d3:469f:91e4:c022])
        by smtp.gmail.com with UTF8SMTPSA id x5-20020aa79a45000000b00504a1c8b75asm101255pfj.165.2022.04.06.09.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 09:50:30 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     jic23@kernel.org, robh+dt@kernel.org, swboyd@chromium.org
Cc:     linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v4 1/8] iio: sx9324: Fix default precharge internal resistance register
Date:   Wed,  6 Apr 2022 09:50:04 -0700
Message-Id: <20220406165011.10202-2-gwendal@chromium.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220406165011.10202-1-gwendal@chromium.org>
References: <20220406165011.10202-1-gwendal@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the default value for the register that set the resistance:
it has to be 0x10 per datasheet.

Fixes: 4c18a890dff8d ("iio:proximity:sx9324: Add SX9324 support")
Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
Changes since v3:
- Fix commit, use RESERVED instead of RSVD.
Changes since v2:
- no changes

Changes since v1:
- new patch.

 drivers/iio/proximity/sx9324.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
index 0d9bbbb50cb45..378c2a17bae6e 100644
--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -70,7 +70,8 @@
 #define SX9324_REG_AFE_PH2		0x2a
 #define SX9324_REG_AFE_PH3		0x2b
 #define SX9324_REG_AFE_CTRL8		0x2c
-#define SX9324_REG_AFE_CTRL8_RESFILTN_4KOHM 0x02
+#define SX9324_REG_AFE_CTRL8_RESERVED	0x10
+#define SX9324_REG_AFE_CTRL8_RESFILTIN_4KOHM 0x02
 #define SX9324_REG_AFE_CTRL9		0x2d
 #define SX9324_REG_AFE_CTRL9_AGAIN_1	0x08
 
@@ -781,7 +782,8 @@ static const struct sx_common_reg_default sx9324_default_regs[] = {
 	{ SX9324_REG_AFE_PH2, 0x1a },
 	{ SX9324_REG_AFE_PH3, 0x16 },
 
-	{ SX9324_REG_AFE_CTRL8, SX9324_REG_AFE_CTRL8_RESFILTN_4KOHM },
+	{ SX9324_REG_AFE_CTRL8, SX9324_REG_AFE_CTRL8_RESERVED |
+		SX9324_REG_AFE_CTRL8_RESFILTIN_4KOHM },
 	{ SX9324_REG_AFE_CTRL9, SX9324_REG_AFE_CTRL9_AGAIN_1 },
 
 	{ SX9324_REG_PROX_CTRL0, SX9324_REG_PROX_CTRL0_GAIN_1 |
-- 
2.35.1.1094.g7c7d902a7c-goog

