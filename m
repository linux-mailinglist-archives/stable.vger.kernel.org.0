Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F2366D50
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfGLM2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbfGLM2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03950216E3;
        Fri, 12 Jul 2019 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934514;
        bh=tfB0Yjzx+vKSU/qmFD3zv4coZikWMkBZyaZVhmcmguU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0ycGOlGBNZENjJO883CVXq7H9v7ufRUJvxbWiqRTlcXBQuTZE7iSdM2GANnWzYdQ
         Ah5sVbEMMBNnk9HEQqPUBnSdlanyJAOVr162Zt/OMfaBCz/ZJl/pwHC7GJp0FkWfya
         R+oXZf2Uxt7wEBb9ZVcudUVI2bjMCXxp9uRKYJ58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 026/138] iwlwifi: fix AX201 killer sku loading firmware issue
Date:   Fri, 12 Jul 2019 14:18:10 +0200
Message-Id: <20190712121629.706800471@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b17dc0632a17fbfe66b34ee7c24e1cc10cfc503e ]

When try to bring up the AX201 2 killer sku, we
run into:
[81261.392463] iwlwifi 0000:01:00.0: loaded firmware version 46.8c20f243.0 op_mode iwlmvm
[81261.407407] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AX 22000, REV=0x340
[81262.424778] iwlwifi 0000:01:00.0: Collecting data: trigger 16 fired.
[81262.673359] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[81262.673365] iwlwifi 0000:01:00.0: Status: 0x00000000, count: -906373681
[81262.673368] iwlwifi 0000:01:00.0: Loaded firmware version: 46.8c20f243.0
[81262.673371] iwlwifi 0000:01:00.0: 0x507C015D | ADVANCED_SYSASSERT

Fix this issue by adding 2 more cfg to avoid modifying the
original cfg configuration.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 2a03d34afa3b..80695584e406 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3585,7 +3585,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   (trans->cfg != &iwl_ax200_cfg_cc ||
+		   ((trans->cfg != &iwl_ax200_cfg_cc &&
+		    trans->cfg != &killer1650x_2ax_cfg &&
+		    trans->cfg != &killer1650w_2ax_cfg) ||
 		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
-- 
2.20.1



