Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B03C18B76A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgCSNOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgCSNOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA2320722;
        Thu, 19 Mar 2020 13:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623649;
        bh=CEZE2M2M19p/tI/qitCnZMFSK+sh5USz35jRAEJmX4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsCSb5ZgnUmOu8sr0ef9+8w2EDUvDIFCwmgB74WKEaSc2iHQXawfek4yfLfp+IIDD
         okuaK684yex2asQB73A4WcYhbzD13LLA17m70fDp4qVUiueJhzeBERBH/zpfKEQzVR
         T0hMlZuNV4kFlh34Q77iFP8YUQxlmVDe5GK70QK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 84/90] mac80211: rx: avoid RCU list traversal under mutex
Date:   Thu, 19 Mar 2020 14:00:46 +0100
Message-Id: <20200319123954.292943173@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 253216ffb2a002a682c6f68bd3adff5b98b71de8 ]

local->sta_mtx is held in __ieee80211_check_fast_rx_iface().
No need to use list_for_each_entry_rcu() as it also requires
a cond argument to avoid false lockdep warnings when not used in
RCU read-side section (with CONFIG_PROVE_RCU_LIST).
Therefore use list_for_each_entry();

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200223143302.15390-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 74652eb2f90fd..a6f265262f151 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3841,7 +3841,7 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
 			continue;
-- 
2.20.1



