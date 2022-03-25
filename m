Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44904E7D38
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiCYWKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 18:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiCYWKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 18:10:07 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD2B16666B
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 15:08:32 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so4628703pjk.4
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 15:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xOpY+DRdxabYq4KSBS213CEML9vt3FeER5a0RKzlMFw=;
        b=MyU7CSOScAxvn4y5ih8kVLnLZpwiai3vdS4oQBGkVQ8S1ZVu9nJ/eMrF+kSvk3e8Bw
         ufGIGB9wcYmeR0JZSL7dr8FmEUE8LaDvl/2Y/GN9W6HfZ4cu62pZUQsKahTqDrbNmaoO
         E2tbgJCqkciNqUbrwguQLEVNHVUGxH6+WDMkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xOpY+DRdxabYq4KSBS213CEML9vt3FeER5a0RKzlMFw=;
        b=8HBpF8eJELU1I8XBR/3aMzBRGw0N6IFpK/zRffCCSc+/Qp/jEL6OulU4Jcf7aM1koO
         HRVA7JIlffKixhcHxEORZqrLwIt6TId4mG9ZNk2JTQCS+a2tg7mBlUP1kVZPTJs95ZQw
         DR7GTYIbLfxtPwwkEzH4PYbS1eMM2gt5YlOIptdpM4uHJONb4UTsaDV4GsvQ9nk7yvmd
         0Bk9PhPL+v8nYLhJf15SebIzrRCWhlhiblvffs1v3CEbJQ/2aQ98jfMX51sNt+Sf4dnH
         EdAKGCzl0mWtBAG+mA2kySE+QBoixtzA2OwAKvnCVNz3lEPO/ZVPZoHd/a6jpriR3HYL
         AyWw==
X-Gm-Message-State: AOAM533i+934hqQTwFvqu95BSysyIFrKm/PN8VxViUyT91+uPjTIyDKW
        hX2dqsoMAjJO22q4E9htvFr/fw==
X-Google-Smtp-Source: ABdhPJwRy+sx4YMZ0u4xcqx1mVelcnOuRT8sBr0pcXctkoSL8l0tYKp6GIHQ83BMhH92o37IttNGlQ==
X-Received: by 2002:a17:90a:b38b:b0:1c7:9f03:9b4d with SMTP id e11-20020a17090ab38b00b001c79f039b4dmr15206702pjr.170.1648246112370;
        Fri, 25 Mar 2022 15:08:32 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:f21c:980b:7d64:94f9])
        by smtp.gmail.com with UTF8SMTPSA id y15-20020a17090a1f4f00b001c7ecaf9e13sm2909175pjy.35.2022.03.25.15.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 15:08:32 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     jic23@kernel.org, robh+dt@kernel.org, swboyd@chromium.org
Cc:     linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/8] iio: sx9324: Fix default precharge internal resistance register
Date:   Fri, 25 Mar 2022 15:08:20 -0700
Message-Id: <20220325220827.3719273-2-gwendal@chromium.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
In-Reply-To: <20220325220827.3719273-1-gwendal@chromium.org>
References: <20220325220827.3719273-1-gwendal@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the default value for the register that set the resistance:
it has to be 0x10.

Fixes: 4c18a890dff8d ("iio:proximity:sx9324: Add SX9324 support")
Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
Changes since v2:
- no changes

Changes since v1:
- new patch.

 drivers/iio/proximity/sx9324.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
index 0d9bbbb50cb45..d50ce67aafdf2 100644
--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -70,7 +70,8 @@
 #define SX9324_REG_AFE_PH2		0x2a
 #define SX9324_REG_AFE_PH3		0x2b
 #define SX9324_REG_AFE_CTRL8		0x2c
-#define SX9324_REG_AFE_CTRL8_RESFILTN_4KOHM 0x02
+#define SX9324_REG_AFE_CTRL8_RSVD	0x10
+#define SX9324_REG_AFE_CTRL8_RESFILTIN_4KOHM 0x02
 #define SX9324_REG_AFE_CTRL9		0x2d
 #define SX9324_REG_AFE_CTRL9_AGAIN_1	0x08
 
@@ -781,7 +782,8 @@ static const struct sx_common_reg_default sx9324_default_regs[] = {
 	{ SX9324_REG_AFE_PH2, 0x1a },
 	{ SX9324_REG_AFE_PH3, 0x16 },
 
-	{ SX9324_REG_AFE_CTRL8, SX9324_REG_AFE_CTRL8_RESFILTN_4KOHM },
+	{ SX9324_REG_AFE_CTRL8, SX9324_REG_AFE_CTRL8_RSVD |
+		SX9324_REG_AFE_CTRL8_RESFILTIN_4KOHM },
 	{ SX9324_REG_AFE_CTRL9, SX9324_REG_AFE_CTRL9_AGAIN_1 },
 
 	{ SX9324_REG_PROX_CTRL0, SX9324_REG_PROX_CTRL0_GAIN_1 |
-- 
2.35.1.1021.g381101b075-goog

