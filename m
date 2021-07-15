Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFCF3CAA8A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbhGOTNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241108AbhGOTMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4061613D7;
        Thu, 15 Jul 2021 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376136;
        bh=1h/US809T4PNXkRghgU+cb23Xj2bAUs7vWSKKlNecV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byw6F/v8E5/LOc1S7R5tk+4iGpJMWa4HU8K4oLmaxTXPNE7zSVpjhLhbW8LdqbkZZ
         Bs+qJ2PzNe0P0cP4H/suhdFw/vEqgh9Yvrk0/9QnjPusC0/K9a98xIPGTop0Hn2Guh
         xjVIzSMn03sP+7npIbbNdE0/MqyG+9Zb7HSFLU2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 142/266] iwlwifi: pcie: fix context info freeing
Date:   Thu, 15 Jul 2021 20:38:17 +0200
Message-Id: <20210715182638.731993878@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 26d18c75a7496c4c52b0b6789e713dc76ebfbc87 ]

After firmware alive, iwl_trans_pcie_gen2_fw_alive() is called
to free the context info. However, on gen3 that will then free
the context info with the wrong size.

Since we free this allocation later, let it stick around until
the device is stopped for now, freeing some of it earlier is a
separate change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618105614.afb63fb8cbc1.If4968db8e09f4ce2a1d27a6d750bca3d132d7d70@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 1bcd36e9e008..9ce195d80c51 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -254,7 +254,8 @@ void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 	/* now that we got alive we can free the fw image & the context info.
 	 * paging memory cannot be freed included since FW will still use it
 	 */
-	iwl_pcie_ctxt_info_free(trans);
+	if (trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
+		iwl_pcie_ctxt_info_free(trans);
 
 	/*
 	 * Re-enable all the interrupts, including the RF-Kill one, now that
-- 
2.30.2



