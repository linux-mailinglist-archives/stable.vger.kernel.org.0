Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35022064B7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbgFWV00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389608AbgFWUSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CECAE2073E;
        Tue, 23 Jun 2020 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943480;
        bh=XiwbN0uIdxo4hzfP5tYmkFlzC1Q6dYCAtXNfbnfkMyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQD1qPllj7337F1z9cDbRruKYikC0OpJYR068Nab/LB9WdR5C2YHaFUhVGxuV1+Vo
         oYN0YnPyJpaU+aIIz0nhQwUSH72Bq3WxjMrR6asc+U0rIK+S4pW990OEbzMIE5b/lM
         bFfC+IXeiKhltNCkcI986Gzp/sHaI0SbUxuQzUsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 401/477] bnxt_en: Fix AER reset logic on 57500 chips.
Date:   Tue, 23 Jun 2020 21:56:38 +0200
Message-Id: <20200623195426.485874809@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 6e2f83884c099de0e87b15a820736e522755d074 ]

AER reset should follow the same steps as suspend/resume.  We need to
free context memory during AER reset and allocate new context memory
during recovery by calling bnxt_hwrm_func_qcaps().  We also need
to call bnxt_reenable_sriov() to restore the VFs.

Fixes: bae361c54fb6 ("bnxt_en: Improve AER slot reset.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f8b26265cb86d..a29bf3ca0b48e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12160,6 +12160,9 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 		bnxt_close(netdev);
 
 	pci_disable_device(pdev);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
 	rtnl_unlock();
 
 	/* Request a slot slot reset. */
@@ -12193,12 +12196,16 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		pci_set_master(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
-		if (!err && netif_running(netdev))
-			err = bnxt_open(netdev);
-
-		if (!err)
-			result = PCI_ERS_RESULT_RECOVERED;
+		if (!err) {
+			err = bnxt_hwrm_func_qcaps(bp);
+			if (!err && netif_running(netdev))
+				err = bnxt_open(netdev);
+		}
 		bnxt_ulp_start(bp, err);
+		if (!err) {
+			bnxt_reenable_sriov(bp);
+			result = PCI_ERS_RESULT_RECOVERED;
+		}
 	}
 
 	if (result != PCI_ERS_RESULT_RECOVERED) {
-- 
2.25.1



