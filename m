Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FFD65009A
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiLRQRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiLRQQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245E10FFF;
        Sun, 18 Dec 2022 08:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECDCF60DCA;
        Sun, 18 Dec 2022 16:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E26C433D2;
        Sun, 18 Dec 2022 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379640;
        bh=uK2N8sWvtuJXEQYlSUHzg5AuM8NSppLJ4Q9v8QvjAWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M39DvFQy00zspV3PkaQhgYNlvrTwyYp9A3Zwb078wcH6OMCwcP4jua50izgUJpG4T
         AoracVU9Bo3+HL5RpcjO9zclzV4wkyPrrpuY8MAKbYfCuf9YP7iflhapJsuj7lPF4D
         XoO8Nw4SkC7gcJCiFMezZAoJD/1MtzWy4jcv1I5eOBpnjzpBwmshu25pIRZVC3DHts
         rwnaL2vCGD5f1tWXKPDoZiIE9J9FXOSBnAFi0vDsZkD5Z2GBH+9VnVp+EfnbZF6V5G
         ObgL0358/AeWjnF/vppsr4wXASJ4V1ssS21W1WkXUxuK06dj76SAeNgbY9NaJ9d7yX
         j58dVroW6KaQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 77/85] mmc: renesas_sdhi: better reset from HS400 mode
Date:   Sun, 18 Dec 2022 11:01:34 -0500
Message-Id: <20221218160142.925394-77-sashal@kernel.org>
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
index b970699743e0..02682c2fd957 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -546,7 +546,7 @@ static void renesas_sdhi_reset_hs400_mode(struct tmio_mmc_host *host,
 			 SH_MOBILE_SDHI_SCC_TMPPORT2_HS400OSEL) &
 			sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_TMPPORT2));
 
-	if (priv->adjust_hs400_calib_table)
+	if (priv->quirks && (priv->quirks->hs400_calib_table || priv->quirks->hs400_bad_taps))
 		renesas_sdhi_adjust_hs400_mode_disable(host);
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, CLK_CTL_SCLKEN |
-- 
2.35.1

