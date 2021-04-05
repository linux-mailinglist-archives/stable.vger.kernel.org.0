Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C23353FF1
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhDEJPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239611AbhDEJOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD019611C1;
        Mon,  5 Apr 2021 09:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614037;
        bh=uRc8hbKucGk+nf9GdNdK5D30R6r1o5Jgunn4Ep7dOYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFMJUPPBt/eY5IsARkYk6URK9UgP3vG0vZGre28BboEHPRk18qbsNf5qETavNqZJF
         bM90bjNBgEx/WxzXhYCg5HHXXehRRtP9JjZx74woJsz/ub4rzG+vZeOFTus4ERYakv
         6GusOm6JOJjb7bVV3gjK37OsVgWhMBqfiVwFtugs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 059/152] ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()
Date:   Mon,  5 Apr 2021 10:53:28 +0200
Message-Id: <20210405085036.192987297@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 09078368d516918666a0122f2533dc73676d3d7e ]

ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
the resulting pointer is only valid under RCU lock as well.

Fix ath10k_wmi_tlv_op_pull_peer_stats_info() to hold RCU lock before it
calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
pointer is no longer needed.

This problem was found while reviewing code to debug RCU warn from
ath10k_wmi_tlv_parse_peer_stats_info().

Link: https://lore.kernel.org/linux-wireless/7230c9e5-2632-b77e-c4f9-10eca557a5bb@linuxfoundation.org/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210210212107.40373-1-skhan@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e6135795719a..e7072fc4f487 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -576,13 +576,13 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TDLS_TEARDOWN_REASON_TX:
 	case WMI_TDLS_TEARDOWN_REASON_RSSI:
 	case WMI_TDLS_TEARDOWN_REASON_PTR_TIMEOUT:
+		rcu_read_lock();
 		station = ieee80211_find_sta_by_ifaddr(ar->hw,
 						       ev->peer_macaddr.addr,
 						       NULL);
 		if (!station) {
 			ath10k_warn(ar, "did not find station from tdls peer event");
-			kfree(tb);
-			return;
+			goto exit;
 		}
 		arvif = ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
 		ieee80211_tdls_oper_request(
@@ -593,6 +593,9 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 					);
 		break;
 	}
+
+exit:
+	rcu_read_unlock();
 	kfree(tb);
 }
 
-- 
2.30.1



