Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D59F12C923
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733164AbfL2SA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:00:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733119AbfL2R4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3545206DB;
        Sun, 29 Dec 2019 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642206;
        bh=0nUNyXPoYafTdQXudVrzpPw+mdKPYbF1L5kWj5KLvd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gizibf0J8Qts/FM6rfwNXkflY7EyMBg/kivyoq12XHLtC2dpJ1DqOYx70BFs2kl6V
         taDKchhQhFAEMIhOUeFY7Xf8y2No0mTMYIyypPxDEDHzkedo/LgkQpAS3z/PhvVmNp
         p+DHY9E833gTjrfEBAwUyNA6cbyTYTM87kEw8T5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 387/434] ARM: dts: Fix vcsi regulator to be always-on for droid4 to prevent hangs
Date:   Sun, 29 Dec 2019 18:27:20 +0100
Message-Id: <20191229172727.935086290@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit ddb52945999dcf35787bf221b62108806182578d ]

In addition to using vcsi regulator for the display, looks like droid4 is
using vcsi regulator to trigger off mode internally with the PMIC firmware
when the SoC enters deeper idle states. This is configured in the Motorola
Mapphone Linux kernel sources as "zerov_regulator".

As we currently don't support off mode during idle for omap4, we must
prevent vcsi from being disabled when the display is blanked to prevent
the PMIC change to off mode. Otherwise the device will hang on entering
idle when the display is blanked.

Before commit 089b3f61ecfc ("regulator: core: Let boot-on regulators be
powered off"), the boot-on regulators never got disabled like they should
and vcsi did not get turned off on idle.

Let's fix the issue by setting vcsi to always-on for now. Later on we may
want to claim the vcsi regulator also in the PM code if needed.

Fixes: 089b3f61ecfc ("regulator: core: Let boot-on regulators be powered off")
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi b/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
index d1eae47b83f6..82f7ae030600 100644
--- a/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
+++ b/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
@@ -160,12 +160,12 @@
 		regulator-enable-ramp-delay = <1000>;
 	};
 
-	/* Used by DSS */
+	/* Used by DSS and is the "zerov_regulator" trigger for SoC off mode */
 	vcsi: VCSI {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 		regulator-enable-ramp-delay = <1000>;
-		regulator-boot-on;
+		regulator-always-on;
 	};
 
 	vdac: VDAC {
-- 
2.20.1



