Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E18186CD2
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 15:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbgCPOJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 10:09:33 -0400
Received: from mail-wm1-f74.google.com ([209.85.128.74]:35340 "EHLO
        mail-wm1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731443AbgCPOJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 10:09:33 -0400
Received: by mail-wm1-f74.google.com with SMTP id n188so5858844wmf.0
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 07:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Xdez1dXEK9EtNoxb9mjFlI6NK+NC9OmGNYH6F8+Mkxo=;
        b=c8ax4xQbu/CIn0RKREQCIwJLk0Y5QSD9S9g91j6mbMMnPJ8Dy7hByRbBRoQAyVHPWA
         NgAJEvemaDWlYE67OdiN2mRuvuF/YknQIxzuohuIClZUX8ATDyNlP/o7CfhKKJE6zste
         An7bmz1oNU8Wx2dFO7BPm3FOg8aNRE5qiAlhY7UD5QKcPP8ttUgPdseNDG3LK2a3cL05
         axRjziDY7FBkB1QO+xtxDCEo0Gm+r/rTTDqJ07ceFIq55lYFVJp6+35dc2stcvq/O8PI
         IWLytuO3WVs9P8dEZwCzOziHBDM5Bu3tPIYFd8BGvRVDV5cDs2BYRa2+qO/CRhklv/vv
         50tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Xdez1dXEK9EtNoxb9mjFlI6NK+NC9OmGNYH6F8+Mkxo=;
        b=aZNnj+GjUgxjdb/v45VgbQjLMoz5ysziFoqzO4EpWmKb3JtVY1OJDdYOXux4lxh0Qj
         8/9Oh4SOlMF8+YmMu1bHCjuQQ3SNSE9xjPTAAOAWpPbU/z9n/bQ15sC70kzRrw5HvAQX
         IxDz+OcQ2PmA2aP12zBZms55uRs/sgHp9noXSNbs6YMWk6cCYQa3HXLIM/4eCzUNwfph
         tv8lGDWntKQ5PpU1JNBLOXzIiZuS482FNajj0E24IVz1WL2b/+OlnHyiew1tJfiW25fG
         ovW/EVRFd+peLuxfzpWZNZDbpUlIyTLcoENas1XXsnXIVfgBuFvnYzS3BmC/AnxHKOGd
         QmwA==
X-Gm-Message-State: ANhLgQ11uw2dM9OidqIU1K+Frl36yQoEUoN6AWAv/xmhxrrWngMf/xS3
        lPhI2q7wVi1RqPZNxnvqydP0qk+zQhalNESn4xRnYKPlnVtzbC6N/hXMgwDCryFrXJR1wX6Jiud
        tle+Vkm30enSvKNUPl625FxPQQYJ5nf5nqrZxz5Nehr7Jsvh9vT5OT2hfYJ9PwhNz004=
X-Google-Smtp-Source: ADFU+vu03G3MnZtZ+kOGSISuzpid8xiXLtMKzpqXFCcuFShIM89nrj1yPdhen7KDqKY8gXQSsUqMbBe+qSCWJA==
X-Received: by 2002:adf:8182:: with SMTP id 2mr34682844wra.37.1584367769694;
 Mon, 16 Mar 2020 07:09:29 -0700 (PDT)
Date:   Mon, 16 Mar 2020 15:08:51 +0100
Message-Id: <20200316140851.7622-1-maennich@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH 4.9] mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        qize wang <wangqize888888888@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: qize wang <wangqize888888888@gmail.com>

mwifiex_process_tdls_action_frame() without checking
the incoming tdls infomation element's vality before use it,
this may cause multi heap buffer overflows.

Fix them by putting vality check before use it.

IE is TLV struct, but ht_cap and  ht_oper aren=E2=80=99t TLV struct.
the origin marvell driver code is wrong:

