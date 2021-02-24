Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531B4323D66
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhBXNJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235651AbhBXNDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:03:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8FBF64F66;
        Wed, 24 Feb 2021 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171223;
        bh=BvmEqGECVToO3eEglLO1ZcVaxkw2BcC7Y9U8HXh7MqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zu8qHub2hsNYSJYghifERwSUQXPeiPO43n/FtdyRr9pWHXvuZX6tlLX4yU2ZqAzoN
         yD+Y+k13VM2GVd6UC+F1FHWiVDcf7fCwIHynOTY2s300bwLgD2wSQhOU8EWtlMTbYg
         y13eFzKF06Gj/8+pAZq6VXWPMlr2Pdk8nuiQFP3FaHsxr/+YsAF8qYBSG4sBLFQFvE
         UvbN2He5xoFtgLBerS6joPHrZTIApBnQPeMJpJG0vLI587d24otkSOEqJ+MBA3bcx3
         EUSYOn2XP4NQYBoSje57NW56UZbBZrJHxj/RNEC6RtroOQtGKuj+KZM8+ZBKUSOW4E
         a3wRX0m2flBBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 02/40] x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk
Date:   Wed, 24 Feb 2021 07:53:02 -0500
Message-Id: <20210224125340.483162-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
index 762f5c1465a6f..a9d4d6fbc7824 100644
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

