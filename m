Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EB1178151
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388062AbgCCSBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388061AbgCCSBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97F562072D;
        Tue,  3 Mar 2020 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258507;
        bh=5PflVNOkjPhX3qBeN55v0PuwSLeglHMNIfkR30eBlKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR6DjVXjjhHvdrLHa+vD/lcBglNpIpNZxCo+8klm6hQ4G/GyXBFThu2DwKBOTjnzE
         2IwynqJ8e2XZJ4NxpCgSzy6Weh28mt2H7WIoXb9o8kZwyjif9DnGcDmVvwPJmu/Q7g
         wt7eIzS1rb5a2aUUzC9Ke0DT//P4+4oZ1k+EpjMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 68/87] mwifiex: drop most magic numbers from mwifiex_process_tdls_action_frame()
Date:   Tue,  3 Mar 2020 18:43:59 +0100
Message-Id: <20200303174356.410882389@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 70e5b8f445fd27fde0c5583460e82539a7242424 upstream.

Before commit 1e58252e334d ("mwifiex: Fix heap overflow in
mmwifiex_process_tdls_action_frame()"),
mwifiex_process_tdls_action_frame() already had too many magic numbers.
But this commit just added a ton more, in the name of checking for
buffer overflows. That seems like a really bad idea.

Let's make these magic numbers a little less magic, by
(a) factoring out 'pos[1]' as 'ie_len'
(b) using 'sizeof' on the appropriate source or destination fields where
    possible, instead of bare numbers
(c) dropping redundant checks, per below.

Regarding redundant checks: the beginning of the loop has this:

                if (pos + 2 + pos[1] > end)
                        break;

but then individual 'case's include stuff like this:

 			if (pos > end - 3)
 				return;
 			if (pos[1] != 1)
				return;

Note that the second 'return' (validating the length, pos[1]) combined
with the above condition (ensuring 'pos + 2 + length' doesn't exceed
'end'), makes the first 'return' (whose 'if' can be reworded as 'pos >
end - pos[1] - 2') redundant. Rather than unwind the magic numbers
there, just drop those conditions.

Fixes: 1e58252e334d ("mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/tdls.c |   75 ++++++++++------------------
 1 file changed, 28 insertions(+), 47 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -897,7 +897,7 @@ void mwifiex_process_tdls_action_frame(s
 	u8 *peer, *pos, *end;
 	u8 i, action, basic;
 	u16 cap = 0;
-	int ie_len = 0;
+	int ies_len = 0;
 
 	if (len < (sizeof(struct ethhdr) + 3))
 		return;
@@ -919,7 +919,7 @@ void mwifiex_process_tdls_action_frame(s
 		pos = buf + sizeof(struct ethhdr) + 4;
 		/* payload 1+ category 1 + action 1 + dialog 1 */
 		cap = get_unaligned_le16(pos);
-		ie_len = len - sizeof(struct ethhdr) - TDLS_REQ_FIX_LEN;
+		ies_len = len - sizeof(struct ethhdr) - TDLS_REQ_FIX_LEN;
 		pos += 2;
 		break;
 
@@ -929,7 +929,7 @@ void mwifiex_process_tdls_action_frame(s
 		/* payload 1+ category 1 + action 1 + dialog 1 + status code 2*/
 		pos = buf + sizeof(struct ethhdr) + 6;
 		cap = get_unaligned_le16(pos);
-		ie_len = len - sizeof(struct ethhdr) - TDLS_RESP_FIX_LEN;
+		ies_len = len - sizeof(struct ethhdr) - TDLS_RESP_FIX_LEN;
 		pos += 2;
 		break;
 
@@ -937,7 +937,7 @@ void mwifiex_process_tdls_action_frame(s
 		if (len < (sizeof(struct ethhdr) + TDLS_CONFIRM_FIX_LEN))
 			return;
 		pos = buf + sizeof(struct ethhdr) + TDLS_CONFIRM_FIX_LEN;
-		ie_len = len - sizeof(struct ethhdr) - TDLS_CONFIRM_FIX_LEN;
+		ies_len = len - sizeof(struct ethhdr) - TDLS_CONFIRM_FIX_LEN;
 		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS frame type.\n");
@@ -950,33 +950,33 @@ void mwifiex_process_tdls_action_frame(s
 
 	sta_ptr->tdls_cap.capab = cpu_to_le16(cap);
 
-	for (end = pos + ie_len; pos + 1 < end; pos += 2 + pos[1]) {
-		if (pos + 2 + pos[1] > end)
+	for (end = pos + ies_len; pos + 1 < end; pos += 2 + pos[1]) {
+		u8 ie_len = pos[1];
+
+		if (pos + 2 + ie_len > end)
 			break;
 
 		switch (*pos) {
 		case WLAN_EID_SUPP_RATES:
-			if (pos[1] > 32)
+			if (ie_len > sizeof(sta_ptr->tdls_cap.rates))
 				return;
-			sta_ptr->tdls_cap.rates_len = pos[1];
-			for (i = 0; i < pos[1]; i++)
+			sta_ptr->tdls_cap.rates_len = ie_len;
+			for (i = 0; i < ie_len; i++)
 				sta_ptr->tdls_cap.rates[i] = pos[i + 2];
 			break;
 
 		case WLAN_EID_EXT_SUPP_RATES:
-			if (pos[1] > 32)
+			if (ie_len > sizeof(sta_ptr->tdls_cap.rates))
 				return;
 			basic = sta_ptr->tdls_cap.rates_len;
-			if (pos[1] > 32 - basic)
+			if (ie_len > sizeof(sta_ptr->tdls_cap.rates) - basic)
 				return;
-			for (i = 0; i < pos[1]; i++)
+			for (i = 0; i < ie_len; i++)
 				sta_ptr->tdls_cap.rates[basic + i] = pos[i + 2];
-			sta_ptr->tdls_cap.rates_len += pos[1];
+			sta_ptr->tdls_cap.rates_len += ie_len;
 			break;
 		case WLAN_EID_HT_CAPABILITY:
-			if (pos > end - sizeof(struct ieee80211_ht_cap) - 2)
-				return;
-			if (pos[1] != sizeof(struct ieee80211_ht_cap))
+			if (ie_len != sizeof(struct ieee80211_ht_cap))
 				return;
 			/* copy the ie's value into ht_capb*/
 			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos + 2,
@@ -984,59 +984,45 @@ void mwifiex_process_tdls_action_frame(s
 			sta_ptr->is_11n_enabled = 1;
 			break;
 		case WLAN_EID_HT_OPERATION:
-			if (pos > end -
-			    sizeof(struct ieee80211_ht_operation) - 2)
-				return;
-			if (pos[1] != sizeof(struct ieee80211_ht_operation))
+			if (ie_len != sizeof(struct ieee80211_ht_operation))
 				return;
 			/* copy the ie's value into ht_oper*/
 			memcpy(&sta_ptr->tdls_cap.ht_oper, pos + 2,
 			       sizeof(struct ieee80211_ht_operation));
 			break;
 		case WLAN_EID_BSS_COEX_2040:
-			if (pos > end - 3)
-				return;
-			if (pos[1] != 1)
+			if (ie_len != sizeof(pos[2]))
 				return;
 			sta_ptr->tdls_cap.coex_2040 = pos[2];
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
-			if (pos > end - sizeof(struct ieee_types_header))
-				return;
-			if (pos[1] < sizeof(struct ieee_types_header))
+			if (ie_len < sizeof(struct ieee_types_header))
 				return;
-			if (pos[1] > 8)
+			if (ie_len > 8)
 				return;
 			memcpy((u8 *)&sta_ptr->tdls_cap.extcap, pos,
 			       sizeof(struct ieee_types_header) +
-			       min_t(u8, pos[1], 8));
+			       min_t(u8, ie_len, 8));
 			break;
 		case WLAN_EID_RSN:
-			if (pos > end - sizeof(struct ieee_types_header))
+			if (ie_len < sizeof(struct ieee_types_header))
 				return;
-			if (pos[1] < sizeof(struct ieee_types_header))
-				return;
-			if (pos[1] > IEEE_MAX_IE_SIZE -
+			if (ie_len > IEEE_MAX_IE_SIZE -
 			    sizeof(struct ieee_types_header))
 				return;
 			memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
 			       sizeof(struct ieee_types_header) +
-			       min_t(u8, pos[1], IEEE_MAX_IE_SIZE -
+			       min_t(u8, ie_len, IEEE_MAX_IE_SIZE -
 				     sizeof(struct ieee_types_header)));
 			break;
 		case WLAN_EID_QOS_CAPA:
-			if (pos > end - 3)
-				return;
-			if (pos[1] != 1)
+			if (ie_len != sizeof(pos[2]))
 				return;
 			sta_ptr->tdls_cap.qos_info = pos[2];
 			break;
 		case WLAN_EID_VHT_OPERATION:
 			if (priv->adapter->is_hw_11ac_capable) {
-				if (pos > end -
-				    sizeof(struct ieee80211_vht_operation) - 2)
-					return;
-				if (pos[1] !=
+				if (ie_len !=
 				    sizeof(struct ieee80211_vht_operation))
 					return;
 				/* copy the ie's value into vhtoper*/
@@ -1046,10 +1032,7 @@ void mwifiex_process_tdls_action_frame(s
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
 			if (priv->adapter->is_hw_11ac_capable) {
-				if (pos > end -
-				    sizeof(struct ieee80211_vht_cap) - 2)
-					return;
-				if (pos[1] != sizeof(struct ieee80211_vht_cap))
+				if (ie_len != sizeof(struct ieee80211_vht_cap))
 					return;
 				/* copy the ie's value into vhtcap*/
 				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos + 2,
@@ -1059,9 +1042,7 @@ void mwifiex_process_tdls_action_frame(s
 			break;
 		case WLAN_EID_AID:
 			if (priv->adapter->is_hw_11ac_capable) {
-				if (pos > end - 4)
-					return;
-				if (pos[1] != 2)
+				if (ie_len != sizeof(u16))
 					return;
 				sta_ptr->tdls_cap.aid =
 					get_unaligned_le16((pos + 2));


