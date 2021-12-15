Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF2475EA7
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbhLORXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40836 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245466AbhLORXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B5EEB82027;
        Wed, 15 Dec 2021 17:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91171C36AE4;
        Wed, 15 Dec 2021 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588993;
        bh=FIKl4F/MdQGM7YdaX3PO/RcJEh6FF2j6scAJ0IO5Z54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UP8Gw8P30R5/FTVmFj35Yu/bIuhAPEodDRCG0az+iqjaLi7Pu8pQST9zGrXucJPfa
         PMeg7LYlSq1mEqQTLNKYszironfl8CirMqgB2XbudcKiE8PldREuyeQu0HuMbDsx2m
         gLQyun0L2Tp7nVl8lrxP4uWm7lyZM9pTu9guUN14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        Guolin Yang <gyang@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/42] vmxnet3: fix minimum vectors alloc issue
Date:   Wed, 15 Dec 2021 18:20:58 +0100
Message-Id: <20211215172027.242211438@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>

[ Upstream commit f71ef02f1a4a3c49962fa341ad8de19071f0f9bf ]

'Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")'
added support for 32Tx/Rx queues. Within that patch, value of
VMXNET3_LINUX_MIN_MSIX_VECT was updated.

However, there is a case (numvcpus = 2) which actually requires 3
intrs which matches VMXNET3_LINUX_MIN_MSIX_VECT which then is
treated as failure by stack to allocate more vectors. This patch
fixes this issue.

Fixes: 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Link: https://lore.kernel.org/r/20211207081737.14000-1-doshir@vmware.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 8799854bacb29..5b0215b7c1761 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3261,7 +3261,7 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 
 #ifdef CONFIG_PCI_MSI
 	if (adapter->intr.type == VMXNET3_IT_MSIX) {
-		int i, nvec;
+		int i, nvec, nvec_allocated;
 
 		nvec  = adapter->share_intr == VMXNET3_INTR_TXSHARE ?
 			1 : adapter->num_tx_queues;
@@ -3274,14 +3274,15 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 		for (i = 0; i < nvec; i++)
 			adapter->intr.msix_entries[i].entry = i;
 
-		nvec = vmxnet3_acquire_msix_vectors(adapter, nvec);
-		if (nvec < 0)
+		nvec_allocated = vmxnet3_acquire_msix_vectors(adapter, nvec);
+		if (nvec_allocated < 0)
 			goto msix_err;
 
 		/* If we cannot allocate one MSIx vector per queue
 		 * then limit the number of rx queues to 1
 		 */
-		if (nvec == VMXNET3_LINUX_MIN_MSIX_VECT) {
+		if (nvec_allocated == VMXNET3_LINUX_MIN_MSIX_VECT &&
+		    nvec != VMXNET3_LINUX_MIN_MSIX_VECT) {
 			if (adapter->share_intr != VMXNET3_INTR_BUDDYSHARE
 			    || adapter->num_rx_queues != 1) {
 				adapter->share_intr = VMXNET3_INTR_TXSHARE;
@@ -3291,14 +3292,14 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 			}
 		}
 
-		adapter->intr.num_intrs = nvec;
+		adapter->intr.num_intrs = nvec_allocated;
 		return;
 
 msix_err:
 		/* If we cannot allocate MSIx vectors use only one rx queue */
 		dev_info(&adapter->pdev->dev,
 			 "Failed to enable MSI-X, error %d. "
-			 "Limiting #rx queues to 1, try MSI.\n", nvec);
+			 "Limiting #rx queues to 1, try MSI.\n", nvec_allocated);
 
 		adapter->intr.type = VMXNET3_IT_MSI;
 	}
-- 
2.33.0



