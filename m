Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4550A13FD73
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388812AbgAPX0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732438AbgAPX0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE5A20684;
        Thu, 16 Jan 2020 23:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217163;
        bh=B7EWYdzw+f0RsTvHeXczbavP40vVNGvfLWkYXmipdd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sjp8yqRGtM3lcfmcFD2zrMkUd9vB6DcwgumPpaznNOMee5Uc1CqJzPbVb37bHIMuR
         pfLlV2RXwb+JZCmdpYn3+NHsKxwWvYjn2YvHEZ3nCCtIBX8S6mZTaPJgLiL9Eh6FDl
         7fvdCFLgbmz9WY6I79ssnOQzSPerfXqnVNyzqkmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 174/203] iwlwifi: mvm: fix support for single antenna diversity
Date:   Fri, 17 Jan 2020 00:18:11 +0100
Message-Id: <20200116231759.707341460@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit bb99ff9baa02beb9216c86678999342197c849cc upstream.

When the single antenna diversity support was sent upstream, only some
definitions were sent, due to a bad revert.

Fix this by adding the actual code.

Fixes: 5952e0ec3f05 ("iwlwifi: mvm: add support for single antenna diversity")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -514,6 +514,18 @@ static int iwl_send_phy_cfg_cmd(struct i
 	struct iwl_phy_cfg_cmd phy_cfg_cmd;
 	enum iwl_ucode_type ucode_type = mvm->fwrt.cur_fw_img;
 
+	if (iwl_mvm_has_unified_ucode(mvm) &&
+	    !mvm->trans->cfg->tx_with_siso_diversity) {
+		return 0;
+	} else if (mvm->trans->cfg->tx_with_siso_diversity) {
+		/*
+		 * TODO: currently we don't set the antenna but letting the NIC
+		 * to decide which antenna to use. This should come from BIOS.
+		 */
+		phy_cfg_cmd.phy_cfg =
+			cpu_to_le32(FW_PHY_CFG_CHAIN_SAD_ENABLED);
+	}
+
 	/* Set parameters */
 	phy_cfg_cmd.phy_cfg = cpu_to_le32(iwl_mvm_get_phy_config(mvm));
 
@@ -1344,12 +1356,12 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		ret = iwl_send_phy_db_data(mvm->phy_db);
 		if (ret)
 			goto error;
-
-		ret = iwl_send_phy_cfg_cmd(mvm);
-		if (ret)
-			goto error;
 	}
 
+	ret = iwl_send_phy_cfg_cmd(mvm);
+	if (ret)
+		goto error;
+
 	ret = iwl_mvm_send_bt_init_conf(mvm);
 	if (ret)
 		goto error;


