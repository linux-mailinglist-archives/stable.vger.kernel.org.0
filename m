Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF9D137EE9
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgAKKPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbgAKKPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:15:02 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A0682082E;
        Sat, 11 Jan 2020 10:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737701;
        bh=onSEEpP7BW8fkuP5VBJXjlJWYi+LHwQqtVjEOCKfnuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wFK02WWB5Saxt4RynOSW/NqEQxY5S8/3YNJtOKOR42sF8OIGvfg8Si386YONz+h1
         ZtzspNCrkkKEtbNxbyfka1t9muKQSWUQbFYv0xwQbJoJ3JQ51fUsh5b+1vEQWjOL8m
         VdyLn9b0/FJQ9X4n9wJD+J3AAof1pKEI4pg1GTf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, qize wang <wangqize888888888@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/84] mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()
Date:   Sat, 11 Jan 2020 10:49:45 +0100
Message-Id: <20200111094847.289332898@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: qize wang <wangqize888888888@gmail.com>

[ Upstream commit 1e58252e334dc3f3756f424a157d1b7484464c40 ]

mwifiex_process_tdls_action_frame() without checking
the incoming tdls infomation element's vality before use it,
this may cause multi heap buffer overflows.

Fix them by putting vality check before use it.

IE is TLV struct, but ht_cap and  ht_oper aren’t TLV struct.
the origin marvell driver code is wrong:

memcpy(&sta_ptr->tdls_cap.ht_oper, pos,....
memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,...

Fix the bug by changing pos(the address of IE) to
pos+2 ( the address of IE value ).

Signed-off-by: qize wang <wangqize888888888@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 70 +++++++++++++++++++--
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 27779d7317fd..6058c48d56dc 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -956,59 +956,117 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 
 		switch (*pos) {
 		case WLAN_EID_SUPP_RATES:
+			if (pos[1] > 32)
+				return;
 			sta_ptr->tdls_cap.rates_len = pos[1];
 			for (i = 0; i < pos[1]; i++)
 				sta_ptr->tdls_cap.rates[i] = pos[i + 2];
 			break;
 
 		case WLAN_EID_EXT_SUPP_RATES:
+			if (pos[1] > 32)
+				return;
 			basic = sta_ptr->tdls_cap.rates_len;
+			if (pos[1] > 32 - basic)
+				return;
 			for (i = 0; i < pos[1]; i++)
 				sta_ptr->tdls_cap.rates[basic + i] = pos[i + 2];
 			sta_ptr->tdls_cap.rates_len += pos[1];
 			break;
 		case WLAN_EID_HT_CAPABILITY:
-			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,
+			if (pos > end - sizeof(struct ieee80211_ht_cap) - 2)
+				return;
+			if (pos[1] != sizeof(struct ieee80211_ht_cap))
+				return;
+			/* copy the ie's value into ht_capb*/
+			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos + 2,
 			       sizeof(struct ieee80211_ht_cap));
 			sta_ptr->is_11n_enabled = 1;
 			break;
 		case WLAN_EID_HT_OPERATION:
-			memcpy(&sta_ptr->tdls_cap.ht_oper, pos,
+			if (pos > end -
+			    sizeof(struct ieee80211_ht_operation) - 2)
+				return;
+			if (pos[1] != sizeof(struct ieee80211_ht_operation))
+				return;
+			/* copy the ie's value into ht_oper*/
+			memcpy(&sta_ptr->tdls_cap.ht_oper, pos + 2,
 			       sizeof(struct ieee80211_ht_operation));
 			break;
 		case WLAN_EID_BSS_COEX_2040:
+			if (pos > end - 3)
+				return;
+			if (pos[1] != 1)
+				return;
 			sta_ptr->tdls_cap.coex_2040 = pos[2];
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
+			if (pos > end - sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] < sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] > 8)
+				return;
 			memcpy((u8 *)&sta_ptr->tdls_cap.extcap, pos,
 			       sizeof(struct ieee_types_header) +
 			       min_t(u8, pos[1], 8));
 			break;
 		case WLAN_EID_RSN:
+			if (pos > end - sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] < sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] > IEEE_MAX_IE_SIZE -
+			    sizeof(struct ieee_types_header))
+				return;
 			memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
 			       sizeof(struct ieee_types_header) +
 			       min_t(u8, pos[1], IEEE_MAX_IE_SIZE -
 				     sizeof(struct ieee_types_header)));
 			break;
 		case WLAN_EID_QOS_CAPA:
+			if (pos > end - 3)
+				return;
+			if (pos[1] != 1)
+				return;
 			sta_ptr->tdls_cap.qos_info = pos[2];
 			break;
 		case WLAN_EID_VHT_OPERATION:
-			if (priv->adapter->is_hw_11ac_capable)
-				memcpy(&sta_ptr->tdls_cap.vhtoper, pos,
+			if (priv->adapter->is_hw_11ac_capable) {
+				if (pos > end -
+				    sizeof(struct ieee80211_vht_operation) - 2)
+					return;
+				if (pos[1] !=
+				    sizeof(struct ieee80211_vht_operation))
+					return;
+				/* copy the ie's value into vhtoper*/
+				memcpy(&sta_ptr->tdls_cap.vhtoper, pos + 2,
 				       sizeof(struct ieee80211_vht_operation));
+			}
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
 			if (priv->adapter->is_hw_11ac_capable) {
-				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos,
+				if (pos > end -
+				    sizeof(struct ieee80211_vht_cap) - 2)
+					return;
+				if (pos[1] != sizeof(struct ieee80211_vht_cap))
+					return;
+				/* copy the ie's value into vhtcap*/
+				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos + 2,
 				       sizeof(struct ieee80211_vht_cap));
 				sta_ptr->is_11ac_enabled = 1;
 			}
 			break;
 		case WLAN_EID_AID:
-			if (priv->adapter->is_hw_11ac_capable)
+			if (priv->adapter->is_hw_11ac_capable) {
+				if (pos > end - 4)
+					return;
+				if (pos[1] != 2)
+					return;
 				sta_ptr->tdls_cap.aid =
 					get_unaligned_le16((pos + 2));
+			}
+			break;
 		default:
 			break;
 		}
-- 
2.20.1



