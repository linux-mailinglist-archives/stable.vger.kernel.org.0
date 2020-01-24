Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2738147DEA
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388788AbgAXKEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389097AbgAXKEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:04:12 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90812218AC;
        Fri, 24 Jan 2020 10:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860252;
        bh=KJGNqo10mAJdeZR1iC0ThmXuqdofLYgqTNzk8qDPVd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLHnXRreW3oP6Y29WNxhzzt106/fnx+v2hzajC6ypPDBF6p3Xhhy7sFImlXVFVGSR
         anUMlfylhSY8yQcZkGrqxQ3gMFLbKaSz/uCwkxt3iWnrpZVWOI77DRnbCp0osUaUc0
         jNnBXNRoVJx3idzgfy9n6a9RHZzUHJOyUOEujFXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 295/343] scsi: fnic: fix msix interrupt allocation
Date:   Fri, 24 Jan 2020 10:31:53 +0100
Message-Id: <20200124092958.760582258@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4e3a50202e8c5..d28088218c364 100644
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



