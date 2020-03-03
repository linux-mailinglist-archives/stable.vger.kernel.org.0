Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774471780E2
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbgCCR7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:59:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731109AbgCCR7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:59:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86CEE214D8;
        Tue,  3 Mar 2020 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258360;
        bh=CObFl1cb5UvCfomOI018fcjAEGpaCccIR6+DPEZK/Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWKQKGO7pLNFg5S1uSR/jcmdENzXUukeauIeFc5rVFNH3yAEHmOT+jwBu6WcYfMR9
         8SFpuepMGzka7TvHApJcpMOIsazWBtGHXAXMvMXpAz/DAOgHDT9ozVtajxEMs7d1/y
         bbsXEVY7OZqnfL1yPYV3C63Srfz4UMaq0vTqpfO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ajay Kaher <akaher@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/87] iwlwifi: pcie: fix rb_allocator workqueue allocation
Date:   Tue,  3 Mar 2020 18:42:53 +0100
Message-Id: <20200303174349.250817378@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 4f5571123f70a..24da496151353 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3283,6 +3283,15 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
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
@@ -3485,10 +3494,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		trans_pcie->inta_mask = CSR_INI_SET_MASK;
 	 }
 
-	trans_pcie->rba.alloc_wq = alloc_workqueue("rb_allocator",
-						   WQ_HIGHPRI | WQ_UNBOUND, 1);
-	INIT_WORK(&trans_pcie->rba.rx_alloc, iwl_pcie_rx_allocator_work);
-
 #ifdef CONFIG_IWLWIFI_PCIE_RTPM
 	trans->runtime_pm_mode = IWL_PLAT_PM_MODE_D0I3;
 #else
@@ -3501,6 +3506,8 @@ out_free_ict:
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



