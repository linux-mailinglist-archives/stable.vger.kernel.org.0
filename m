Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DAE65848C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiL1Q6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiL1Q53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4860D1929A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBA89B8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4236FC433D2;
        Wed, 28 Dec 2022 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246428;
        bh=Cor8swcP0qAWcg+ypKfV1BiE+5LdDXUHnzurt0BoCp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjmpAbKJzdwcOFmM7+jaHfhXUCPV7vJ6zceJtEfsEzN12R8E/In1JEjgVTI9VstjA
         TRYY0Ajvl+sOJUC91dvHb5kcWhptvHhN7zx9627btx9XlqFQaZbzsJPediAYYvjKAR
         wm5Ww0dFR2KDfo1TVShXjWVKL0U8UJ4feHel9m1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Duy Nguyen <duy.nguyen.rh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1039/1146] mmc: renesas_sdhi: add quirk for broken register layout
Date:   Wed, 28 Dec 2022 15:42:58 +0100
Message-Id: <20221228144358.567720507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ec9e80ae1719de541c719116a1ca0a0c70e9240c ]

Some early Gen3 SoCs have the DTRANEND1 bit at a different location than
all later SoCs. Because we need the bit soon, add a quirk so we know
which bit to use.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20221006190452.5316-5-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi.h               | 1 +
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/renesas_sdhi.h b/drivers/mmc/host/renesas_sdhi.h
index c4abfee1ebae..e4c490729c98 100644
--- a/drivers/mmc/host/renesas_sdhi.h
+++ b/drivers/mmc/host/renesas_sdhi.h
@@ -44,6 +44,7 @@ struct renesas_sdhi_quirks {
 	bool fixed_addr_mode;
 	bool dma_one_rx_only;
 	bool manual_tap_correction;
+	bool old_info1_layout;
 	u32 hs400_bad_taps;
 	const u8 (*hs400_calib_table)[SDHI_CALIB_TABLE_MAX];
 };
diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 42937596c4c4..7c81c2680701 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -49,7 +49,8 @@
 /* DM_CM_INFO1 and DM_CM_INFO1_MASK */
 #define INFO1_CLEAR		0
 #define INFO1_MASK_CLEAR	GENMASK_ULL(31, 0)
-#define INFO1_DTRANEND1		BIT(17)
+#define INFO1_DTRANEND1		BIT(20)
+#define INFO1_DTRANEND1_OLD	BIT(17)
 #define INFO1_DTRANEND0		BIT(16)
 
 /* DM_CM_INFO2 and DM_CM_INFO2_MASK */
@@ -165,6 +166,7 @@ static const struct renesas_sdhi_quirks sdhi_quirks_4tap_nohs400_one_rx = {
 	.hs400_disabled = true,
 	.hs400_4taps = true,
 	.dma_one_rx_only = true,
+	.old_info1_layout = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_4tap = {
-- 
2.35.1



