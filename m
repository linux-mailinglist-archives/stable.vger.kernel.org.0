Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C6A45BD44
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbhKXMg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343722AbhKXMeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:34:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EEA8611AD;
        Wed, 24 Nov 2021 12:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756469;
        bh=KjBcQ+WI1oP0C2UNHD/b64r3d+eqgFExUu/QF5FfxGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLgC78z7J8OZtLEzdM3lPLNuybNFBN0uQt3dOqYLQD5Qmnb4COWx7hzJErawSFMpo
         mrfOFHSNmLTyB40xSrabt39VjqN0nxw1l93uyFp5xzMvFnkP25F8s9xw3/TLOMgFa+
         i0K9pakBBjkpYeuvhKAyD/8xIwHvWGNcdQ16Xe+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/251] iwlwifi: mvm: disable RX-diversity in powersave
Date:   Wed, 24 Nov 2021 12:55:39 +0100
Message-Id: <20211124115713.623548155@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index d2cada0ab4264..3303fc85d76f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1029,6 +1029,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		return false;
+
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
-- 
2.33.0



