Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04F815C441
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgBMPpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgBMP1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:31 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E58DD206DB;
        Thu, 13 Feb 2020 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607650;
        bh=jE12QJnNI/wGp1XIGMy/Ylfgsb7mQfWbb/QWSHlwhHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1KbyE5zodrxUK7SIXDCURFk9dbqWITgB+2O0bqCEkR2RyptGyK9vLb7zt0PZPYh0
         rZzG22NgKp1CRwKum25k2aNoIMLDus06x9JKzFIFJwKfTSMGtb21DjgTpCMXypfx+e
         fApkOhPdTDAUcnpciSL25Pbnpl25wCZth087fEZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Benoit Parrot <bparrot@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 44/96] ARM: dts: am43xx: add support for clkout1 clock
Date:   Thu, 13 Feb 2020 07:20:51 -0800
Message-Id: <20200213151856.296353137@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

commit 01053dadb79d63b65f7b353e68b4b6ccf4effedb upstream.

clkout1 clock node and its generation tree was missing. Add this based
on the data on TRM and PRCM functional spec.

commit 664ae1ab2536 ("ARM: dts: am43xx: add clkctrl nodes") effectively
reverted this commit 8010f13a40d3 ("ARM: dts: am43xx: add support for
clkout1 clock") which is needed for the ov2659 camera sensor clock
definition hence it is being re-applied here.

Note that because of the current dts node name dependency for mapping to
clock domain, we must still use "clkout1-*ck" naming instead of generic
"clock@" naming for the node. And because of this, it's probably best to
apply the dts node addition together along with the other clock changes.

Fixes: 664ae1ab2536 ("ARM: dts: am43xx: add clkctrl nodes")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Tested-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am43xx-clocks.dtsi |   54 +++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/arch/arm/boot/dts/am43xx-clocks.dtsi
+++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
@@ -704,6 +704,60 @@
 		ti,bit-shift = <8>;
 		reg = <0x2a48>;
 	};
+
+	clkout1_osc_div_ck: clkout1-osc-div-ck {
+		#clock-cells = <0>;
+		compatible = "ti,divider-clock";
+		clocks = <&sys_clkin_ck>;
+		ti,bit-shift = <20>;
+		ti,max-div = <4>;
+		reg = <0x4100>;
+	};
+
+	clkout1_src2_mux_ck: clkout1-src2-mux-ck {
+		#clock-cells = <0>;
+		compatible = "ti,mux-clock";
+		clocks = <&clk_rc32k_ck>, <&sysclk_div>, <&dpll_ddr_m2_ck>,
+			 <&dpll_per_m2_ck>, <&dpll_disp_m2_ck>,
+			 <&dpll_mpu_m2_ck>;
+		reg = <0x4100>;
+	};
+
+	clkout1_src2_pre_div_ck: clkout1-src2-pre-div-ck {
+		#clock-cells = <0>;
+		compatible = "ti,divider-clock";
+		clocks = <&clkout1_src2_mux_ck>;
+		ti,bit-shift = <4>;
+		ti,max-div = <8>;
+		reg = <0x4100>;
+	};
+
+	clkout1_src2_post_div_ck: clkout1-src2-post-div-ck {
+		#clock-cells = <0>;
+		compatible = "ti,divider-clock";
+		clocks = <&clkout1_src2_pre_div_ck>;
+		ti,bit-shift = <8>;
+		ti,max-div = <32>;
+		ti,index-power-of-two;
+		reg = <0x4100>;
+	};
+
+	clkout1_mux_ck: clkout1-mux-ck {
+		#clock-cells = <0>;
+		compatible = "ti,mux-clock";
+		clocks = <&clkout1_osc_div_ck>, <&clk_rc32k_ck>,
+			 <&clkout1_src2_post_div_ck>, <&dpll_extdev_m2_ck>;
+		ti,bit-shift = <16>;
+		reg = <0x4100>;
+	};
+
+	clkout1_ck: clkout1-ck {
+		#clock-cells = <0>;
+		compatible = "ti,gate-clock";
+		clocks = <&clkout1_mux_ck>;
+		ti,bit-shift = <23>;
+		reg = <0x4100>;
+	};
 };
 
 &prcm {


