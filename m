Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710ED51AA37
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356968AbiEDRWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357315AbiEDRO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F25546BF
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9995B827AB
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6255FC385A4;
        Wed,  4 May 2022 16:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683495;
        bh=vEFTJ4KiSUnrW3Wao7CHJ7hn1a2w3DGOihGNYeCKfb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3mGJJdrJO6rBM3v0BTZfnGLj78R6WHVxZ1vfFwRwyAkHGOf0w3/7qhOSFAIUJVzi
         10SwQOCSe8+nmo4vFWuF+tbwTYkDiFClgo2vbcq8gAL+j5AOB16iyHBGJLegp+Pl3c
         CEVHakH618B9YyiDMm9TIe3KKnPGOSqlRVs1X+A51LUPp5KacqOlX2Qq5fKu94Sb2V
         jEyOSFcS8MJEOosPOzjtr0wK+feS94TMcxpZG9sK+TX2h7MZq5ZaE8nXidwnq0XGdZ
         yYUFDv+Ja+aPrO5EzsrF4mEkCoNoIx7hE0fTWf8diknN75BsHLQvzutmhxJyLFNBtT
         GI+9LzYsmCAGg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 10/30] PCI: aardvark: Disable link training when unbinding driver
Date:   Wed,  4 May 2022 18:57:35 +0200
Message-Id: <20220504165755.30002-11-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 759dec2e3dfdbd261c41d2279f04f2351c971a49 upstream.

Disable link training circuit in driver unbind sequence. We want to
leave link training in the same state as it was before the driver was
probed.

Link: https://lore.kernel.org/r/20211130172913.9727-11-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 78bc57d57926..3f6919564434 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1725,6 +1725,11 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	if (pcie->reset_gpio)
 		gpiod_set_value_cansleep(pcie->reset_gpio, 1);
 
+	/* Disable link training */
+	val = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
+	val &= ~LINK_TRAINING_EN;
+	advk_writel(pcie, val, PCIE_CORE_CTRL0_REG);
+
 	/* Disable outbound address windows mapping */
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);
-- 
2.35.1

