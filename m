Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDEF323E22
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhBXNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234687AbhBXNOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BF864F16;
        Wed, 24 Feb 2021 12:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171363;
        bh=sKvHIgL/l1QEV3lxkHIC+X9c/4adxcwQtk6flkVZGfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPHpf+olCjq9YKkT5nt74auSElpYR7hwxN7hqT3IIQYCKEwnI8F2ZBwWZmHshd1Mz
         mbMymA023cDJMLZ4gUn+Vc7twrGg2keCseiyTm06P48K+8jJT96f204K9jkinib+8W
         Xfudtd6m/jgrysW6j5GF36IBC4hXBTYaoFBfomvXrjwSXgPwfPM3rWdPOPaZhQrJoo
         0M2rLm4QWtthuf7pm4RXdV2ZS/8tBmdXqnZKIoGfZt+VUOoSiMZ/DD/ohkOtKarfZK
         axAHBbPzyPlA/verUoE741aLXUSavu/6Y3y9iz23ZiwqGzAfjKRcIFgpnoWjg4iNl/
         Vnr6MTV+TrNdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 02/11] x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk
Date:   Wed, 24 Feb 2021 07:55:50 -0500
Message-Id: <20210224125600.484437-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125600.484437-1-sashal@kernel.org>
References: <20210224125600.484437-1-sashal@kernel.org>
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
index 877e3cb6edfbe..0514088ce45b9 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -418,6 +418,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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

