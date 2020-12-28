Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1D2E4089
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391806AbgL1ORa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391802AbgL1OR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BD5206D4;
        Mon, 28 Dec 2020 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165033;
        bh=Yd9oCDHvXydzN29nOp7x6zy+P2ktIVDoGN93GaZerrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNzApnGRCtwGWE7WgMKGYtPffeMsT+dNY/wIE3fxMN23B0SMPKLGYj/q7ETrWx3vV
         Uob0Ph5c05IFrHkfllammf8TeKXnp4aJ7hq1kFJet38BJgY499KbbApfjp1fWajw0l
         KMeHBrf889Af2+50zoJhHC2D5bWB97/tWr/UtxrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Gabay <daniel.gabay@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/717] iwlwifi: dbg-tlv: fix old length in is_trig_data_contained()
Date:   Mon, 28 Dec 2020 13:46:25 +0100
Message-Id: <20201228125039.546474151@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 58a1c9f9a9b6b9092ae10b84f6b571a06596e296 ]

There's a bug in the lengths - the 'old length' needs to be calculated
using the 'old' pointer, of course, likely a copy/paste mistake. Fix
this.

Reported-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: cf29c5b66b9f ("iwlwifi: dbg_ini: implement time point handling")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.c0105ddffa74.I1ddb243053ff763c91b663748b6a593ecc3b5634@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 51ce93d21ffe5..8fa1c22fd96db 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -808,7 +808,7 @@ static bool is_trig_data_contained(struct iwl_ucode_tlv *new,
 	struct iwl_fw_ini_trigger_tlv *old_trig = (void *)old->data;
 	__le32 *new_data = new_trig->data, *old_data = old_trig->data;
 	u32 new_dwords_num = iwl_tlv_array_len(new, new_trig, data);
-	u32 old_dwords_num = iwl_tlv_array_len(new, new_trig, data);
+	u32 old_dwords_num = iwl_tlv_array_len(old, old_trig, data);
 	int i, j;
 
 	for (i = 0; i < new_dwords_num; i++) {
-- 
2.27.0



