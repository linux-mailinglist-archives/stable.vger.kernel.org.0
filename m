Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DE732EAB1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhCEMjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233106AbhCEMj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:39:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACC2B64E84;
        Fri,  5 Mar 2021 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947968;
        bh=7XXtaGApa8JWrM+GbGZ5EJTSEgRpjYVbkbv86MZMxnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUQU3IPDmKTBYSvfeclcAyZwoxmh39aLUtk1CZ5bqRAnSQVPgobtQ9C1xGlnx6eb4
         38ToIilReG0ei1P71tO3x+BUnZ3MGeWHzyNNDMXq1oxBEejO5y2SKsL0+G3ZTx7NS8
         G59/kdSakjtpJbQW1beT5xgO1gAPFnOi7UyfQm+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/39] x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk
Date:   Fri,  5 Mar 2021 13:22:19 +0100
Message-Id: <20210305120852.784437706@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0d52c9050113..729e288718cc 100644
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
2.30.1



