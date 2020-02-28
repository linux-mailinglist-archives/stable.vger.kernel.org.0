Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBDB17430B
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 00:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1X31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 18:29:27 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:27830 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgB1X30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 18:29:26 -0500
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 28 Feb 2020 15:29:23 -0800
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 940A3B2B24;
        Fri, 28 Feb 2020 18:29:25 -0500 (EST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <johannes.berg@intel.com>, <luciano.coelho@intel.com>,
        <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <sharathg@vmware.com>,
        <srostedt@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v4.9.y] iwlwifi: pcie: fix rb_allocator workqueue allocation
Date:   Sat, 29 Feb 2020 04:54:54 +0530
Message-ID: <1582932295-38704-2-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582932295-38704-1-git-send-email-akaher@vmware.com>
References: <1582932295-38704-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
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
[Ajay: Rewrote this patch for v4.9.y, as 4.9.y codebase is different from mainline]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a2ebe46..395bbe2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -898,9 +898,13 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 			return err;
 	}
 	def_rxq = trans_pcie->rxq;
-	if (!rba->alloc_wq)
+	if (!rba->alloc_wq) {
 		rba->alloc_wq = alloc_workqueue("rb_allocator",
 						WQ_HIGHPRI | WQ_UNBOUND, 1);
+		if (!rba->alloc_wq)
+			return -ENOMEM;
+	}
+
 	INIT_WORK(&rba->rx_alloc, iwl_pcie_rx_allocator_work);
 
 	cancel_work_sync(&rba->rx_alloc);
-- 
2.7.4

