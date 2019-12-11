Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286A711B57D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbfLKPSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732091AbfLKPSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D042073D;
        Wed, 11 Dec 2019 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077487;
        bh=A1ZdWbOZBAgzeB7zAfenrAwS2Iwdf/T+yXO8V1j7qLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dyma3A7ytV8yo7uE0ho+NOqXUBYSDqmy1+ah3U0u6whBQ3gSBv5RJvvdd39WZ2NIr
         0Ilh32L1GOAuXrypjSGnEGsgFzvIswHjeOxdIQjts/wQf5CmMZjh08P4s4pI3TjPdY
         qFPWhcM5A1Oa2pCMhnepV08ziVA00RuZ5CMdi9h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/243] iwlwifi: trans: Clear persistence bit when starting the FW
Date:   Wed, 11 Dec 2019 16:03:12 +0100
Message-Id: <20191211150341.017417784@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit 8954e1eb2270fa2effffd031b4839253952c76f2 ]

In D3 suspend flow in 9260 gen2 HW, the NIC receives two PERST signals.
The first PERST is expected and indicates the device on coming resume flow.
The second PERST causes FW restart FW restart.
In order to avoid this issue, the FW set the persistence bit on.
Once this bit is set, the FW ignores reset attempts.
The problem is when the FW gets assert during D3 and then the persistence
bit is set and causes the FW to ignore reset.
To handle this issue, the FW opens the preg bit which allows access
to the persistence bit, so that the driver clear the persistence bit
and reset the NIC.

The flow is as follows:
the driver checks if the persistence bit is set.
If the bit is set, the driver checks if he can clear the bit.
If the driver can not clear the bit then there is no point to continue
configuring the NIC since it will fail.

The fix was added is in start HW flow instead of the resume flow since in
general, if the persistence bit is set, the driver can not start the FW.
So it is good to check it when we start configuring the NIC.

The driver does not need to close the preg bit since the FW close it
during the start flow.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 421a869633a32..2e512f6e9ebcd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -35,6 +36,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -399,6 +401,7 @@ enum aux_misc_master1_en {
 #define AUX_MISC_MASTER1_SMPHR_STATUS	0xA20800
 #define RSA_ENABLE			0xA24B08
 #define PREG_AUX_BUS_WPROT_0		0xA04CC0
+#define PREG_PRPH_WPROT_0		0xA04CE0
 #define SB_CPU_1_STATUS			0xA01E30
 #define SB_CPU_2_STATUS			0xA01E34
 #define UMAG_SB_CPU_1_STATUS		0xA038C0
@@ -425,4 +428,8 @@ enum {
 #define UREG_CHICK		(0xA05C00)
 #define UREG_CHICK_MSI_ENABLE	BIT(24)
 #define UREG_CHICK_MSIX_ENABLE	BIT(25)
+
+#define HPM_DEBUG			0xA03440
+#define PERSISTENCE_BIT			BIT(12)
+#define PREG_WFPM_ACCESS		BIT(12)
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 954f932e9c88e..f89d43bc7d4bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1747,6 +1747,7 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 hpm;
 	int err;
 
 	lockdep_assert_held(&trans_pcie->mutex);
@@ -1757,6 +1758,17 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 		return err;
 	}
 
+	hpm = iwl_trans_read_prph(trans, HPM_DEBUG);
+	if (hpm != 0xa5a5a5a0 && (hpm & PERSISTENCE_BIT)) {
+		if (iwl_trans_read_prph(trans, PREG_PRPH_WPROT_0) &
+		    PREG_WFPM_ACCESS) {
+			IWL_ERR(trans,
+				"Error, can not clear persistence bit\n");
+			return -EPERM;
+		}
+		iwl_trans_write_prph(trans, HPM_DEBUG, hpm & ~PERSISTENCE_BIT);
+	}
+
 	iwl_trans_pcie_sw_reset(trans);
 
 	err = iwl_pcie_apm_init(trans);
-- 
2.20.1



