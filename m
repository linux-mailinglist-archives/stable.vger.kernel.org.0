Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA4246A49
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgHQPdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730007AbgHQPdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EDC0208E4;
        Mon, 17 Aug 2020 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678392;
        bh=XDC8HlI8Khc6j/B3a5sMWFPpwPWA7scLU1kzMsOnJMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgnH5jrK60X/wtiAwub8I52cuntFXA3cl/BWK3hTxoeqB2i9PsyuuaGHmGHyFjAKK
         AgJ2FR7erol9WVHWdjXZ+VZSYCzIbYt/whhjbMw+l94Tm0YJRuE4xoHncpYhoIgqNW
         C/jye91omHKo+FG/SPSVF1/eUWqhJogCwE+BD9ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 288/464] scsi: megaraid_sas: Clear affinity hint
Date:   Mon, 17 Aug 2020 17:14:01 +0200
Message-Id: <20200817143847.549222778@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 1eb81df5c53b1e785fdef298d533feab991381e4 ]

To avoid a warning in free_irq, clear the affinity hint.

Link: https://lore.kernel.org/r/20200709133144.8363-1-thenzl@redhat.com
Fixes: f0b9e7bdc309 ("scsi: megaraid_sas: Set affinity for high IOPS reply queues")
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c2afc..924ea9f4cdd09 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5602,9 +5602,13 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 			&instance->irq_context[i])) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
-			for (j = 0; j < i; j++)
+			for (j = 0; j < i; j++) {
+				if (j < instance->low_latency_index_start)
+					irq_set_affinity_hint(
+						pci_irq_vector(pdev, j), NULL);
 				free_irq(pci_irq_vector(pdev, j),
 					 &instance->irq_context[j]);
+			}
 			/* Retry irq register for IO_APIC*/
 			instance->msix_vectors = 0;
 			instance->msix_load_balance = false;
@@ -5642,6 +5646,9 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
 
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
+			if (i < instance->low_latency_index_start)
+				irq_set_affinity_hint(
+				    pci_irq_vector(instance->pdev, i), NULL);
 			free_irq(pci_irq_vector(instance->pdev, i),
 				 &instance->irq_context[i]);
 		}
-- 
2.25.1



