Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1604575CD
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhKSRmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236910AbhKSRmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A0E6128B;
        Fri, 19 Nov 2021 17:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343542;
        bh=nJnCCC2Ffz6qOqBha7L6aK3BaJ98T5nKhuzlXGY4NjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDP9rWhpDT77kqicTs+rBM9YyRWT77s0mwuogBJnxyTTN1UQ9ExwXkOEsRON4rWQS
         S8olmYpG8+DbIl8wgjSMUZfBg+ScmRTQtyPgMoaeswDhfMcxtIDkV3DOJT678sVPbx
         mMz0+tld93MZYIngGHO5qkEcW7TCHImMPmqpEpiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 5.14 12/15] PCI: Add MSI masking quirk for Nvidia ION AHCI
Date:   Fri, 19 Nov 2021 18:38:45 +0100
Message-Id: <20211119171444.109206444@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
References: <20211119171443.724340448@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit f21082fb20dbfb3e42b769b59ef21c2a7f2c7c1f upstream.

The ION AHCI device pretends that MSI masking isn't a thing, while it
actually implements it and needs MSIs to be unmasked to work. Add a quirk
to that effect.

Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Link: https://lore.kernel.org/r/CALjTZvbzYfBuLB+H=fj2J+9=DxjQ2Uqcy0if_PvmJ-nU-qEgkg@mail.gmail.com
Link: https://lore.kernel.org/r/20211104180130.3825416-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5760,3 +5760,9 @@ static void apex_pci_fixup_class(struct
 }
 DECLARE_PCI_FIXUP_CLASS_HEADER(0x1ac1, 0x089a,
 			       PCI_CLASS_NOT_DEFINED, 8, apex_pci_fixup_class);
+
+static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
+{
+	pdev->dev_flags |= PCI_DEV_FLAGS_HAS_MSI_MASKING;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0ab8, nvidia_ion_ahci_fixup);


