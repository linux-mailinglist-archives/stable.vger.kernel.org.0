Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C101B45C0FF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346085AbhKXNOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343512AbhKXNLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:11:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5450C613D5;
        Wed, 24 Nov 2021 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757727;
        bh=eK36jgu27/MC9jk/GRb2732biIOJb6QUwZd33yza+BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSaYTKDoH6q1h60g7HBCe31FfDWFhTPbW2fI3ooL3CWFOo82xoy5c6AO4OLTECkqY
         4glZTv0Ziu0McRAjXxvAnIPiaB1K2NhPfVl1O8R+okOZJgFzY34GVBOySXRcPy9CoD
         vHXpHVAIKYVdz8EUwuJBJWXLw65ko2reeIZp04yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 4.19 256/323] PCI: Add MSI masking quirk for Nvidia ION AHCI
Date:   Wed, 24 Nov 2021 12:57:26 +0100
Message-Id: <20211124115727.537972219@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -5579,3 +5579,9 @@ static void apex_pci_fixup_class(struct
 }
 DECLARE_PCI_FIXUP_CLASS_HEADER(0x1ac1, 0x089a,
 			       PCI_CLASS_NOT_DEFINED, 8, apex_pci_fixup_class);
+
+static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
+{
+	pdev->dev_flags |= PCI_DEV_FLAGS_HAS_MSI_MASKING;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0ab8, nvidia_ion_ahci_fixup);


