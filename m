Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E43E5947D7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbiHOXRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353050AbiHOXPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:15:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F003146CC2;
        Mon, 15 Aug 2022 13:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0F48B80EA8;
        Mon, 15 Aug 2022 20:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42218C433C1;
        Mon, 15 Aug 2022 20:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593766;
        bh=xUM//LR8mCZ5HV/uPUUTtp7F7cgtfU222nJBmpBQiGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRHIALxyoXAT2GfCKBfX74zu5m1ipsaRedMaBUuxYzou32Kb8Aa1WAG0o2lxb1NVI
         ie/as9OHqOcQ8PulC/nvbnPEnJSLFLErBWQ8eIqnCu6uVKCIDOoNiGAbzIrdDULocT
         376TJqkMA5LN2DIBiU2D5jEXwzB3jJdIpP2txWxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0322/1157] drm: bridge: adv7511: Move CEC definitions to adv7511_cec.c
Date:   Mon, 15 Aug 2022 19:54:38 +0200
Message-Id: <20220815180452.535207812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 91776af1d8deb8f36cbec6bf2bf24b661b2b5cbb ]

ADV7511_REG_CEC_RX_FRAME_HDR[] and ADV7511_REG_CEC_RX_FRAME_LEN[]
are only used inside adv7511_cec.c.

Move their definitions to this file to avoid the following build
warnings when CONFIG_DRM_I2C_ADV7511_CEC is not selected:

drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: ab0af093bf90 ("drm: bridge: adv7511: use non-legacy mode for CEC RX")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525215316.1133057-1-festevam@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511.h     | 12 ------------
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c | 12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index 9e3bb8a8ee40..a031a0cd1f18 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -226,18 +226,6 @@
 #define ADV7511_REG_CEC_CLK_DIV		0x4e
 #define ADV7511_REG_CEC_SOFT_RESET	0x50
 
-static const u8 ADV7511_REG_CEC_RX_FRAME_HDR[] = {
-	ADV7511_REG_CEC_RX1_FRAME_HDR,
-	ADV7511_REG_CEC_RX2_FRAME_HDR,
-	ADV7511_REG_CEC_RX3_FRAME_HDR,
-};
-
-static const u8 ADV7511_REG_CEC_RX_FRAME_LEN[] = {
-	ADV7511_REG_CEC_RX1_FRAME_LEN,
-	ADV7511_REG_CEC_RX2_FRAME_LEN,
-	ADV7511_REG_CEC_RX3_FRAME_LEN,
-};
-
 #define ADV7533_REG_CEC_OFFSET		0x70
 
 enum adv7511_input_clock {
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
index 399f625a50c8..0b266f28f150 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
@@ -15,6 +15,18 @@
 
 #include "adv7511.h"
 
+static const u8 ADV7511_REG_CEC_RX_FRAME_HDR[] = {
+	ADV7511_REG_CEC_RX1_FRAME_HDR,
+	ADV7511_REG_CEC_RX2_FRAME_HDR,
+	ADV7511_REG_CEC_RX3_FRAME_HDR,
+};
+
+static const u8 ADV7511_REG_CEC_RX_FRAME_LEN[] = {
+	ADV7511_REG_CEC_RX1_FRAME_LEN,
+	ADV7511_REG_CEC_RX2_FRAME_LEN,
+	ADV7511_REG_CEC_RX3_FRAME_LEN,
+};
+
 #define ADV7511_INT1_CEC_MASK \
 	(ADV7511_INT1_CEC_TX_READY | ADV7511_INT1_CEC_TX_ARBIT_LOST | \
 	 ADV7511_INT1_CEC_TX_RETRY_TIMEOUT | ADV7511_INT1_CEC_RX_READY1 | \
-- 
2.35.1



