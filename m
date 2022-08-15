Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0346A5946B6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352583AbiHOXAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352502AbiHOW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B878474DF;
        Mon, 15 Aug 2022 12:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FCA6068D;
        Mon, 15 Aug 2022 19:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39748C433D6;
        Mon, 15 Aug 2022 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593406;
        bh=PTajQ6vCQBXIMFfY1mQIEBHxTvgpJvmAcciNKVsTvXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uh38e7o/iVhFwYItjuT5smayEyJPEFOBTTZwHEOtcdX08toHlwDAzuwPMpidxFSNg
         cT/9oa8qgIb54N7uiBgLyL2HiDYbs+i98g16uQL4ftgv1yz+ZwuF9XKamRXaXGUt99
         6qd2nxIN/xistnFyImye52fzgYbldVaC8RS2+g9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tam=C3=A1s=20Sz=C5=B1cs?= <tszucs@protonmail.ch>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0263/1157] arm64: tegra: Fix SDMMC1 CD on P2888
Date:   Mon, 15 Aug 2022 19:53:39 +0200
Message-Id: <20220815180450.101929523@linuxfoundation.org>
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
index a7d7cfd66379..b0f9393dd39c 100644
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