memcpy(&sta_ptr->tdls_cap.ht_oper, pos,....
memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,...

Fix the bug by changing pos(the address of IE) to
pos+2 ( the address of IE value ).

Signed-off-by: qize wang <wangqize888888888@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
(cherry picked from commit 1e58252e334dc3f3756f424a157d1b7484464c40)
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 70 +++++++++++++++++++--
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wire=
less/marvell/mwifiex/tdls.c
index df9704de0715..c6fc09d17462 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -917,59 +917,117 @@ void mwifiex_process_tdls_action_frame(struct mwifie=
x_private *priv,
=20
 		switch (*pos) {
 		case WLAN_EID_SUPP_RATES:
+			if (pos[1] > 32)
+				return;
 			sta_ptr->tdls_cap.rates_len =3D pos[1];
 			for (i =3D 0; i < pos[1]; i++)
 				sta_ptr->tdls_cap.rates[i] =3D pos[i + 2];
 			break;
=20
 		case WLAN_EID_EXT_SUPP_RATES:
+			if (pos[1] > 32)
+				return;
 			basic =3D sta_ptr->tdls_cap.rates_len;
+			if (pos[1] > 32 - basic)
+				return;
 			for (i =3D 0; i < pos[1]; i++)
 				sta_ptr->tdls_cap.rates[basic + i] =3D pos[i + 2];
 			sta_ptr->tdls_cap.rates_len +=3D pos[1];
 			break;
 		case WLAN_EID_HT_CAPABILITY:
-			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,
+			if (pos > end - sizeof(struct ieee80211_ht_cap) - 2)
+				return;
+			if (pos[1] !=3D sizeof(struct ieee80211_ht_cap))
+				return;
+			/* copy the ie's value into ht_capb*/
+			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos + 2,
 			       sizeof(struct ieee80211_ht_cap));
 			sta_ptr->is_11n_enabled =3D 1;
 			break;
 		case WLAN_EID_HT_OPERATION:
-			memcpy(&sta_ptr->tdls_cap.ht_oper, pos,
+			if (pos > end -
+			    sizeof(struct ieee80211_ht_operation) - 2)
+				return;
+			if (pos[1] !=3D sizeof(struct ieee80211_ht_operation))
+				return;
+			/* copy the ie's value into ht_oper*/
+			memcpy(&sta_ptr->tdls_cap.ht_oper, pos + 2,
 			       sizeof(struct ieee80211_ht_operation));
 			break;
 		case WLAN_EID_BSS_COEX_2040:
+			if (pos > end - 3)
+				return;
+			if (pos[1] !=3D 1)
+				return;
 			sta_ptr->tdls_cap.coex_2040 =3D pos[2];
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
+			if (pos[1] !=3D 1)
+				return;
 			sta_ptr->tdls_cap.qos_info =3D pos[2];
 			break;
 		case WLAN_EID_VHT_OPERATION:
-			if (priv->adapter->is_hw_11ac_capable)
-				memcpy(&sta_ptr->tdls_cap.vhtoper, pos,
+			if (priv->adapter->is_hw_11ac_capable) {
+				if (pos > end -
+				    sizeof(struct ieee80211_vht_operation) - 2)
+					return;
+				if (pos[1] !=3D
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
+				if (pos[1] !=3D sizeof(struct ieee80211_vht_cap))
+					return;
+				/* copy the ie's value into vhtcap*/
+				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos + 2,
 				       sizeof(struct ieee80211_vht_cap));
 				sta_ptr->is_11ac_enabled =3D 1;
 			}
 			break;
 		case WLAN_EID_AID:
-			if (priv->adapter->is_hw_11ac_capable)
+			if (priv->adapter->is_hw_11ac_capable) {
+				if (pos > end - 4)
+					return;
+				if (pos[1] !=3D 2)
+					return;
 				sta_ptr->tdls_cap.aid =3D
 					      le16_to_cpu(*(__le16 *)(pos + 2));
+			}
+			break;
 		default:
 			break;
 		}
--=20
2.25.1.481.gfbce0eb801-goog

