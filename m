Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D96E5F29B1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJCHY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiJCHXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B454B0D9;
        Mon,  3 Oct 2022 00:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBEB60F9E;
        Mon,  3 Oct 2022 07:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D02C433D6;
        Mon,  3 Oct 2022 07:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781319;
        bh=fTSbSxDQNbX3+B3jV7c8bVErpVLYOPAonMxTtMNcGQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8AqVwIcbWxTaDjsmhIjURSeQSuA2iuUQfk+2Wp/oAyy07fhJgFMrlvbVMYMjkhWs
         eDKKZfGTiHzylaRVTcsT5HBCRsB+sbo427VSpTJc3MYgoDgoHRroYHT+f/y6Q9MFjq
         ubdFAwfSXPKtG3rJdszdQcyQNCpea/VXHWSQuVWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YuTong Chang <mtwget@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 051/101] ARM: dts: am33xx: Fix MMCHS0 dma properties
Date:   Mon,  3 Oct 2022 09:10:47 +0200
Message-Id: <20221003070725.729378974@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: YuTong Chang <mtwget@gmail.com>

[ Upstream commit 2eb502f496f7764027b7958d4e74356fed918059 ]

According to technical manual(table 11-24), the DMA of MMCHS0 should be
direct mapped.

Fixes: b5e509066074 ("ARM: DTS: am33xx: Use the new DT bindings for the eDMA3")
Signed-off-by: YuTong Chang <mtwget@gmail.com>
Message-Id: <20220620124146.5330-1-mtwget@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx-l4.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 7da42a5b959c..7e50fe633d8a 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -1502,8 +1502,7 @@
 			mmc1: mmc@0 {
 				compatible = "ti,am335-sdhci";
 				ti,needs-special-reset;
-				dmas = <&edma_xbar 24 0 0
-					&edma_xbar 25 0 0>;
+				dmas = <&edma 24 0>, <&edma 25 0>;
 				dma-names = "tx", "rx";
 				interrupts = <64>;
 				reg = <0x0 0x1000>;
-- 
2.35.1



