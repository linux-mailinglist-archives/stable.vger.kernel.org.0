Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC1420DC3D
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgF2UNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732861AbgF2TaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2603125257;
        Mon, 29 Jun 2020 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444967;
        bh=O6JNdoJ52kUwwUPeBFB466TCuwQkvz1e1LXBO24N7SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vse+/6cTt4G2T39m+e0GSmwTGsSr38l4ncbt+hrvD3Kc8/S4iqTti6EKM2TgPS44g
         8zVKHjWdvvEAjCdNk6swVCKDQQOwQT+0+rgAbERLOaqBtkwOX4ScvUVYIVCYPzRBU3
         9GJ3uwut8aN3Xy2KVvtAu4aI3rZK7wFJhJ79gx/k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/131] ARM: dts: Fix duovero smsc interrupt for suspend
Date:   Mon, 29 Jun 2020 11:33:57 -0400
Message-Id: <20200629153502.2494656-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9cf28e41f9f768791f54ee18333239fda6927ed8 ]

While testing the recent suspend and resume regressions I noticed that
duovero can still end up losing edge gpio interrupts on runtime
suspend. This causes NFSroot easily stopping working after resume on
duovero.

Let's fix the issue by using gpio level interrupts for smsc as then
the gpio interrupt state is seen by the gpio controller on resume.

Fixes: 731b409878a3 ("ARM: dts: Configure duovero for to allow core retention during idle")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4-duovero-parlor.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap4-duovero-parlor.dts b/arch/arm/boot/dts/omap4-duovero-parlor.dts
index cfcac0d73851e..93d6fb6db5785 100644
--- a/arch/arm/boot/dts/omap4-duovero-parlor.dts
+++ b/arch/arm/boot/dts/omap4-duovero-parlor.dts
@@ -142,7 +142,7 @@
 	ethernet@gpmc {
 		reg = <5 0 0xff>;
 		interrupt-parent = <&gpio2>;
-		interrupts = <12 IRQ_TYPE_EDGE_FALLING>;	/* gpio_44 */
+		interrupts = <12 IRQ_TYPE_LEVEL_LOW>;		/* gpio_44 */
 
 		phy-mode = "mii";
 
-- 
2.25.1

