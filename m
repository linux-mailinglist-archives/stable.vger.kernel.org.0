Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD5E65024D
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiLRQpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbiLRQok (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:44:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A07D633B;
        Sun, 18 Dec 2022 08:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B670060DD3;
        Sun, 18 Dec 2022 16:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603AAC433EF;
        Sun, 18 Dec 2022 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380150;
        bh=UlqfCetC9lVeUfrUiYyJXP/Y9giYq4G5Q9ClWpdr7bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4rJrZ2PlVOtGoRH0EtHO8DRNe1tXqHIqo+NDz8WvUtShBDCxKkVp4yrVEtW5bZNq
         0ySCa0/SqGDHEukBlNgbrDjTA0a8Vv5pJ1964blXV+7mOL4IBRZs1INCZrZzpO1hU0
         OZt9r9ALX0uzX8BaTCAqTnODw8wsEoqdiHO401wV2PZy5hjvowVliFBwfVWtVqPmY4
         tFt3E2cRhEtFMHeLJh/Y58RS+P5SkPlRJg7ofn1McKFZPnvLYhXBdAJhVBEi1opBRM
         fbP8cwuSdPv6VfCXRtMFbVi+m2CUSpkKS87eZuuG9J7hD/Lr4MtbRTIH7EqFVqj+1z
         YK4I1ucfdpJ8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 44/46] mmc: renesas_sdhi: better reset from HS400 mode
Date:   Sun, 18 Dec 2022 11:12:42 -0500
Message-Id: <20221218161244.930785-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
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

[ Upstream commit 0da69dd2155019ed4c444ede0e79ce7a4a6af627 ]

Up to now, HS400 adjustment mode was only disabled on soft reset when a
calibration table was in use. It is safer, though, to disable it as soon
as the instance has an adjustment related quirk set, i.e. bad taps or a
calibration table.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20221120113457.42010-3-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 387f2a4f693a..3fa00df34b1e 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -520,7 +520,7 @@ static void renesas_sdhi_reset_hs400_mode(struct tmio_mmc_host *host,
 			 SH_MOBILE_SDHI_SCC_TMPPORT2_HS400OSEL) &
 			sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_TMPPORT2));
 
-	if (priv->adjust_hs400_calib_table)
+	if (priv->quirks && (priv->quirks->hs400_calib_table || priv->quirks->hs400_bad_taps))
 		renesas_sdhi_adjust_hs400_mode_disable(host);
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, CLK_CTL_SCLKEN |
-- 
2.35.1

