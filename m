Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC29145681
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgAVN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731379AbgAVN10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:26 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E581205F4;
        Wed, 22 Jan 2020 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699646;
        bh=Hykt05JHDDNwn8AmVNYmqgX6fuNy99GKqwkDqrQYsPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFWD6o1fUeP4xXoLBKAmtL4tQ/ROxrK+o1ckfRkbp4pwUtkFPPhZWrI3H2YPPMnD3
         b3y7G4S/anFTT2RCFiYqiZhv20nyUbugIQKimnbchsGyLdiDzqovocNp1SzqMWvTm3
         NFs9+ZoihEDncBcjQCkpMOzBqA+05Ur7zctaErcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 189/222] ARM: dts: dra7: fix cpsw mdio fck clock
Date:   Wed, 22 Jan 2020 10:29:35 +0100
Message-Id: <20200122092847.214902689@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit 6af0a549c25e0d02366aa95507bfe3cad2f7b68b upstream.

The DRA7 CPSW MDIO functional clock (gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0)
is specified incorrectly, which is caused incorrect MDIO bus clock
configuration MDCLK. The correct CPSW MDIO functional clock is
gmac_main_clk (125MHz), which is the same as CPSW fck. Hence fix it.

Fixes: 1faa415c9c6e ("ARM: dts: Add fck for cpsw mdio for omap variants")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7-l4.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3059,7 +3059,7 @@
 
 				davinci_mdio: mdio@1000 {
 					compatible = "ti,cpsw-mdio","ti,davinci_mdio";
-					clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
+					clocks = <&gmac_main_clk>;
 					clock-names = "fck";
 					#address-cells = <1>;
 					#size-cells = <0>;


