Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9E6E37EF
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 14:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjDPMSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 08:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPMSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 08:18:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2244C02;
        Sun, 16 Apr 2023 05:18:12 -0700 (PDT)
Date:   Sun, 16 Apr 2023 12:18:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681647489;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gm13XR83C+iXnaO/oyyAu8Erv5pXx7ACG/cP6MvwbWQ=;
        b=bve1NIygEl2stF03kSSMBPHqV1XxEAS/5iCfaLdhmgZCdr2HpJTBT5gI+f+Gv16TBiqEFT
        tk0f/hEA9qJLZK7KHOi0mYjCDacBgq83wKQxxeBHWnJDG7v/yxEGItbMBhcLszreY+li7g
        YVWMLXCNZQ3qGGS/uE38nhgE6u9ooCkfz85LoM4jA1DstZFtKz+I2gbrmhTzJb66Ex1ayD
        MXAlX6jKKwFZSDzahPmaM3NcKlga7FFZZLBYkYow3Gj78L3qoVJ2c+gemnlQAN6e64wDVS
        biMHjuziyPWbdf0nvkvXnk9GtKaa+yFQC+BfgZPkph6+t9rJelHWu71yPcepGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681647489;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gm13XR83C+iXnaO/oyyAu8Erv5pXx7ACG/cP6MvwbWQ=;
        b=JUuWxIgM0LjUfDfcnmUKrD3lFtYJKxhL8J5h8saCI7Ou4UMchX9x7KqmyzdLv76i//n8zC
        Vx3fRBhuB4yEw9BQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] PCI/MSI: Remove over-zealous hardware size check in
 pci_msix_validate_entries()
Cc:     David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <87v8i3sg62.ffs@tglx>
References: <87v8i3sg62.ffs@tglx>
MIME-Version: 1.0
Message-ID: <168164748857.404.4755357620928545423.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     e3c026be4d3ca046799fde55ccbae9d0f059fb93
Gitweb:        https://git.kernel.org/tip/e3c026be4d3ca046799fde55ccbae9d0f059fb93
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 10 Apr 2023 21:14:45 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sun, 16 Apr 2023 14:11:51 +02:00

PCI/MSI: Remove over-zealous hardware size check in pci_msix_validate_entries()

pci_msix_validate_entries() validates the entries array which is handed in
by the caller for a MSI-X interrupt allocation. Aside of consistency
failures it also detects a failure when the size of the MSI-X hardware table
in the device is smaller than the size of the entries array.

That's wrong for the case of range allocations where the caller provides
the minimum and the maximum number of vectors to allocate, when the
hardware size is greater or equal than the mininum, but smaller than the
maximum.

Remove the hardware size check completely from that function and just
ensure that the entires array up to the maximum size is consistent.

The limitation and range checking versus the hardware size happens
independently of that afterwards anyway because the entries array is
optional.

Fixes: 4644d22eb673 ("PCI/MSI: Validate MSI-X contiguous restriction early")
Reported-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87v8i3sg62.ffs@tglx

---
 drivers/pci/msi/msi.c |  9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 1f71662..ef1d885 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -750,8 +750,7 @@ out_disable:
 	return ret;
 }
 
-static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries,
-				      int nvec, int hwsize)
+static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
 	bool nogap;
 	int i, j;
@@ -762,10 +761,6 @@ static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *en
 	nogap = pci_msi_domain_supports(dev, MSI_FLAG_MSIX_CONTIGUOUS, DENY_LEGACY);
 
 	for (i = 0; i < nvec; i++) {
-		/* Entry within hardware limit? */
-		if (entries[i].entry >= hwsize)
-			return false;
-
 		/* Check for duplicate entries */
 		for (j = i + 1; j < nvec; j++) {
 			if (entries[i].entry == entries[j].entry)
@@ -805,7 +800,7 @@ int __pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries, int
 	if (hwsize < 0)
 		return hwsize;
 
-	if (!pci_msix_validate_entries(dev, entries, nvec, hwsize))
+	if (!pci_msix_validate_entries(dev, entries, nvec))
 		return -EINVAL;
 
 	if (hwsize < nvec) {
