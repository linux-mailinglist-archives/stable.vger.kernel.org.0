Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EE9364429
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240649AbhDSNZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241817AbhDSNYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 763F3613AA;
        Mon, 19 Apr 2021 13:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838375;
        bh=wYqo+7IanwF0AhFOfpTbp9pDhnhpGsfNZrxKBkPwnFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrQ+hklWLAgdisqcUPKNFy1Yi2mV+URlll5VrS4ulntMvqtt5IWDRaWL4tajicpRh
         CbYxmOUd7G0Rqt3H/nxBjI/yM80Y8s/P8C61psjaP+cy/qqHFFuBxO7LFT7iI5dp6B
         /vAwC4GZX5SwfiWpGS5AjNVaYZtjRdrvBPLgcRWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seevalamuthu Mariappan <seevalam@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/73] mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN
Date:   Mon, 19 Apr 2021 15:06:29 +0200
Message-Id: <20210419130525.067524513@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seevalamuthu Mariappan <seevalam@codeaurora.org>

[ Upstream commit dd0b45538146cb6a54d6da7663b8c3afd16ebcfd ]

In some race conditions, with more clients and traffic configuration,
below crash is seen when making the interface down. sta->fast_rx wasn't
cleared when STA gets removed from 4-addr AP_VLAN interface. The crash is
due to try accessing 4-addr AP_VLAN interface's net_device (fast_rx->dev)
which has been deleted already.

Resolve this by clearing sta->fast_rx pointer when STA removes
from a 4-addr VLAN.

[  239.449529] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[  239.449531] pgd = 80204000
...
[  239.481496] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.4.60 #227
[  239.481591] Hardware name: Generic DT based system
[  239.487665] task: be05b700 ti: be08e000 task.ti: be08e000
[  239.492360] PC is at get_rps_cpu+0x2d4/0x31c
[  239.497823] LR is at 0xbe08fc54
...
[  239.778574] [<80739740>] (get_rps_cpu) from [<8073cb10>] (netif_receive_skb_internal+0x8c/0xac)
[  239.786722] [<8073cb10>] (netif_receive_skb_internal) from [<8073d578>] (napi_gro_receive+0x48/0xc4)
[  239.795267] [<8073d578>] (napi_gro_receive) from [<c7b83e8c>] (ieee80211_mark_rx_ba_filtered_frames+0xbcc/0x12d4 [mac80211])
[  239.804776] [<c7b83e8c>] (ieee80211_mark_rx_ba_filtered_frames [mac80211]) from [<c7b84d4c>] (ieee80211_rx_napi+0x7b8/0x8c8 [mac8
            0211])
[  239.815857] [<c7b84d4c>] (ieee80211_rx_napi [mac80211]) from [<c7f63d7c>] (ath11k_dp_process_rx+0x7bc/0x8c8 [ath11k])
[  239.827757] [<c7f63d7c>] (ath11k_dp_process_rx [ath11k]) from [<c7f5b6c4>] (ath11k_dp_service_srng+0x2c0/0x2e0 [ath11k])
[  239.838484] [<c7f5b6c4>] (ath11k_dp_service_srng [ath11k]) from [<7f55b7dc>] (ath11k_ahb_ext_grp_napi_poll+0x20/0x84 [ath11k_ahb]
            )
[  239.849419] [<7f55b7dc>] (ath11k_ahb_ext_grp_napi_poll [ath11k_ahb]) from [<8073ce1c>] (net_rx_action+0xe0/0x28c)
[  239.860945] [<8073ce1c>] (net_rx_action) from [<80324868>] (__do_softirq+0xe4/0x228)
[  239.871269] [<80324868>] (__do_softirq) from [<80324c48>] (irq_exit+0x98/0x108)
[  239.879080] [<80324c48>] (irq_exit) from [<8035c59c>] (__handle_domain_irq+0x90/0xb4)
[  239.886114] [<8035c59c>] (__handle_domain_irq) from [<8030137c>] (gic_handle_irq+0x50/0x94)
[  239.894100] [<8030137c>] (gic_handle_irq) from [<803024c0>] (__irq_svc+0x40/0x74)

Signed-off-by: Seevalamuthu Mariappan <seevalam@codeaurora.org>
Link: https://lore.kernel.org/r/1616163532-3881-1-git-send-email-seevalam@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 677928bf13d1..1b50bbf030ed 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1670,8 +1670,10 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		}
 
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-		    sta->sdata->u.vlan.sta)
+		    sta->sdata->u.vlan.sta) {
+			ieee80211_clear_fast_rx(sta);
 			RCU_INIT_POINTER(sta->sdata->u.vlan.sta, NULL);
+		}
 
 		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 			ieee80211_vif_dec_num_mcast(sta->sdata);
-- 
2.30.2



