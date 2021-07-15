Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191FB3CA92D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbhGOTFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243516AbhGOTE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74353613E6;
        Thu, 15 Jul 2021 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375617;
        bh=I3lYcrAzjWWwNNTQYpDEKai+YMoJnJOzHKEKOlEwnFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfXYe8bbeiivdsgW6x8KU6CwmXHQrI1AWq+o1SZEIgwIuIdpDXDvCC0tEQFaxATRr
         PxZSZ24AnFDTtiTk/FVfr4jgDFpH8WZCedGf8ktjL7fipFrMTcs4sYf6tnq1kvG94t
         tBGqsNQkDfTU8R376xi8EkJ1bEnoqz7R/jLgjEyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 120/242] iwlwifi: pcie: fix context info freeing
Date:   Thu, 15 Jul 2021 20:38:02 +0200
Message-Id: <20210715182614.210988158@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
index af9412bd697e..7996b05a51c2 100644
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



