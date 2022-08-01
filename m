Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE4586A1E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiHAMMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiHAMKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:10:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE99D6AA1B;
        Mon,  1 Aug 2022 04:56:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2A5F5CE13B9;
        Mon,  1 Aug 2022 11:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3C3C433D6;
        Mon,  1 Aug 2022 11:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355000;
        bh=oONK/2x2HZCKsDsB+GoDk34waBGsK8OQ/Klc1ODe+zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCpaoGXEBw3pl+pA5nqe1F/phWDjBSf/taSsKZj+A0I9FzcrHuOj8f3/omTy5+6NF
         4NLo6JiOyxRU7TAS3w/cFZvzT1yrl5jJb0ldqswteB7yUU9E+NvozwtK8m+JJP04tH
         R3bmKSYKwat1+2Rv4HedXwILDD8EKBaVgE3OlQUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 5.18 03/88] ARM: dts: lan966x: fix sys_clk frequency
Date:   Mon,  1 Aug 2022 13:46:17 +0200
Message-Id: <20220801114138.189784913@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit ef0324b6415db6742bd632dc0dfbb8fbc111473b upstream.

The sys_clk frequency is 165.625MHz. The register reference of the
Generic Clock controller lists the CPU clock as 600MHz, the DDR clock as
300MHz and the SYS clock as 162.5MHz. This is wrong. It was first
noticed during the fan driver development and it was measured and
verified via the CLK_MON output of the SoC which can be configured to
output sys_clk/64.

The core PLL settings (which drives the SYS clock) seems to be as
follows:
  DIVF = 52
  DIVQ = 3
  DIVR = 1

With a refernce clock of 25MHz, this means we have a post divider clock
  Fpfd = Fref / (DIVR + 1) = 25MHz / (1 + 1) = 12.5MHz

The resulting VCO frequency is then
  Fvco = Fpfd * (DIVF + 1) * 2 = 12.5MHz * (52 + 1) * 2 = 1325MHz

And the output frequency is
  Fout = Fvco / 2^DIVQ = 1325MHz / 2^3 = 165.625Mhz

This all adds up to the constrains of the PLL:
    10MHz <= Fpfd <= 200MHz
    20MHz <= Fout <= 1000MHz
  1000MHz <= Fvco <= 2000MHz

Fixes: 290deaa10c50 ("ARM: dts: add DT for lan966 SoC and 2-port board pcb8291")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220326194028.2945985-1-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/lan966x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/lan966x.dtsi b/arch/arm/boot/dts/lan966x.dtsi
index 3cb02fffe716..38e90a31d2dd 100644
--- a/arch/arm/boot/dts/lan966x.dtsi
+++ b/arch/arm/boot/dts/lan966x.dtsi
@@ -38,7 +38,7 @@ clocks {
 		sys_clk: sys_clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <162500000>;
+			clock-frequency = <165625000>;
 		};
 
 		cpu_clk: cpu_clk {
-- 
2.37.1



