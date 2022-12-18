Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C176500B0
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiLRQR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiLRQRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:17:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62317BE10;
        Sun, 18 Dec 2022 08:07:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6681FB80BA5;
        Sun, 18 Dec 2022 16:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3065BC433EF;
        Sun, 18 Dec 2022 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379639;
        bh=Cor8swcP0qAWcg+ypKfV1BiE+5LdDXUHnzurt0BoCp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz1ric5EQmlQlqspcNi6FyxbvN08DTzNJHEg2GJuVmV0ETn1bjUlcSOqbQd5hexxE
         Mo6kCShS4fuyrxZTVGYcUQHeAvqAoysLJ0gQdKW2mt8qdxKk2FtwaRPA3Loq8k6SfV
         qj4pLdE8mz+rfzHqAaJ6MZgRdxXYJP4sPlcPzIzKjkk96uCmyOr6Xa3xPxELxElFtv
         rFXTlAjsDsQtoRpjZyo3islaD3XBN4nyi+uvgcrwzk6lYokc0U0JevQhCyk/I7NlUq
         eilEBaP4mRRW4kwi4w+oYcsyhiYHZz3Pe+1UNBS5HbWzyflLyo7rRcRVqOOcloTkwI
         QKbBM5RnS/vsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Duy Nguyen <duy.nguyen.rh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 76/85] mmc: renesas_sdhi: add quirk for broken register layout
Date:   Sun, 18 Dec 2022 11:01:33 -0500
Message-Id: <20221218160142.925394-76-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

