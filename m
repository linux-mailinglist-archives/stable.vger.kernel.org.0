Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB743474285
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhLNM2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 07:28:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41450 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbhLNM2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 07:28:08 -0500
Date:   Tue, 14 Dec 2021 12:28:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639484887;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUn08o1QICiur9KV3LhqTmENhFsY+P3nxHAkW5AK+zg=;
        b=RhIizFlJzcemO/2q8YoquMaRKhNCoBB2Rvi6BRe/1h5VexBM5tzhs0nFrO04fWx+SlYYX3
        c+cYV5i2VWR9IQm7UDcpQESGyo2ZqRbxW80Rtwx3C6MoiweOhdgoKvltfsp0h4iyB6GUT9
        jTWk2iuA88jhSId6UPkNOmrq3oR7HDGnh2lLZjv7gpniydCpPFpaXvSTV6NfHdv8ZlFSeI
        zNmokgBp2W2smvDpSraHmUZ5Y+GCZA+xh4Z/ME0SZZuADp26JBHoTOcv8FIFYTtooKJ4Py
        EoUPHcwL7Z1ZqDwpIahHWIcpp9dHXYhK6JaXdRzZTWn1Ibb67EeyDJ2J4k4osw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639484887;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUn08o1QICiur9KV3LhqTmENhFsY+P3nxHAkW5AK+zg=;
        b=g/vq/uy22LWZZk0jaSdYB9KYlRlNqYGiup292WCfU5Ow36EXZtvf7A2k+47nn9iQ3DXBNz
        w2aBMumhy85m4lDA==
From:   "tip-bot2 for Stefan Roese" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] PCI/MSI: Mask MSI-X vectors only on success
Cc:     Stefan Roese <sr@denx.de>, Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marek Vasut <marex@denx.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20211210161025.3287927-1-sr@denx.de>
References: <20211210161025.3287927-1-sr@denx.de>
MIME-Version: 1.0
Message-ID: <163948488617.23020.3934435568065766936.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     83dbf898a2d45289be875deb580e93050ba67529
Gitweb:        https://git.kernel.org/tip/83dbf898a2d45289be875deb580e93050ba=
67529
Author:        Stefan Roese <sr@denx.de>
AuthorDate:    Tue, 14 Dec 2021 12:49:32 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 14 Dec 2021 13:23:32 +01:00

PCI/MSI: Mask MSI-X vectors only on success

Masking all unused MSI-X entries is done to ensure that a crash kernel
starts from a clean slate, which correponds to the reset state of the
device as defined in the PCI-E specificion 3.0 and later:

 Vector Control for MSI-X Table Entries
 --------------------------------------

 "00: Mask bit:  When this bit is set, the function is prohibited from
                 sending a message using this MSI-X Table entry.
                 ...
                 This bit=E2=80=99s state after reset is 1 (entry is masked)."

A Marvell NVME device fails to deliver MSI interrupts after trying to
enable MSI-X interrupts due to that masking. It seems to take the MSI-X
mask bits into account even when MSI-X is disabled.

While not specification compliant, this can be cured by moving the masking
into the success path, so that the MSI-X table entries stay in device reset
state when the MSI-X setup fails.

[ tglx: Move it into the success path, add comment and amend changelog ]

Fixes: aa8092c1d1f1 ("PCI/MSI: Mask all unused MSI-X entries")               =
                                                                             =
                                                                             =
                                       =20
Signed-off-by: Stefan Roese <sr@denx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211210161025.3287927-1-sr@denx.de
---
 drivers/pci/msi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 48e3f4e..6748cf9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -722,9 +722,6 @@ static int msix_capability_init(struct pci_dev *dev, stru=
ct msix_entry *entries,
 		goto out_disable;
 	}
=20
-	/* Ensure that all table entries are masked. */
-	msix_mask_all(base, tsize);
-
 	ret =3D msix_setup_entries(dev, base, entries, nvec, affd);
 	if (ret)
 		goto out_disable;
@@ -751,6 +748,16 @@ static int msix_capability_init(struct pci_dev *dev, str=
uct msix_entry *entries,
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
 	dev->msix_enabled =3D 1;
+
+	/*
+	 * Ensure that all table entries are masked to prevent
+	 * stale entries from firing in a crash kernel.
+	 *
+	 * Done late to deal with a broken Marvell NVME device
+	 * which takes the MSI-X mask bits into account even
+	 * when MSI-X is disabled, which prevents MSI delivery.
+	 */
+	msix_mask_all(base, tsize);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
=20
 	pcibios_free_irq(dev);
