Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6565B68113A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbjA3OLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbjA3OLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE6F3BD9D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A31A6B8117B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45CDC433D2;
        Mon, 30 Jan 2023 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087862;
        bh=HIuAtD7PP0GscvnFPtW6sWcXVA2xXCCEW3Lsq9AnqR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SptBtG51DU9Iroea/a0s2fXJuOz59EiVR+nD8EIGSXLOczCDxW1DxbeXJm4R99ZZt
         Ajg8cVFBxqv3PEgp+gnL45rKLIxgadRAXUtZ2jgZbCbm3M+mgU/eVdtVN/MfjGmZJy
         6vrUoFs0PW7+7jKp0rbDVPSz4bxxdrD0WdU3IOOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/204] ARM: dts: at91: sam9x60: fix the ddr clock for sam9x60
Date:   Mon, 30 Jan 2023 14:49:58 +0100
Message-Id: <20230130134317.765302386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 9bfa2544dbd1133f0b0af4e967de3bb9c1e3a497 ]

The 2nd DDR clock for sam9x60 DDR controller is peripheral clock with
id 49.

Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221208115241.36312-1-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sam9x60.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index ec45ced3cde6..e1e0dec8cc1f 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -567,7 +567,7 @@ pmecc: ecc-engine@ffffe000 {
 			mpddrc: mpddrc@ffffe800 {
 				compatible = "microchip,sam9x60-ddramc", "atmel,sama5d3-ddramc";
 				reg = <0xffffe800 0x200>;
-				clocks = <&pmc PMC_TYPE_SYSTEM 2>, <&pmc PMC_TYPE_CORE PMC_MCK>;
+				clocks = <&pmc PMC_TYPE_SYSTEM 2>, <&pmc PMC_TYPE_PERIPHERAL 49>;
 				clock-names = "ddrck", "mpddr";
 			};
 
-- 
2.39.0



