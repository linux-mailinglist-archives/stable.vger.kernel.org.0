Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5233A382F22
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhEQONn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhEQOLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3A5613CD;
        Mon, 17 May 2021 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260474;
        bh=9yRxJ3VaWxPObwoymsEDUnFiROCK5q5GXBmdx7K/05M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1MtkEiX3nVxVLXWws4TBZQSVmnbM+IL3CcljFjMevHasqgGMPL9RN4nOMQb9SB2T
         1g/4BH1tStEm2WsE8GnvTywKxfaD39FuhzSohmR68Rq4sVdUFzA9n6DA+TGzWwtmT1
         5pIQdYKFYh0A2hr9FRqVUrF7qg43HD0EQkyc2buA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 096/363] mac80211: properly drop the connection in case of invalid CSA IE
Date:   Mon, 17 May 2021 15:59:22 +0200
Message-Id: <20210517140305.842966055@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 253907ab8bc0818639af382f6398810fa1f022b3 ]

In case the frequency is invalid, ieee80211_parse_ch_switch_ie
will fail and we may not even reach the check in
ieee80211_sta_process_chanswitch. Drop the connection
in case ieee80211_parse_ch_switch_ie failed, but still
take into account the CSA mode to remember not to send
a deauth frame in case if it is forbidden to.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210409123755.34712ef96a0a.I75d7ad7f1d654e8b0aa01cd7189ff00a510512b3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4a8f1b8ce768..0fe91dc9817e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1405,11 +1405,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		ch_switch.delay = csa_ie.max_switch_time;
 	}
 
-	if (res < 0) {
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		return;
-	}
+	if (res < 0)
+		goto lock_and_drop_connection;
 
 	if (beacon && sdata->vif.csa_active && !ifmgd->csa_waiting_bcn) {
 		if (res)
-- 
2.30.2



