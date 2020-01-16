Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A62913F352
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390436AbgAPSmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389988AbgAPRLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D799D2468B;
        Thu, 16 Jan 2020 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194698;
        bh=osu43gUfm3EZl60KJo19B78H6kg+zt5SbEr1OSOYKg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S95ZgE/bQTqNmOURobylJaKJS9OWp1+YgWX2QdZ/nb5ZRvlv65shMCgDgR0KMMU5/
         MGyekPGnM/UNhlX5GlMYxR+8Szxvfw0rBHVYWvnJXtnVUC62aWzNU+z+zgUx1HH0uy
         nLXRw/fxLbVq6BBGEg7FZwKXibJ+ph/Yn/BIPfPk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 538/671] scsi: fnic: fix msix interrupt allocation
Date:   Thu, 16 Jan 2020 12:02:56 -0500
Message-Id: <20200116170509.12787-275-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Govindarajulu Varadarajan <gvaradar@cisco.com>

[ Upstream commit 3ec24fb4c035e9cbb2f02a48640a09aa913442a2 ]

pci_alloc_irq_vectors() returns number of vectors allocated.  Fix the check
for error condition.

Fixes: cca678dfbad49 ("scsi: fnic: switch to pci_alloc_irq_vectors")
Link: https://lore.kernel.org/r/20190827211340.1095-1-gvaradar@cisco.com
Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
Acked-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 4e3a50202e8c..d28088218c36 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -254,7 +254,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		int vecs = n + m + o + 1;
 
 		if (pci_alloc_irq_vectors(fnic->pdev, vecs, vecs,
-				PCI_IRQ_MSIX) < 0) {
+				PCI_IRQ_MSIX) == vecs) {
 			fnic->rq_count = n;
 			fnic->raw_wq_count = m;
 			fnic->wq_copy_count = o;
@@ -280,7 +280,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	    fnic->wq_copy_count >= 1 &&
 	    fnic->cq_count >= 3 &&
 	    fnic->intr_count >= 1 &&
-	    pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) < 0) {
+	    pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) == 1) {
 		fnic->rq_count = 1;
 		fnic->raw_wq_count = 1;
 		fnic->wq_copy_count = 1;
-- 
2.20.1

