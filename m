Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B41A73EAA
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbfGXThG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfGXThG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8081B21873;
        Wed, 24 Jul 2019 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997025;
        bh=i4iMC2HiM7ZuKWoLUuWdkdM6DFGBX4uCqEqwHSAD19c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTrOTvxxKjdQ7pYLI2LLe4LfDxbhyrv59PekjsUBF2+511Py5+W0w/AHdvxVx5mBH
         lNM4rM7AAR/QAOp+Lzahvk6TOGIBsKKuw9RzZuJqPVDeKS+05W1SQZ/LpsjGBt69vj
         1zLVML9Ac2WN9pueDUANCn3xpK9VnkBNrDFuXFTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.2 294/413] iwlwifi: add support for hr1 RF ID
Date:   Wed, 24 Jul 2019 21:19:45 +0200
Message-Id: <20190724191757.170286760@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oren Givon <oren.givon@intel.com>

commit 498d3eb5bfbb2e05e40005152976a7b9eadfb59c upstream.

The 22000 series FW that was meant to be used with hr is
also the FW that is used for hr1 and has a different RF ID.
Add support to load the hr FW when hr1 RF ID is detected.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    |    1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -336,6 +336,7 @@ enum {
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105100)
 #define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
+#define CSR_HW_RF_ID_TYPE_HR1		(0x0010c100)
 #define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109F00)
 #define CSR_HW_RF_ID_TYPE_GF		(0x0010D000)
 #define CSR_HW_RF_ID_TYPE_GF4		(0x0010E000)
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3575,9 +3575,11 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 			trans->cfg = &iwlax210_2ax_cfg_so_gf4_a0;
 		}
 	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
-		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) {
+		if ((CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		     CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
+		     trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) ||
+		    (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		     CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR1))) {
 			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_b0;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {


