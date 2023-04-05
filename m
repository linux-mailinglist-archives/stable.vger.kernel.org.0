Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33136D77EC
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjDEJU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDEJU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:20:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9194449C
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 02:20:57 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id r7-20020a17090b050700b002404be7920aso34869698pjz.5
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 02:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680686457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UUGG0UnIKCN5qEoPaOBgNrMnkJlxU/sklsT+gsOkTMM=;
        b=MAdTF7XT7YVCaTWjxlJW9Ihn38xvLJV8eeTHarODYjG2vcT30KY0uTV+OF41gNtDyL
         ebWGshv80mKcME/9nK3DV2b0CMuNVTumjlonauivOyg34MteO02vJXIpEGxe8wrz94I+
         CN9h33adnwlWjs4SHYInu32LzkJ3rA/a3NMvU7LUc5V0e06J88n5cB3dq0tzITtv8j6r
         P5V40vnWGgi+YoTcJ8FptKzC2VsXgZfXTTPVVT6n5fwN3jTbZrZuEDSihF4U/9DK2u+6
         hKbDKSrav5qH0Vnw2ttVpH87ajNkkPMC4IP8Aq2DD1WRKmSQsd1Mkxirsnk/jfnxyf+D
         qgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680686457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUGG0UnIKCN5qEoPaOBgNrMnkJlxU/sklsT+gsOkTMM=;
        b=Sp+Wf7Qa2C1+smFaIbqbsGLxjXjXFIf4YHPjrxfBr2NNy8bvJQh81PYhke+8RF3Spq
         NcmMNfJf3WYHXfZpGYBDKwd9lDB0sWR4PdOzZoGOh2wzAnvUuZnbyv1wrh1+y47zf50j
         40mrUm1MEb0xd0/snsnIFFqEaKczpJn9U4rD8Eb//wxTzg8ZJRmlB6b6J6zBXKYh9D4K
         pfprwhlj1Wh8IuY/j5bW9ngzcyIABSdwstNG1RwNxihdbGTNCcjXHJbfwkagJPj2iFlO
         hdI4hDjuUWWH8IqdiRO9xs0DmN3/8VbMJr++5aHZxpWvTW0qy9Uej7qlIWiaMtUSQUAT
         Fh/g==
X-Gm-Message-State: AAQBX9cGG95UcuRjUCfQAwVv8hoH0YuY0zb+gKSrueKSKPqg/5BA6D8T
        wmiWNnuohsPD2Zr6Uto4H2herQ==
X-Google-Smtp-Source: AKy350ZOfl79l/5fmaoP9sjI60100Aurk4/c5nevLRCb3fE9XKEbXKQ8Pbgl4T4MF9pEFhQblizSQA==
X-Received: by 2002:a17:90b:1a92:b0:23a:8f25:7fd6 with SMTP id ng18-20020a17090b1a9200b0023a8f257fd6mr6185368pjb.29.1680686457089;
        Wed, 05 Apr 2023 02:20:57 -0700 (PDT)
Received: from localhost.localdomain ([49.207.50.231])
        by smtp.gmail.com with ESMTPSA id g15-20020a170902868f00b0019b0afc24e8sm9676678plo.250.2023.04.05.02.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 02:20:56 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
Cc:     Robert Foss <robert.foss@linaro.org>
Subject: [PATCH for-5.10+] drm/bridge: lt9611: Fix PLL being unable to lock
Date:   Wed,  5 Apr 2023 14:50:52 +0530
Message-Id: <20230405092052.3843974-1-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 2a9df204be0bbb896e087f00b9ee3fc559d5a608 ]

This fixes PLL being unable to lock, and is derived from an equivalent
downstream commit.

Available LT9611 documentation does not list this register, neither does
LT9611UXC (which is a different chip).

This commit has been confirmed to fix HDMI output on DragonBoard 845c.

Suggested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221213150304.4189760-1-robert.foss@linaro.org
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---

To be cherry-picked on v5.10.y, v5.15.y and v6.1.y.

 drivers/gpu/drm/bridge/lontium-lt9611.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 3b77238ca4af..ae8c6d9d4095 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -258,6 +258,7 @@ static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode
 		{ 0x8126, 0x55 },
 		{ 0x8127, 0x66 },
 		{ 0x8128, 0x88 },
+		{ 0x812a, 0x20 },
 	};
 
 	regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
-- 
2.25.1

