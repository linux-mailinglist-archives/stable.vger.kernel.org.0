Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8539E1ACBCC
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410648AbgDPPvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896586AbgDPNc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4AC322264;
        Thu, 16 Apr 2020 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043932;
        bh=SteS77gACO4sJ7lpztNtH3/D2R3O5SRCa8yV+ZMnFak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQqKgJyr/DxQ7upXRQPMbBWU9EmSHrZNC+eC4GpTE5xCWheg70CnDM06oIQRI1jWY
         gaNwSBc02CFlrvpSvpXnhs6Ffki4ZCtKrxjxxJGwWTJ0hocyIqzEnkx+ZOC31/eThZ
         dwta2Y0TL2brCtw7fA36eG2RjI6XOjt2qGGUhSR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, maemo-leste@lists.dyne.org,
        Arthur Demchenkov <spinal.by@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 013/257] ARM: dts: omap4-droid4: Fix lost touchscreen interrupts
Date:   Thu, 16 Apr 2020 15:21:04 +0200
Message-Id: <20200416131327.495817535@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



