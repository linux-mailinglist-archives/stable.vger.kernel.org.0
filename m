Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8BF3D5F77
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhGZPSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237750AbhGZPQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94A3460F38;
        Mon, 26 Jul 2021 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315011;
        bh=c9we61LH9THK6vsVd9+FlQGRPDtL/p/gTxtyUp1s0jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtrqMOuEyUVz8sof+DIdnBDy13qmaIuSP9OOX4EVTDv5mHgoYvbKmguK3dr5uGzN5
         UdAfo+qWYCSairPcwHRy4D4tH9Ahi6YVm1Mf6Muic/Y6hBD/LKNYZIW1Gimi89w/+9
         myZnuQciDTWPe+QLUWSlbFaUKSULp17fLkF++Rv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/108] bnxt_en: Improve bnxt_ulp_stop()/bnxt_ulp_start() call sequence.
Date:   Mon, 26 Jul 2021 17:38:52 +0200
Message-Id: <20210726153833.322482459@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit aa46dffff452f7c6d907c4e6a0062e2c53a87fc0 ]

We call bnxt_ulp_stop() to notify the RDMA driver that some error or
imminent reset is about to happen.  After that we always call
some variants of bnxt_close().

In the next patch, we will integrate the recently added error
recovery with the RDMA driver.  In response to ulp_stop, the
RDMA driver may free MSIX vectors and that will also trigger
bnxt_close().  To avoid bnxt_close() from being called twice,
we set a new flag after ulp_stop is called.  If the RDMA driver
frees MSIX vectors while the new flag is set, we will not call
bnxt_close(), knowing that it will happen in due course.

With this change, we must make sure that the bnxt_close() call
after ulp_stop will reset IRQ.  Modify bnxt_reset_task()
accordingly if we call ulp_stop.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 18 ++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 10 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  3 ++-
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d1c3939b0307..e840aae894ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9987,12 +9987,15 @@ static void bnxt_reset_task(struct bnxt *bp, bool silent)
 	if (netif_running(bp->dev)) {
 		int rc;
 
-		if (!silent)
+		if (silent) {
+			bnxt_close_nic(bp, false, false);
+			bnxt_open_nic(bp, false, false);
+		} else {
 			bnxt_ulp_stop(bp);
-		bnxt_close_nic(bp, false, false);
-		rc = bnxt_open_nic(bp, false, false);
-		if (!silent && !rc)
-			bnxt_ulp_start(bp);
+			bnxt_close_nic(bp, true, false);
+			rc = bnxt_open_nic(bp, true, false);
+			bnxt_ulp_start(bp, rc);
+		}
 	}
 }
 
@@ -12144,10 +12147,9 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		if (!err && netif_running(netdev))
 			err = bnxt_open(netdev);
 
-		if (!err) {
+		if (!err)
 			result = PCI_ERS_RESULT_RECOVERED;
-			bnxt_ulp_start(bp);
-		}
+		bnxt_ulp_start(bp, err);
 	}
 
 	if (result != PCI_ERS_RESULT_RECOVERED) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 13ef6a9afaa0..85bacaed763e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -186,7 +186,7 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
 
 	edev->ulp_tbl[ulp_id].msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
-	if (netif_running(dev)) {
+	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
 		bnxt_close_nic(bp, true, false);
 		bnxt_open_nic(bp, true, false);
 	}
@@ -274,6 +274,7 @@ void bnxt_ulp_stop(struct bnxt *bp)
 	if (!edev)
 		return;
 
+	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
 	for (i = 0; i < BNXT_MAX_ULP; i++) {
 		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
 
@@ -284,7 +285,7 @@ void bnxt_ulp_stop(struct bnxt *bp)
 	}
 }
 
-void bnxt_ulp_start(struct bnxt *bp)
+void bnxt_ulp_start(struct bnxt *bp, int err)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
@@ -293,6 +294,11 @@ void bnxt_ulp_start(struct bnxt *bp)
 	if (!edev)
 		return;
 
+	edev->flags &= ~BNXT_EN_FLAG_ULP_STOPPED;
+
+	if (err)
+		return;
+
 	for (i = 0; i < BNXT_MAX_ULP; i++) {
 		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index cd78453d0bf0..9895406b9830 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -64,6 +64,7 @@ struct bnxt_en_dev {
 	#define BNXT_EN_FLAG_ROCE_CAP		(BNXT_EN_FLAG_ROCEV1_CAP | \
 						 BNXT_EN_FLAG_ROCEV2_CAP)
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
+	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
 	const struct bnxt_en_ops	*en_ops;
 	struct bnxt_ulp			ulp_tbl[BNXT_MAX_ULP];
 };
@@ -92,7 +93,7 @@ int bnxt_get_ulp_msix_num(struct bnxt *bp);
 int bnxt_get_ulp_msix_base(struct bnxt *bp);
 int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
 void bnxt_ulp_stop(struct bnxt *bp);
-void bnxt_ulp_start(struct bnxt *bp);
+void bnxt_ulp_start(struct bnxt *bp, int err);
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
 void bnxt_ulp_shutdown(struct bnxt *bp);
 void bnxt_ulp_irq_stop(struct bnxt *bp);
-- 
2.30.2



