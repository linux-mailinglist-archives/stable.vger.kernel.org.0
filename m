Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE917FA85
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgCJNFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbgCJNFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:05:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D7820409;
        Tue, 10 Mar 2020 13:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845531;
        bh=TiMwdOhhkBtIR//LJW1lotenyOjEmsvRK5wcbLFw0GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2+dXriPjfmvRH3JBt/+dPmK8N1RwzceVQCeeJkDrUBkM6pTeeQ1xyRUNyGx7ZKUI
         oUGIxg7TJmdwRyn3HUFJ3yPsQgnQCVyL8QYZD2TYZP7Rwz2/iabqqt4XpxRCKU2rwf
         vqPlgDY5jEU6l6iGAlkVF6vIGielEY4OHMUsIXMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ajay Kaher <akaher@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 001/126] iwlwifi: pcie: fix rb_allocator workqueue allocation
Date:   Tue, 10 Mar 2020 13:40:22 +0100
Message-Id: <20200310124203.801765963@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 8188a18ee2e48c9a7461139838048363bfce3fef upstream

We don't handle failures in the rb_allocator workqueue allocation
correctly. To fix that, move the code earlier so the cleanup is
easier and we don't have to undo all the interrupt allocations in
this case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
[Ajay: Modified to apply on v4.19.y and v4.14.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index dffa697d71e0f..8a074a516fb26 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3023,6 +3023,15 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->reg_lock);
 	mutex_init(&trans_pcie->mutex);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
+
+	trans_pcie->rba.alloc_wq = alloc_workqueue("rb_allocator",
+						   WQ_HIGHPRI | WQ_UNBOUND, 1);
+	if (!trans_pcie->rba.alloc_wq) {
+		ret = -ENOMEM;
+		goto out_free_trans;
+	}
+	INIT_WORK(&trans_pcie->rba.rx_alloc, iwl_pcie_rx_allocator_work);
+
 	trans_pcie->tso_hdr_page = alloc_percpu(struct iwl_tso_hdr_page);
 	if (!trans_pcie->tso_hdr_page) {
 		ret = -ENOMEM;
@@ -3195,10 +3204,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		trans_pcie->inta_mask = CSR_INI_SET_MASK;
 	 }
 
-	trans_pcie->rba.alloc_wq = alloc_workqueue("rb_allocator",
-						   WQ_HIGHPRI | WQ_UNBOUND, 1);
-	INIT_WORK(&trans_pcie->rba.rx_alloc, iwl_pcie_rx_allocator_work);
-
 #ifdef CONFIG_IWLWIFI_PCIE_RTPM
 	trans->runtime_pm_mode = IWL_PLAT_PM_MODE_D0I3;
 #else
@@ -3211,6 +3216,8 @@ out_free_ict:
 	iwl_pcie_free_ict(trans);
 out_no_pci:
 	free_percpu(trans_pcie->tso_hdr_page);
+	destroy_workqueue(trans_pcie->rba.alloc_wq);
+out_free_trans:
 	iwl_trans_free(trans);
 	return ERR_PTR(ret);
 }
-- 
2.20.1



