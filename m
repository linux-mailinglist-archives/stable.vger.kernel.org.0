Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AA630C04F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhBBNyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:54:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232949AbhBBNv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D77D64FBF;
        Tue,  2 Feb 2021 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273426;
        bh=65Oxn+TK77kWp5d9IRfWlbAgeM8/C+8gIiye31YIMkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyYi2aRTKF+DwBgz2ipZSg8eZhfavbEd6bzEozYw0Xs2ctsZEVAOSnYMbXS045Kwu
         H+nOYdGUBi0Jxa1rLjrowKA1xnjt0snn1Fc1JLdlV8+Nq/N9FsoS4xg/Gze/Y4PT6K
         06i7eem8dAIftSzW64N282DGqGZqTHJ5CaWlgueU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/142] iwlwifi: pnvm: dont try to load after failures
Date:   Tue,  2 Feb 2021 14:37:45 +0100
Message-Id: <20210202133001.917363071@linuxfoundation.org>
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

[ Upstream commit 82a08d0cd7b503be426fb856a0fb73c9c976aae1 ]

If loading the PNVM file failed on the first try during the
interface up, the file is unlikely to show up later, and we
already don't try to reload it if it changes, so just don't
try loading it again and again.

This also fixes some issues where we may try to load it at
resume time, which may not be possible yet.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6972592850c0 ("iwlwifi: read and parse PNVM file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.5ac6828a0bbe.I7d308358b21d3c0c84b1086999dbc7267f86e219@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index ebd1a09a2fb8a..895a907acdf0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -232,7 +232,7 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 	if (!trans->sku_id[0] && !trans->sku_id[1] && !trans->sku_id[2])
 		return 0;
 
-	/* load from disk only if we haven't done it before */
+	/* load from disk only if we haven't done it (or tried) before */
 	if (!trans->pnvm_loaded) {
 		const struct firmware *pnvm;
 		char pnvm_name[64];
@@ -253,6 +253,12 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 		if (ret) {
 			IWL_DEBUG_FW(trans, "PNVM file %s not found %d\n",
 				     pnvm_name, ret);
+			/*
+			 * Pretend we've loaded it - at least we've tried and
+			 * couldn't load it at all, so there's no point in
+			 * trying again over and over.
+			 */
+			trans->pnvm_loaded = true;
 		} else {
 			iwl_pnvm_parse(trans, pnvm->data, pnvm->size);
 
-- 
2.27.0



