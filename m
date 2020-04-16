Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE54D1AC6D8
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394619AbgDPOpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437193AbgDPN7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FFF20732;
        Thu, 16 Apr 2020 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045578;
        bh=VYuhQynOOttQXgdTesb/aAZL2uNah2HlHkKcMndQFn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UGgNkGIspkRJQST1qZtxZu1YtT9HZOZPuOmCC/tV7EbPOGJ0haxWbclHqqn8Ms6C
         cU3TnFshqUNx19gE3daHqJRvXo8pZWaDHMFfRWv07ANklnx8qn1oe2dMiGbc3r1t8C
         dMak0Q3NETXYilAZqe8lfoPeb/cEI2/UoEonxfZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Gerlach <d-gerlach@ti.com>,
        Roger Quadros <rogerq@ti.com>, stable@kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 5.6 193/254] arm64: dts: ti: k3-am65: Add clocks to dwc3 nodes
Date:   Thu, 16 Apr 2020 15:24:42 +0200
Message-Id: <20200416131350.389876357@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Gerlach <d-gerlach@ti.com>

commit a81e5442d796ccfa2cc97d205a5477053264d978 upstream.

The TI sci-clk driver can scan the DT for all clocks provided by system
firmware and does this by checking the clocks property of all nodes, so
we must add this to the dwc3 nodes so USB clocks are available.

Without this USB does not work with latest system firmware i.e.
[    1.714662] clk: couldn't get parent clock 0 for /interconnect@100000/dwc3@4020000

Fixes: cc54a99464ccd ("arm64: dts: ti: k3-am6: add USB suppor")
Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Cc: stable@kernel.org
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -296,6 +296,7 @@
 		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 		dma-coherent;
 		power-domains = <&k3_pds 151 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 151 2>, <&k3_clks 151 7>;
 		assigned-clocks = <&k3_clks 151 2>, <&k3_clks 151 7>;
 		assigned-clock-parents = <&k3_clks 151 4>,	/* set REF_CLK to 20MHz i.e. PER0_PLL/48 */
 					 <&k3_clks 151 9>;	/* set PIPE3_TXB_CLK to CLK_12M_RC/256 (for HS only) */
@@ -335,6 +336,7 @@
 		interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
 		dma-coherent;
 		power-domains = <&k3_pds 152 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 152 2>;
 		assigned-clocks = <&k3_clks 152 2>;
 		assigned-clock-parents = <&k3_clks 152 4>;	/* set REF_CLK to 20MHz i.e. PER0_PLL/48 */
 


