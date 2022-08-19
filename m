Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B052959A193
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350711AbiHSQCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351010AbiHSP75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:59:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE24010975D;
        Fri, 19 Aug 2022 08:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74CEAB82812;
        Fri, 19 Aug 2022 15:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92B8C433D6;
        Fri, 19 Aug 2022 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924339;
        bh=7qVHYV7A6UukR/WJl+oKwqL6JvoHa4LpnEt0nyj+uKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2ogwhNjCIyiXMFuTxfCvceY932fRddAjDyxczmi5VqKg44arTkhBhy0q0YrdWE8b
         jD3w7ZS99YLkwsYY6hl1YCYeAmO+JFL3gR3KCKDCvuB2AUvVvfeAPEWKMx4LIolKC8
         VA3T9THJ0G3D/BmOvqK+dahYQ/dB0wEKrPrLZrUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tam=C3=A1s=20Sz=C5=B1cs?= <tszucs@protonmail.ch>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/545] arm64: tegra: Fix SDMMC1 CD on P2888
Date:   Fri, 19 Aug 2022 17:38:27 +0200
Message-Id: <20220819153835.469858351@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Tamás Szűcs <tszucs@protonmail.ch>

[ Upstream commit b415bb7c976f1d595ed752001c0938f702645dab ]

Hook SDMMC1 CD up with CVM GPIO02 (SOC_GPIO11) used for card detection on J4
(uSD socket) on the carrier.

Fixes: ef633bfc21e9 ("arm64: tegra: Enable card detect for SD card on P2888")
Signed-off-by: Tamás Szűcs <tszucs@protonmail.ch>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
index d71b7a1140fe..216dc30fa26c 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
@@ -75,7 +75,7 @@ eeprom@50 {
 
 		/* SDMMC1 (SD/MMC) */
 		mmc@3400000 {
-			cd-gpios = <&gpio TEGRA194_MAIN_GPIO(A, 0) GPIO_ACTIVE_LOW>;
+			cd-gpios = <&gpio TEGRA194_MAIN_GPIO(G, 7) GPIO_ACTIVE_LOW>;
 		};
 
 		/* SDMMC4 (eMMC) */
-- 
2.35.1



