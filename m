Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F108E8DB11
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfHNRI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfHNRI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB392084D;
        Wed, 14 Aug 2019 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802505;
        bh=1oYxQGPaHNjVLDTcSpfGfO2FZLfD0ONYzzODml0ub1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xos01wi/3bNgeELrYDG03swLn3wGH8zL8biyirXHRvwjUIvOIis7riyGHrWqkv9Ab
         iEovgZZ+4pbkJwqWQJCOESe/Oodph2pC5C1vJlcS8rFEvuucex5RirfRSPqmxqlgsw
         4i7RPu3U4Lbuz38WfQUqFiZiF6MhgXIx7jSh6KFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.2 143/144] iwlwifi: mvm: dont send GEO_TX_POWER_LIMIT on version < 41
Date:   Wed, 14 Aug 2019 19:01:39 +0200
Message-Id: <20190814165805.951560164@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 39bd984c203e86f3109b49c2a2e20677c4d3ab65 upstream.

Firmware versions before 41 don't support the GEO_TX_POWER_LIMIT
command, and sending it to the firmware will cause a firmware crash.
We allow this via debugfs, so we need to return an error value in case
it's not supported.

This had already been fixed during init, when we send the command if
the ACPI WGDS table is present.  Fix it also for the other,
userspace-triggered case.

Cc: stable@vger.kernel.org
Fixes: 7fe90e0e3d60 ("iwlwifi: mvm: refactor geo init")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -874,6 +874,17 @@ int iwl_mvm_sar_select_profile(struct iw
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
+static bool iwl_mvm_sar_geo_support(struct iwl_mvm *mvm)
+{
+	/*
+	 * The GEO_TX_POWER_LIMIT command is not supported on earlier
+	 * firmware versions.  Unfortunately, we don't have a TLV API
+	 * flag to rely on, so rely on the major version which is in
+	 * the first byte of ucode_ver.
+	 */
+	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 41;
+}
+
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 {
 	struct iwl_geo_tx_power_profiles_resp *resp;
@@ -889,6 +900,9 @@ int iwl_mvm_get_sar_geo_profile(struct i
 		.data = { &geo_cmd },
 	};
 
+	if (!iwl_mvm_sar_geo_support(mvm))
+		return -EOPNOTSUPP;
+
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to get geographic profile info %d\n", ret);
@@ -914,13 +928,7 @@ static int iwl_mvm_sar_geo_init(struct i
 	int ret, i, j;
 	u16 cmd_wide_id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT);
 
-	/*
-	 * This command is not supported on earlier firmware versions.
-	 * Unfortunately, we don't have a TLV API flag to rely on, so
-	 * rely on the major version which is in the first byte of
-	 * ucode_ver.
-	 */
-	if (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) < 41)
+	if (!iwl_mvm_sar_geo_support(mvm))
 		return 0;
 
 	ret = iwl_mvm_sar_get_wgds_table(mvm);


