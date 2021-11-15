Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D12F45102C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhKOSnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239165AbhKOSkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:40:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96F9D6326E;
        Mon, 15 Nov 2021 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999462;
        bh=Ql/dflhi8ZWTUG9hl1uggtLvGa5T1NtY4Iz6rNF/QYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adpDsng7RA1IONOGyz+YDbG+dt7H/CgmiNiMCaKLgoY2b+B4QvuCEFbcAkQ8iemFH
         xqmTqTIeuVRUUKBpU0TUdN1LUQtNHTIbKFe4Gc92sPoY4dPw4hfkWeGkIzLTAorGlk
         vB9O9biE3TLpRoZTUiKMV/gs2QRvFiZ6tzz8/yQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 305/849] iwlwifi: mvm: disable RX-diversity in powersave
Date:   Mon, 15 Nov 2021 17:56:28 +0100
Message-Id: <20211115165430.570812547@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e5322b9ab5f63536c41301150b7ce64605ce52cc ]

Just like we have default SMPS mode as dynamic in powersave,
we should not enable RX-diversity in powersave, to reduce
power consumption when connected to a non-MIMO AP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211017113927.fc896bc5cdaa.I1d11da71b8a5cbe921a37058d5f578f1b14a2023@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 4a3d2971a98b7..ec8a223f90e85 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -405,6 +405,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		return false;
+
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
-- 
2.33.0



