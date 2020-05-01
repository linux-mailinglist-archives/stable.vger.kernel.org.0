Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976321C1660
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbgEANrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731100AbgEANnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3925208DB;
        Fri,  1 May 2020 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340598;
        bh=VRKwHyeST9eW8Jf751691ackqgxF3NVlkUp43jtpwUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THI21LGX7r4OhdteMLheU4Fn2PcgV/HJkfyF6UEbDjkFcF0molGyGmBMrwtbPXf3N
         Zt2JIhy2U2eJ5NinCHSKnfdNW32ryUNICEosryhtU6pLSJL/6GCva8rtY1TzvXF8WY
         5cspYf1wT9ot7/R94j7b0kx+X8plWoyY/GGw00vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Mendes?= <luis.p.mendes@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 5.6 047/106] PCI: Move Apex Edge TPU class quirk to fix BAR assignment
Date:   Fri,  1 May 2020 15:23:20 +0200
Message-Id: <20200501131549.319111249@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit 0a8f41023e8a3c100b3dc458ed2da651bf961ead upstream.

Some Google Apex Edge TPU devices have a class code of 0
(PCI_CLASS_NOT_DEFINED).  This prevents the PCI core from assigning
resources for the Apex BARs because __dev_sort_resources() ignores
classless devices, host bridges, and IOAPICs.

On x86, firmware typically assigns those resources, so this was not a
problem.  But on some architectures, firmware does *not* assign BARs, and
since the PCI core didn't do it either, the Apex device didn't work
correctly:

  apex 0000:01:00.0: can't enable device: BAR 0 [mem 0x00000000-0x00003fff 64bit pref] not claimed
  apex 0000:01:00.0: error enabling PCI device

f390d08d8b87 ("staging: gasket: apex: fixup undefined PCI class") added a
quirk to fix the class code, but it was in the apex driver, and if the
driver was built as a module, it was too late to help.

Move the quirk to the PCI core, where it will always run early enough that
the PCI core will assign resources if necessary.

Link: https://lore.kernel.org/r/CAEzXK1r0Er039iERnc2KJ4jn7ySNUOG9H=Ha8TD8XroVqiZjgg@mail.gmail.com
Fixes: f390d08d8b87 ("staging: gasket: apex: fixup undefined PCI class")
Reported-by: Luís Mendes <luis.p.mendes@gmail.com>
Debugged-by: Luís Mendes <luis.p.mendes@gmail.com>
Tested-by: Luis Mendes <luis.p.mendes@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c                 |    7 +++++++
 drivers/staging/gasket/apex_driver.c |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5567,3 +5567,10 @@ static void pci_fixup_no_d0_pme(struct p
 	dev->pme_support &= ~(PCI_PM_CAP_PME_D0 >> PCI_PM_CAP_PME_SHIFT);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASMEDIA, 0x2142, pci_fixup_no_d0_pme);
+
+static void apex_pci_fixup_class(struct pci_dev *pdev)
+{
+	pdev->class = (PCI_CLASS_SYSTEM_OTHER << 8) | pdev->class;
+}
+DECLARE_PCI_FIXUP_CLASS_HEADER(0x1ac1, 0x089a,
+			       PCI_CLASS_NOT_DEFINED, 8, apex_pci_fixup_class);
--- a/drivers/staging/gasket/apex_driver.c
+++ b/drivers/staging/gasket/apex_driver.c
@@ -570,13 +570,6 @@ static const struct pci_device_id apex_p
 	{ PCI_DEVICE(APEX_PCI_VENDOR_ID, APEX_PCI_DEVICE_ID) }, { 0 }
 };
 
-static void apex_pci_fixup_class(struct pci_dev *pdev)
-{
-	pdev->class = (PCI_CLASS_SYSTEM_OTHER << 8) | pdev->class;
-}
-DECLARE_PCI_FIXUP_CLASS_HEADER(APEX_PCI_VENDOR_ID, APEX_PCI_DEVICE_ID,
-			       PCI_CLASS_NOT_DEFINED, 8, apex_pci_fixup_class);
-
 static int apex_pci_probe(struct pci_dev *pci_dev,
 			  const struct pci_device_id *id)
 {


