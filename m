Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175401FE66E
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgFRBOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbgFRBOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AB7B21D7B;
        Thu, 18 Jun 2020 01:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442871;
        bh=uFpR+BxR1ZP8Le0s2244kM6IUY9wJds3BgH+c5MCtFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfw9el2YZI8neXeeVT5UcHLysIzNuIXcHExhbDX2tu421fB272ZIC5LKbg9hgoVCH
         2JCeIAV+3FYqUN2sru062w9PwId1CYEenpM/0usFxBXonoehsfIMu0lrtN8FjLACFE
         ak0PHckaT8sKf2TQy/Yy8joBgxPP16h5MckCg9RQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcos Scriven <marcos@scriven.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 297/388] PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0
Date:   Wed, 17 Jun 2020 21:06:34 -0400
Message-Id: <20200618010805.600873-297-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Scriven <marcos@scriven.org>

[ Upstream commit 0d14f06cd6657ba3446a5eb780672da487b068e7 ]

The AMD Matisse HD Audio & USB 3.0 devices advertise Function Level Reset
support, but hang when an FLR is triggered.

To reproduce the problem, attach the device to a VM, then detach and try to
attach again.

Rename the existing quirk_intel_no_flr(), which was not Intel-specific, to
quirk_no_flr(), and apply it to prevent the use of FLR on these AMD
devices.

Link: https://lore.kernel.org/r/CAAri2DpkcuQZYbT6XsALhx2e6vRqPHwtbjHYeiH7MNp4zmt1RA@mail.gmail.com
Signed-off-by: Marcos Scriven <marcos@scriven.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index ca9ed5774eb1..43a0c2ce635e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5129,13 +5129,23 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
 
-/* FLR may cause some 82579 devices to hang */
-static void quirk_intel_no_flr(struct pci_dev *dev)
+/*
+ * FLR may cause the following to devices to hang:
+ *
+ * AMD Starship/Matisse HD Audio Controller 0x1487
+ * AMD Matisse USB 3.0 Host Controller 0x149c
+ * Intel 82579LM Gigabit Ethernet Controller 0x1502
+ * Intel 82579V Gigabit Ethernet Controller 0x1503
+ *
+ */
+static void quirk_no_flr(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_intel_no_flr);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_intel_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
 static void quirk_no_ext_tags(struct pci_dev *pdev)
 {
-- 
2.25.1

