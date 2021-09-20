Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AE7412632
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354842AbhITS4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385434AbhITSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6119763384;
        Mon, 20 Sep 2021 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159278;
        bh=eP7jEqB4S3rVHetyAJFcQ8BNFU7NTT24eYg6fwPEhcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5KF2gKFRDId4RCnApyhu5yLb2w9Xxg9/XNboFS20HNZZ+91RMYMvjQ+TNCm8gw3r
         j4fxjBUY7cr5RpdU2QwVb9wwIDtnvIr4hidK443fxq63gXFbky0iI963kRYzjH5owO
         tWXvjIyj/mgfPaePb0QrBnjzuQgSwViiP20X6SeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dror Moshe <drorx.moshe@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 158/168] iwlwifi: move get pnvm file name to a separate function
Date:   Mon, 20 Sep 2021 18:44:56 +0200
Message-Id: <20210920163926.861763258@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dror Moshe <drorx.moshe@intel.com>

[ Upstream commit b05c1d14a177eaffe3aa7fa18b39df3a3e1f3a47 ]

Move code that generates the pnvm file name to a separate function,
so that it can be reused.

Signed-off-by: Dror Moshe <drorx.moshe@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210826224715.7d2dd18c75a2.I3652584755b9ab44909ddcd09ff4d80c6690a1ad@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 13 ++-----------
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index b4b1f75b9c2a..830257e94126 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -230,19 +230,10 @@ static int iwl_pnvm_parse(struct iwl_trans *trans, const u8 *data,
 static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 {
 	const struct firmware *pnvm;
-	char pnvm_name[64];
+	char pnvm_name[MAX_PNVM_NAME];
 	int ret;
 
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
+	iwl_pnvm_get_fs_name(trans, pnvm_name, sizeof(pnvm_name));
 
 	ret = firmware_request_nowarn(&pnvm, pnvm_name, trans->dev);
 	if (ret) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
index 61d3d4e0b7d9..203c367dd4de 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
@@ -12,7 +12,27 @@
 
 #define MVM_UCODE_PNVM_TIMEOUT	(HZ / 4)
 
+#define MAX_PNVM_NAME  64
+
 int iwl_pnvm_load(struct iwl_trans *trans,
 		  struct iwl_notif_wait_data *notif_wait);
 
+static inline
+void iwl_pnvm_get_fs_name(struct iwl_trans *trans,
+			  u8 *pnvm_name, size_t max_len)
+{
+	int pre_len;
+
+	/*
+	 * The prefix unfortunately includes a hyphen at the end, so
+	 * don't add the dot here...
+	 */
+	snprintf(pnvm_name, max_len, "%spnvm", trans->cfg->fw_name_pre);
+
+	/* ...but replace the hyphen with the dot here. */
+	pre_len = strlen(trans->cfg->fw_name_pre);
+	if (pre_len < max_len && pre_len > 0)
+		pnvm_name[pre_len - 1] = '.';
+}
+
 #endif /* __IWL_PNVM_H__ */
-- 
2.30.2



