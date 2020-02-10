Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CD5157966
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgBJNPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgBJMi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:26 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B7324649;
        Mon, 10 Feb 2020 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338305;
        bh=ZJ61T8RWA55/xTMH6Jw79selneBAbKSPYcz00xOnp5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxQ8culQIycv8LP2/Bfc8Aa+pv/SHTX2UjhLWajoJ3i8Q3G05SxO5dtOEAEGDfS5K
         rN3g26RNQ31o9upcF9K3j0JKIpWE1vBVs1Ah9y44Pk+BzpE44CPmp/PrEkBiFA8mXF
         VL8v+9j9k8omd1tee+XazIOQ6d6ckKX+DJDJhe8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 180/309] iwlwifi: dont throw error when trying to remove IGTK
Date:   Mon, 10 Feb 2020 04:32:16 -0800
Message-Id: <20200210122423.793964027@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 197288d5ba8a5289f22d3aeb4fca3824bfd9b4af upstream.

The IGTK keys are only removed by mac80211 after it has already
removed the AP station.  This causes the driver to throw an error
because mac80211 is trying to remove the IGTK when the station doesn't
exist anymore.

The firmware is aware that the station has been removed and can deal
with it the next time we try to add an IGTK for a station, so we
shouldn't try to remove the key if the station ID is
IWL_MVM_INVALID_STA.  Do this by removing the check for mvm_sta before
calling iwl_mvm_send_sta_igtk() and check return from that function
gracefully if the station ID is invalid.

Cc: stable@vger.kernel.org # 4.12+
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3321,6 +3321,10 @@ static int iwl_mvm_send_sta_igtk(struct
 	igtk_cmd.sta_id = cpu_to_le32(sta_id);
 
 	if (remove_key) {
+		/* This is a valid situation for IGTK */
+		if (sta_id == IWL_MVM_INVALID_STA)
+			return 0;
+
 		igtk_cmd.ctrl_flags |= cpu_to_le32(STA_KEY_NOT_VALID);
 	} else {
 		struct ieee80211_key_seq seq;
@@ -3575,9 +3579,9 @@ int iwl_mvm_remove_sta_key(struct iwl_mv
 	IWL_DEBUG_WEP(mvm, "mvm remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
 
-	if (mvm_sta && (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
-			keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
-			keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256))
+	if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
+	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
+	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256)
 		return iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id, true);
 
 	if (!__test_and_clear_bit(keyconf->hw_key_idx, mvm->fw_key_table)) {


