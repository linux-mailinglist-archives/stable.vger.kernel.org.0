Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DEE323DD9
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhBXNUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234512AbhBXNKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9245E64F17;
        Wed, 24 Feb 2021 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171317;
        bh=1sXhuTMiFjtE+lIfb216D51DthNs277ic1ADs1lRTY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvyVMkaEb0XYrw3OsnBDs5K7A7mZxndnlfi0M4qLnEVX/+Y46wPGDk0qnXFLqQrlx
         HjnLnZ+t6vtb4/J6/otbGfOUTXj8naDQrzUagKCqsZGrUJE/TF9NGpDw4q4bPDdyUN
         gxPDUOLagC8n/B3ACI+rA+ySryvZ2Piu1OQ8FMOWk269gwbB2bks6GytnAem3F2SS8
         zksW/1aOKgXZCu79+QBNTvg8GG8HfSpFe2fsf3M9eybNAVmZAiPWXRJ0q0q87Wu46r
         cawShcDg0JjIAj/Apg0soDNv7qKSpgQgG7YciV10w8icGPZLKmcb3Qfv2DhyXvukdH
         wugg9qXD5q8Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 02/16] x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk
Date:   Wed, 24 Feb 2021 07:54:59 -0500
Message-Id: <20210224125514.483935-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 4b2d8ca9208be636b30e924b1cbcb267b0740c93 ]

On this system the M.2 PCIe WiFi card isn't detected after reboot, only
after cold boot. reboot=pci fixes this behavior. In [0] the same issue
is described, although on another system and with another Intel WiFi
card. In case it's relevant, both systems have Celeron CPUs.

Add a PCI reboot quirk on affected systems until a more generic fix is
available.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=202399

 [ bp: Massage commit message. ]

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/1524eafd-f89c-cfa4-ed70-0bde9e45eec9@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/reboot.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index b7663a1f89ee5..77e4a41eed989 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -477,6 +477,15 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 		},
 	},
 
+	{	/* PCIe Wifi card isn't detected after reboot otherwise */
+		.callback = set_pci_reboot,
+		.ident = "Zotac ZBOX CI327 nano",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "NA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZBOX-CI327NANO-GS-01"),
+		},
+	},
+
 	/* Sony */
 	{	/* Handle problems with rebooting on Sony VGN-Z540N */
 		.callback = set_bios_reboot,
-- 
2.27.0

