Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860B42C9C7F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390154AbgLAJSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389774AbgLAJK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D709206D8;
        Tue,  1 Dec 2020 09:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813837;
        bh=qghq13KvTOh0afFsIvTkfHTqpHf7qdhPm7cLdM87/Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCM11GrO0iCAnZhiTy7GYwWjmpNfJpl6uu7PrgCa70ZGe95d5KmIzt5/1H1gcwSXx
         UmolnyC+hDPk+Tdz3jE7JiKNSXAX6AuNMXcOKJ2cUMd9SFlsfQr1yPFXCJgQY+2Imt
         YjgilSOXwgcz1mQ4SKwb+XZhtOh2f4vSNhGK9/vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 075/152] iwlwifi: mvm: write queue_sync_state only for sync
Date:   Tue,  1 Dec 2020 09:53:10 +0100
Message-Id: <20201201084721.737291596@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 97cc16943f23078535fdbce4f6391b948b4ccc08 ]

We use mvm->queue_sync_state to wait for synchronous queue sync
messages, but if an async one happens inbetween we shouldn't
clear mvm->queue_sync_state after sending the async one, that
can run concurrently (at least from the CPU POV) with another
synchronous queue sync.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201107104557.51a3148f2c14.I0772171dbaec87433a11513e9586d98b5d920b5f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c918c0887ed01..34362dc0d4612 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3104,6 +3104,9 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 			goto out_unlock;
 		}
 
+		if (vif->type == NL80211_IFTYPE_STATION)
+			vif->bss_conf.he_support = sta->he_cap.has_he;
+
 		if (sta->tdls &&
 		    (vif->p2p ||
 		     iwl_mvm_tdls_sta_count(mvm, NULL) ==
-- 
2.27.0



