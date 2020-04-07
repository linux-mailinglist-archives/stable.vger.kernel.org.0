Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046441A01FF
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgDGABZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgDGABX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD912082D;
        Tue,  7 Apr 2020 00:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217682;
        bh=SteS77gACO4sJ7lpztNtH3/D2R3O5SRCa8yV+ZMnFak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mdzmy0SVEjfSYvaOTSoqMQQZ3EjlVHUUQMaSffrGR0VLI3r9XVm8GM4q3LNBNYSfD
         guxYbQKGnlFcjXXaxzpkx8SgJ/0scp7XctuKFWBfMUmrH0jaQQ40fzaNhKs5qkPJ2m
         GDOg0py5JinKUyn1Ta3yz4B+XflWPSCaNHC3ZXVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, maemo-leste@lists.dyne.org,
        Arthur Demchenkov <spinal.by@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 18/35] ARM: dts: omap4-droid4: Fix lost touchscreen interrupts
Date:   Mon,  6 Apr 2020 20:00:40 -0400
Message-Id: <20200407000058.16423-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 4abd9930d189dedaa59097144c6d8f623342fa72 ]

Looks like we can have the maxtouch touchscreen stop producing interrupts
if an edge interrupt is lost. This can happen easily when the SoC idles as
the gpio controller may not see any state for an edge interrupt if it
is briefly triggered when the system is idle.

Also it looks like maxtouch stops sending any further interrupts if the
interrupt is not handled. And we do have several cases of maxtouch already
configured with a level interrupt, so let's do that.

With level interrupt the gpio controller has the interrupt state visible
after idle. Note that eventually we will probably also be using the
Linux generic wakeirq configured for the controller, but that cannot be
done until the maxtouch driver supports runtime PM.

Cc: maemo-leste@lists.dyne.org
Cc: Arthur Demchenkov <spinal.by@gmail.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/motorola-mapphone-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index da6b107da84a4..aeb5a673c209e 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -413,7 +413,7 @@
 		reset-gpios = <&gpio6 13 GPIO_ACTIVE_HIGH>; /* gpio173 */
 
 		/* gpio_183 with sys_nirq2 pad as wakeup */
-		interrupts-extended = <&gpio6 23 IRQ_TYPE_EDGE_FALLING>,
+		interrupts-extended = <&gpio6 23 IRQ_TYPE_LEVEL_LOW>,
 				      <&omap4_pmx_core 0x160>;
 		interrupt-names = "irq", "wakeup";
 		wakeup-source;
-- 
2.20.1

