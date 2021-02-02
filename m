Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3770F30CC52
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbhBBTvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:51:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhBBNv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A4B64FC4;
        Tue,  2 Feb 2021 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273423;
        bh=zislhx4+EYrKHxWXmV+5V13+wwgBIQq1B0uOrxbqSdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqomWPdKMhgIT7hAWYrP05Y0TR+rT7ah1Wm4o+VOiwN0ZWrzEgjV4W38oTZz9D7yS
         yYpuOT/95+/MTYjv+SD0sF24Y1iQgy+kM0i8fPTt+S3fv7OrdZv5c13ghioQ1mkpmJ
         nCPS87q45TPkUxzMw7jfZF9RVi8bibhtfGnfO8s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/142] iwlwifi: pnvm: dont skip everything when not reloading
Date:   Tue,  2 Feb 2021 14:37:44 +0100
Message-Id: <20210202133001.877628603@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1c58bed4b7f7551239b9005ad0a9a6566a3d9fbe ]

Even if we don't reload the file from disk, we still need to
trigger the PNVM load flow with the device; fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6972592850c0 ("iwlwifi: read and parse PNVM file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.85ef56c4ef8c.I3b853ce041a0755d45e448035bef1837995d191b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 50 ++++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 6d8f7bff12432..ebd1a09a2fb8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -224,40 +224,40 @@ static int iwl_pnvm_parse(struct iwl_trans *trans, const u8 *data,
 int iwl_pnvm_load(struct iwl_trans *trans,
 		  struct iwl_notif_wait_data *notif_wait)
 {
-	const struct firmware *pnvm;
 	struct iwl_notification_wait pnvm_wait;
 	static const u16 ntf_cmds[] = { WIDE_ID(REGULATORY_AND_NVM_GROUP,
 						PNVM_INIT_COMPLETE_NTFY) };
-	char pnvm_name[64];
-	int ret;
 
 	/* if the SKU_ID is empty, there's nothing to do */
 	if (!trans->sku_id[0] && !trans->sku_id[1] && !trans->sku_id[2])
 		return 0;
 
-	/* if we already have it, nothing to do either */
-	if (trans->pnvm_loaded)
-		return 0;
+	/* load from disk only if we haven't done it before */
+	if (!trans->pnvm_loaded) {
+		const struct firmware *pnvm;
+		char pnvm_name[64];
+		int ret;
+
+		/*
+		 * The prefix unfortunately includes a hyphen at the end, so
+		 * don't add the dot here...
+		 */
+		snprintf(pnvm_name, sizeof(pnvm_name), "%spnvm",
+			 trans->cfg->fw_name_pre);
+
+		/* ...but replace the hyphen with the dot here. */
+		if (strlen(trans->cfg->fw_name_pre) < sizeof(pnvm_name))
+			pnvm_name[strlen(trans->cfg->fw_name_pre) - 1] = '.';
+
+		ret = firmware_request_nowarn(&pnvm, pnvm_name, trans->dev);
+		if (ret) {
+			IWL_DEBUG_FW(trans, "PNVM file %s not found %d\n",
+				     pnvm_name, ret);
+		} else {
+			iwl_pnvm_parse(trans, pnvm->data, pnvm->size);
 
-	/*
-	 * The prefix unfortunately includes a hyphen at the end, so
-	 * don't add the dot here...
-	 */
-	snprintf(pnvm_name, sizeof(pnvm_name), "%spnvm",
-		 trans->cfg->fw_name_pre);
-
-	/* ...but replace the hyphen with the dot here. */
-	if (strlen(trans->cfg->fw_name_pre) < sizeof(pnvm_name))
-		pnvm_name[strlen(trans->cfg->fw_name_pre) - 1] = '.';
-
-	ret = firmware_request_nowarn(&pnvm, pnvm_name, trans->dev);
-	if (ret) {
-		IWL_DEBUG_FW(trans, "PNVM file %s not found %d\n",
-			     pnvm_name, ret);
-	} else {
-		iwl_pnvm_parse(trans, pnvm->data, pnvm->size);
-
-		release_firmware(pnvm);
+			release_firmware(pnvm);
+		}
 	}
 
 	iwl_init_notification_wait(notif_wait, &pnvm_wait,
-- 
2.27.0



