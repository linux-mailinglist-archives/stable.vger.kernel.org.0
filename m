Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274E2137F78
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAKKUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbgAKKUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:20:13 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58B2205F4;
        Sat, 11 Jan 2020 10:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738012;
        bh=Zd8skzaUVyeazQpB1RODtoHwHrjmR8gwsqJ5lsTO2bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srVAg7dsVwFmeZJA8SaHnks9/74gM22lL7QW8M3iCTRsuS9ujoQxrYTWYaxphKD7B
         jGfP3aasRYO+feOi0Fp42jABjm2T75kemwZ1Ya7FOJvSYM7sJOiVkXYb6fQjP+cMwL
         W8i4mI0OEL2MxzsskjmEro0uzsqcGACKy2ZdwRR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 4.19 63/84] ARM: dts: imx6ul: use nvmem-cells for cpu speed grading
Date:   Sat, 11 Jan 2020 10:50:40 +0100
Message-Id: <20200111094909.837271697@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 92f0eb08c66a73594cf200e65689e767f7f0da5e upstream.

On i.MX6UL, accessing OCOTP directly is wrong because the ocotp clock
needs to be enabled first, so use the nvmem-cells binding instead.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Cc: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6ul.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -87,6 +87,8 @@
 				      "pll1_sys";
 			arm-supply = <&reg_arm>;
 			soc-supply = <&reg_soc>;
+			nvmem-cells = <&cpu_speed_grade>;
+			nvmem-cell-names = "speed_grade";
 		};
 	};
 
@@ -930,6 +932,10 @@
 				tempmon_temp_grade: temp-grade@20 {
 					reg = <0x20 4>;
 				};
+
+				cpu_speed_grade: speed-grade@10 {
+					reg = <0x10 4>;
+				};
 			};
 
 			lcdif: lcdif@21c8000 {


