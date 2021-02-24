Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D8323C27
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 13:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhBXMvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232000AbhBXMvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:51:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DC064DD3;
        Wed, 24 Feb 2021 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171032;
        bh=95bnRf4Sy08is9ld3YbSEJxzIe1alk73qBgcEW19JGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDmkZJR01vB0it9UsF8B8ae7hy9OcphXoSCwvU8IjmGnuh+UUBXhRaRBdL/hp+xfJ
         tQy04wVR+pQISXGxumaGgr7LS0wbRjQt9T6O80zUuLP71H8p8mgEduDdMz2N+Y/qI/
         XFT85Mijbi0M7T9UvWiHx7EpVgqU0/DFp4oAHuh8MLNJuKFxPEdmHIC0tKyYn5H25w
         J4D6KGCNPXTlDzAtmHKlNlcrD1zjV0TAnyePW/3kXKOlIoRcITU2r1aXDAkBDzTeRs
         rA6vq7LfU5NwB/qxgi0zi2femI8g/Is4Cc3ZKP18rYxGIN3Aaj+Yn6x5YWonktqkHD
         42sMKJMd/eGuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 04/67] x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk
Date:   Wed, 24 Feb 2021 07:49:22 -0500
Message-Id: <20210224125026.481804-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index db115943e8bdc..9991c5920aace 100644
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

