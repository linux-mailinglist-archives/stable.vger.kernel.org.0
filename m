Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2640323DFA
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhBXNVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236100AbhBXNNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:13:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF1264F1B;
        Wed, 24 Feb 2021 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171343;
        bh=PT+QYzJ9W9+5krQzudRMZH1AN4P9QMGYmK+aPEmbWyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUI7S48x33ukC8haN4ccYp1g8l7v40Znwy93o29FnAof+rB9rkXqyfxpPiEv5cNwl
         KL0QjNSr87d72R9v4a1eu7IdGS0KZuFfPCP9K672uQnpuSV5pXdYgO1mcnqoUkLx0e
         +jOzcZcWqOCgeotpFEPJF4AY+rocq15MYd9ZFaWDNWLC3HcSb4cedQyK7VFw+OQQdt
         4Q6XcQCphx+Sao4swVvWVB2Zun9DVRyXE6mCGkm4606sLVs+br36dE4EYNZJIG7npk
         INjf/hTdlJIEsZ1NAzjUY73GsJkZDiA6rKb1w/j9Kfdk6vMwpLlwuFvAMDm1j5DZSu
         UNu204DxxyQ5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/12] x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk
Date:   Wed, 24 Feb 2021 07:55:30 -0500
Message-Id: <20210224125540.484221-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125540.484221-1-sashal@kernel.org>
References: <20210224125540.484221-1-sashal@kernel.org>
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
index b427dc73ba274..7d7de82304aab 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -478,6 +478,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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

