Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F232E41E1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408419AbgL1PO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438187AbgL1OGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B927E207B2;
        Mon, 28 Dec 2020 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164389;
        bh=u5X+2vQlcDHXjag+vwKfk4kgAsp+c+mxOCHIScp1xc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4uJKkR8SnRlNfz4tTFaifzXUrECVX4gFcNzd0Mnwb5hMu5rlDCNVjthZVr73rjCb
         TWRgpcY+6KFxH+On6YBvbuvzmMV81qeCyT1cA57RBRZe923zZOQv7Sk9tABPSki1UM
         pHMojFiYW5X7hr95NeR0l2JP4EfPCnoOEL5aSKqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Laxminath Kasam <lkasam@codeaurora.org>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Mark Brown <broonie@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Tony Lindgren <tony@atomide.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/717] mfd: cpcap: Fix interrupt regression with regmap clear_ack
Date:   Mon, 28 Dec 2020 13:42:41 +0100
Message-Id: <20201228125028.766318260@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 14639a22de657eabbb776f503a816594393cc935 ]

With commit 3a6f0fb7b8eb ("regmap: irq: Add support to clear ack
registers"), the cpcap interrupts are no longer getting acked properly
leading to a very unresponsive device with CPUs fully loaded spinning
in the threaded IRQ handlers.

To me it looks like the clear_ack commit above actually fixed a long
standing bug in regmap_irq_thread() where we unconditionally acked the
interrupts earlier without considering ack_invert. And the issue with
cpcap started happening as we now also consider ack_invert.

Tim Harvey <tharvey@gateworks.com> tried to fix this issue earlier with
"[PATCH v2] regmap: irq: fix ack-invert", but the reading of the ack
register was considered unnecessary for just ack_invert, and we did not
have clear_ack available yet. As the cpcap irqs worked both with and
without ack_invert earlier because of the unconditional ack, the
problem remained hidden until now.

Also, looks like the earlier v3.0.8 based Motorola Android Linux kernel
does clear_ack style read-clear-write with "ireg_val & ~mreg_val" instead
of just ack_invert style write. So let's switch cpcap to use clear_ack
to fix the issue.

Fixes: 3a6f0fb7b8eb ("regmap: irq: Add support to clear ack registers")
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Laxminath Kasam <lkasam@codeaurora.org>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Pavel Machek <pavel@ucw.cz>
Reviewed-By: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/motorola-cpcap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/motorola-cpcap.c b/drivers/mfd/motorola-cpcap.c
index 2283d88adcc25..30d82bfe5b02f 100644
--- a/drivers/mfd/motorola-cpcap.c
+++ b/drivers/mfd/motorola-cpcap.c
@@ -97,7 +97,7 @@ static struct regmap_irq_chip cpcap_irq_chip[CPCAP_NR_IRQ_CHIPS] = {
 		.ack_base = CPCAP_REG_MI1,
 		.mask_base = CPCAP_REG_MIM1,
 		.use_ack = true,
-		.ack_invert = true,
+		.clear_ack = true,
 	},
 	{
 		.name = "cpcap-m2",
@@ -106,7 +106,7 @@ static struct regmap_irq_chip cpcap_irq_chip[CPCAP_NR_IRQ_CHIPS] = {
 		.ack_base = CPCAP_REG_MI2,
 		.mask_base = CPCAP_REG_MIM2,
 		.use_ack = true,
-		.ack_invert = true,
+		.clear_ack = true,
 	},
 	{
 		.name = "cpcap1-4",
@@ -115,7 +115,7 @@ static struct regmap_irq_chip cpcap_irq_chip[CPCAP_NR_IRQ_CHIPS] = {
 		.ack_base = CPCAP_REG_INT1,
 		.mask_base = CPCAP_REG_INTM1,
 		.use_ack = true,
-		.ack_invert = true,
+		.clear_ack = true,
 	},
 };
 
-- 
2.27.0



