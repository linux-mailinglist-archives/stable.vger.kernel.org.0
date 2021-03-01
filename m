Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25ABB328BC9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbhCASiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239988AbhCASc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:32:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E28764FB9;
        Mon,  1 Mar 2021 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620271;
        bh=4wRPwsUlT/s9ycdah4bgy1bsx46L0w7vrdQCblOavH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRgwBseBch0ljjFWSDAchJg9cJP5/6IcJvnljlgffkjZ4ZMqzXxPCBrbxz8Zydldj
         wwwyLFjmEOOCU6NalRqjrTydsw1vG2vmcPsHVj9ZJv7r+dt7GTxeSk+sfbWoSDIHym
         3rVx64a8FwR89KcecDYVD+nBi35t6zg9FLnLpuMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 092/775] iwlwifi: mvm: assign SAR table revision to the command later
Date:   Mon,  1 Mar 2021 17:04:20 +0100
Message-Id: <20210301161206.222879496@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 28db1862067cb09ebfdccfbc129a52c6fdb4c4d7 ]

The call to iwl_sar_geo_init() was moved to the end of the
iwl_mvm_sar_geo_init() function, after the table revision is assigned
to the FW command.  But the revision is only known after
iwl_sar_geo_init() is called, so we were always assigning zero to it.

Fix that by moving the assignment code after the iwl_sar_geo_init()
function is called.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 45acebf8d6a6 ("iwlwifi: fix sar geo table initialization")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210135352.cef55ef3a065.If96c60f08d24c2262c287168a6f0dbd7cf0f8f5c@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 045765fa67bea..4c5609cdcbdee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -859,12 +859,10 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	if (cmd_ver == 3) {
 		len = sizeof(cmd.v3);
 		n_bands = ARRAY_SIZE(cmd.v3.table[0]);
-		cmd.v3.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
 	} else if (fw_has_api(&mvm->fwrt.fw->ucode_capa,
 			      IWL_UCODE_TLV_API_SAR_TABLE_VER)) {
 		len = sizeof(cmd.v2);
 		n_bands = ARRAY_SIZE(cmd.v2.table[0]);
-		cmd.v2.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
 	} else {
 		len = sizeof(cmd.v1);
 		n_bands = ARRAY_SIZE(cmd.v1.table[0]);
@@ -884,6 +882,16 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	if (ret)
 		return 0;
 
+	/*
+	 * Set the revision on versions that contain it.
+	 * This must be done after calling iwl_sar_geo_init().
+	 */
+	if (cmd_ver == 3)
+		cmd.v3.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
+	else if (fw_has_api(&mvm->fwrt.fw->ucode_capa,
+			    IWL_UCODE_TLV_API_SAR_TABLE_VER))
+		cmd.v2.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
+
 	return iwl_mvm_send_cmd_pdu(mvm,
 				    WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT),
 				    0, len, &cmd);
-- 
2.27.0



