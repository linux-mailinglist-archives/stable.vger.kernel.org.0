Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561D718B7BB
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgCSNLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbgCSNLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:11:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B1B520789;
        Thu, 19 Mar 2020 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623494;
        bh=iux0Xb2ticIVhHEUPWQC3mRyNHY7aypyQ/BegDG1ANg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeQvNstFQgtw8xAop+cmHcK5vS1NRWSIh3TXcswY3skP4oZbMPynEKC0HODf9e+XA
         PLRocf30ZdptLM8iDKEmuM7DrpaCyi8X33BScV9vUn9E/IaM6yRj20UltzAEhaDmF3
         ji99susgQ2AT2tJ4U9c6R3CjREI7W1cECMqHjXIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, qize wang <wangqize888888888@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 4.9 46/90] mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()
Date:   Thu, 19 Mar 2020 14:00:08 +0100
Message-Id: <20200319123942.812731901@linuxfoundation.org>
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

From: qize wang <wangqize888888888@gmail.com>

commit 1e58252e334dc3f3756f424a157d1b7484464c40 upstream.

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
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/tdls.c |   70 +++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -917,59 +917,117 @@ void mwifiex_process_tdls_action_frame(s
 
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
 					      le16_to_cpu(*(__le16 *)(pos + 2));
+			}
+			break;
 		default:
 			break;
 		}


