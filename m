Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731062D9FF5
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502651AbgLNTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408591AbgLNRhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:11 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 033/105] iwlwifi: pcie: invert values of NO_160 device config entries
Date:   Mon, 14 Dec 2020 18:28:07 +0100
Message-Id: <20201214172556.876619579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 568d3434178b00274615190a19d29c3d235b4e6d ]

The NO_160 flag specifies if the device doesn't have 160 MHz support,
but we errorneously assumed the opposite.  If the flag was set, we
were considering that 160 MHz was supported, but it's actually the
opposite.  Fix it by inverting the bits, i.e. NO_160 is 0x1 and 160
is 0x0.

Fixes: d6f2134a3831 ("iwlwifi: add mac/rf types and 160MHz to the device tables")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201202143859.375bec857ccb.I83884286b688965293e9810381808039bd7eedae@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index e27c13263a232..44abe44c04632 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -488,8 +488,8 @@ struct iwl_cfg {
 #define IWL_CFG_RF_ID_HR		0x7
 #define IWL_CFG_RF_ID_HR1		0x4
 
-#define IWL_CFG_NO_160			0x0
-#define IWL_CFG_160			0x1
+#define IWL_CFG_NO_160			0x1
+#define IWL_CFG_160			0x0
 
 #define IWL_CFG_CORES_BT		0x0
 #define IWL_CFG_CORES_BT_GNSS		0x5
-- 
2.27.0



