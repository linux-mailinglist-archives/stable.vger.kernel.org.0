Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F262E3B71
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406277AbgL1NuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406271AbgL1NuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4036C2072C;
        Mon, 28 Dec 2020 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163361;
        bh=BF+6ngjyPcB3uVAVQ+yjQ1Cd7mL3NavrHj1pEmuLVS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtK1f87da37eHJX0WmGwt0bh+Uj0qmg9UWqqgU/uO782HAzZiJUeuII/yW/gWSOMa
         QRXSP6q2zfnfId8Z+eeKw/xp4R3MT17KPIZYDfN8ZNp7D2AbDGO7vhFpSqaxDZX5Dp
         iQw5MOxwY0xhF6S5nodwACamUcrFpkMJiG5e+OH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 259/453] iwlwifi: mvm: hook up missing RX handlers
Date:   Mon, 28 Dec 2020 13:48:15 +0100
Message-Id: <20201228124949.691347087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8a59d39033c35bb484f6bd91891db86ebe07fdc2 ]

The RX handlers for probe response data and channel switch weren't
hooked up properly, fix that.

Fixes: 86e177d80ff7 ("iwlwifi: mvm: add NOA and CSA to a probe response")
Fixes: d3a108a48dc6 ("iwlwifi: mvm: Support CSA countdown offloading")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.2d07dcee0d35.I07a61b5d734478db57d9434ff303e4c90bf6c32b@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3acbd5b7ab4b2..b04cc6214bac8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -316,6 +316,12 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		       iwl_mvm_mu_mimo_grp_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(DATA_PATH_GROUP, STA_PM_NOTIF,
 		       iwl_mvm_sta_pm_notif, RX_HANDLER_SYNC),
+	RX_HANDLER_GRP(MAC_CONF_GROUP, PROBE_RESPONSE_DATA_NOTIF,
+		       iwl_mvm_probe_resp_data_notif,
+		       RX_HANDLER_ASYNC_LOCKED),
+	RX_HANDLER_GRP(MAC_CONF_GROUP, CHANNEL_SWITCH_NOA_NOTIF,
+		       iwl_mvm_channel_switch_noa_notif,
+		       RX_HANDLER_SYNC),
 };
 #undef RX_HANDLER
 #undef RX_HANDLER_GRP
-- 
2.27.0



