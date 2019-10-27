Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24EBE68B3
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfJ0VRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbfJ0VRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:30 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42071205C9;
        Sun, 27 Oct 2019 21:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211049;
        bh=DoZbOJkyEpxr8O1/upunQtXlKDIbBtKBteci4Ek32YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbTcRIihGC+DCpWC3IpEyNpE2uqd5CAHxIGW7DXRSdJUqyE9P18SmEFEqRoJ3zNZu
         XGbHOimgyn7jD8TGFYFWhchLm5TwnaK2ISkRt5GItegfiJO5o6iHG1I6Es9qMYB5Zo
         xdZWTvEAD+NkozFzNlK9vhE3wkFrrfWO20vJJxO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jyri Sarha <jsarha@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 015/197] ARM: OMAP2+: Add missing LCDC midlemode for am335x
Date:   Sun, 27 Oct 2019 21:58:53 +0100
Message-Id: <20191027203352.497559276@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 17529d43b21c72466e9109d602c6f5c360a1a9e8 ]

TRM "Table 13-34. SYSCONFIG Register Field Descriptions" lists both
standbymode and idlemode that should be just the sidle and midle
registers where midle is currently unconfigured for lcdc_sysc. As
the dts data has been generated based on lcdc_sysc, we now have an
empty "ti,sysc-midle" property.

And so we currently get a warning for lcdc because of a difference
with dts provided configuration compared to the legacy platform
data. This is because lcdc has SYSC_HAS_MIDLEMODE configured in
the platform data without configuring the modes.

Let's fix the issue by adding the missing midlemode to lcdc_sysc,
and configuring the "ti,sysc-midle" property based on the TRM
values.

Fixes: f711c575cfec ("ARM: dts: am335x: Add l4 interconnect hierarchy and ti-sysc data")
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Robert Nelson <robertcnelson@gmail.com>
Cc: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx-l4.dtsi           | 4 +++-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 1515f4f914999..3287cf695b5a4 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -2038,7 +2038,9 @@
 			reg = <0xe000 0x4>,
 			      <0xe054 0x4>;
 			reg-names = "rev", "sysc";
-			ti,sysc-midle ;
+			ti,sysc-midle = <SYSC_IDLE_FORCE>,
+					<SYSC_IDLE_NO>,
+					<SYSC_IDLE_SMART>;
 			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
 					<SYSC_IDLE_NO>,
 					<SYSC_IDLE_SMART>;
diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index c965af275e341..81d9912f17c85 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -231,8 +231,9 @@ static struct omap_hwmod am33xx_control_hwmod = {
 static struct omap_hwmod_class_sysconfig lcdc_sysc = {
 	.rev_offs	= 0x0,
 	.sysc_offs	= 0x54,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_flags	= SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE,
+	.idlemodes	= SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			  MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART,
 	.sysc_fields	= &omap_hwmod_sysc_type2,
 };
 
-- 
2.20.1



