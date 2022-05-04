Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84F51A8F5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356105AbiEDRLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357170AbiEDRKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879F149684;
        Wed,  4 May 2022 09:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EBDECE28AD;
        Wed,  4 May 2022 16:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD2CC385BF;
        Wed,  4 May 2022 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683424;
        bh=iTB9JNJEb9ck5CWcUWb4vwLwVA4YMk20n9F3/mIWVCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuCxX4/lUage7gq4QyvziTXLAD9kGOutPuP+K05O8salhCB7nFmiVmkrz1fetXmLR
         yh9ijn7Vt/+nJrn5SlAJ0BFNQKTZLSpCgkesEMsu0F8Rqs7Qp2V047DZtjjSI4TdB/
         ltLfstYYQ1gMvxZe9P6weYY5ZWNXvRrhFVk0Ses0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 090/225] ARM: dts: am33xx-l4: Add missing touchscreen clock properties
Date:   Wed,  4 May 2022 18:45:28 +0200
Message-Id: <20220504153118.928897792@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit c21a7434d6cc216a910dd35632617850f1751f4c ]

When adding support for TI magadc (Magnetic Stripe Reader and ADC), the
MFD driver common to the touchscreen and the ADC got updated to ease the
insertion of a new DT node for the ADC, with its own compatible, clocks,
etc. Commit 235a96e92c16 ("mfd: ti_am335x_tscadc: Don't search the tree
for our clock") removed one compatible specific information which was
the clock name, because the clock was looked up from scratch in the DT
while this hardware block was only fed by a single clock, already
defined and properly filled in the DT.

Problem is, this change was only validated with an am437x-based board,
where the clocks are effectively correctly defined and referenced. But
on am33xx, the ADC clock is also correctly defined but is not referenced
with a clock phandle as it ought to be.

The touchscreen bindings clearly state that the clocks/clock-names
properties are mandatory, but they have been forgotten in one DTSI. This
was probably not noticed in the first place because of the clock
actually existing and the clk_get() call going through all the tree
anyway.

Add the missing clock phandles in the am33xx touchscreen description.

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Fixes: 235a96e92c16 ("mfd: ti_am335x_tscadc: Don't search the tree for our clock")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Message-Id: <20220314163445.79807-1-miquel.raynal@bootlin.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx-l4.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index c9629cb5ccd1..7da42a5b959c 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -263,6 +263,8 @@ tscadc: tscadc@0 {
 				compatible = "ti,am3359-tscadc";
 				reg = <0x0 0x1000>;
 				interrupts = <16>;
+				clocks = <&adc_tsc_fck>;
+				clock-names = "fck";
 				status = "disabled";
 				dmas = <&edma 53 0>, <&edma 57 0>;
 				dma-names = "fifo0", "fifo1";
-- 
2.35.1



