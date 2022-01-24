Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C9498CF4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351316AbiAXT0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:26:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51338 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349910AbiAXTWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:22:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B0E061317;
        Mon, 24 Jan 2022 19:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C643C340E5;
        Mon, 24 Jan 2022 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052172;
        bh=cBBZ8JPUy6BY7CZDXyLC6eF5svJh0zfrQtIgk2t0K3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0J/Y9Z0s8MpgpVlYnogvejAzkWdh9TLvtJP3Lv9VbYXQZ7iVSZDzDi39UmAPM2Ks3
         tdsxpJ32wDanJIZXNgCUhSeRtJUh9sT5YrbXkqj55+F8P9pZsWsMXHDaPmC/p/bAzk
         5zxTamde5eFKMiuiU/xVjsbIut8Wb8xfRN8tVlsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 211/239] ARM: dts: Fix vcsi regulator to be always-on for droid4 to prevent hangs
Date:   Mon, 24 Jan 2022 19:44:09 +0100
Message-Id: <20220124183949.823156871@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit ddb52945999dcf35787bf221b62108806182578d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
+++ b/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
@@ -165,12 +165,12 @@
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


