Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DB6E33CE
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 23:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjDOVVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDOVVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 17:21:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361CB30F3;
        Sat, 15 Apr 2023 14:21:35 -0700 (PDT)
Date:   Sat, 15 Apr 2023 21:21:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681593693;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TUSThRTgdTWs/ai6cPSjjl0Mnq13OWeaBORpLGVL2c=;
        b=pWc+tjnOt6127IJkmF4dTlGBXvZWNIbFDs4Nqw8azUryWap2LnQN/hvkZhHRZij+j+lT8n
        VX0kDH85d6ZAEhXcqhAAzl3+/Yz3npl8EHX9EG21YcfX3yJxAMPV1mZHNDqrTQJcig8ie+
        gXg//fw1qTyMmza06XLIoZof7GCvXDayiigNunoCqYbSmqAaTdGzLnOx6UZ2MPWdVY3Gru
        OSByYgZ/CIymsymGfZhuhomxzrtKuWdVZUKbOLl3mzZWMG5k8JjPmegkBCGEo5l8poXrv5
        rnMjoVJTvuA6uPL4NBnA/1g1kPVRP8lxu01jMfP/mZ9Jb2OLow7Sax5znZtp3g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681593693;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TUSThRTgdTWs/ai6cPSjjl0Mnq13OWeaBORpLGVL2c=;
        b=LmCsz3t5fubHF/YUISNn3GBTQ/pZhIj9Mp7VogmousplRXLJmGtJ6P2vyoZR7sW3+L57jr
        BDMqrBcrE8AtaWAw==
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
Message-ID: <168159369349.404.3067509099059917093.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     84d9651e13fb9820041d19262a55906851524c0f
Gitweb:        https://git.kernel.org/tip/84d9651e13fb9820041d19262a55906851524c0f
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 10 Apr 2023 21:14:45 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 15 Apr 2023 23:17:32 +02:00

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
index 1f71662..24899d9 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -750,8 +750,7 @@ out_disable:
 	return ret;
 }
 
-static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries,
-				      int nvec, int hwsize)
+static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries, int nvev)
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
