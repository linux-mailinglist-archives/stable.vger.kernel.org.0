Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0541227F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhITSP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345069AbhITSMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE1663281;
        Mon, 20 Sep 2021 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158453;
        bh=XxpWqRYLel/LG59Qm3NLQDHNtbTcwgshYBLulKw/lvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6AveQDhdj8aNSs6h2DH+c4H2VaHMXyC0goDpN29pSxndCl5oT3mTo1T6wOKDRa/D
         pkSqjyi2LEaKVvuPftJ9hTS59JsP4XdXb/dB08kJ3J0Szv1s+Dc+U2cPv8AjdaTres
         Y838C7N47JBPn2FU7jgD67MEnrI9C+ebRvpXUIW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/260] iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed
Date:   Mon, 20 Sep 2021 18:43:02 +0200
Message-Id: <20210920163936.665109351@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 0f5d44ac6e55551798dd3da0ff847c8df5990822 ]

If beacon_inject_active is true, we will return without freeing
beacon.  Fid that by freeing it before returning.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
[reworded the commit message]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802172232.d16206ca60fc.I9984a9b442c84814c307cee3213044e24d26f38a@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 9c417dd06291..7736621dca65 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1043,8 +1043,10 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 		return -ENOMEM;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->beacon_inject_active)
+	if (mvm->beacon_inject_active) {
+		dev_kfree_skb(beacon);
 		return -EBUSY;
+	}
 #endif
 
 	ret = iwl_mvm_mac_ctxt_send_beacon(mvm, vif, beacon);
-- 
2.30.2



