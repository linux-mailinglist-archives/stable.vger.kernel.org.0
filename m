Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9757F186CDC
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbgCPOPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 10:15:25 -0400
Received: from mail-wr1-f74.google.com ([209.85.221.74]:40366 "EHLO
        mail-wr1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729856AbgCPOPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 10:15:24 -0400
Received: by mail-wr1-f74.google.com with SMTP id c6so1286818wro.7
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 07:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=+yaiTsgyG2fpVMnBkOvXwvO0tsY0b4RG6eenxzp0ClY=;
        b=KxS+5/bRFWc5+1BXg7OiyxUj2o6tcYBtkCcT4mRqA4psPRhXnYuL1XRF64ekJs2Pdn
         Ghs7A7/IjIvIbUr7PemncPTEeV1Xgiy5diPaVnnhDBk55CqSnKO6MX2POgReP34xED8I
         t6wpbvmVpWSN7MfaTrWrtg+W7uj10LzjBADoc3SjhqGxQ117X5C2WJETRlaZZvE6BpfP
         hY0q78xvFAF7Fa7xv0f8NOj4IrhGpbvrp+CfZPzZdMsBYTHRDuSVs3DkWUZ69BpBo+dy
         0rGBWy+gKmXD5fe6GRqGpdrqTk6pgDIB3ijFqvLXCgXuRfscbXe8eRhHWqmDWkfiFyE1
         mXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=+yaiTsgyG2fpVMnBkOvXwvO0tsY0b4RG6eenxzp0ClY=;
        b=KOQohQpAU9421K/rJiKHxPW/kfiU0gr+aQ9UEPej0UodY2vDNTph5cO03NwjkoUxkH
         sDkex4BjJ4biVQyblBruyfjwcEREdkkKFwy7D3McwlnKHolxly4kqNHMT4omJBQYR0WG
         EJTgnIsVyvgcFv/ippjbX+e4cbl8Lb6ERE2nDuuN/XANBqG0kQ6E9G5V5b6HkNe6K9hV
         m+iOfu9eXZeUtGnlkkV47RCXDsv3mFK7vvsbYt6XbNciDe9nR++/o4ZXcyebhmTdAOiK
         NiRMHA0qP10ChxWv9pH8CSmEnjy7yOa9y/ZyjpImAkLRWw7RokjkvDNsEU7g/+2p41Ln
         /CWw==
X-Gm-Message-State: ANhLgQ0vqsAmuceiQbo8tINHYV8PjXisuFIkB2LjqAc/5v3UrHD6xSgV
        4OxIWBX0l+jHTG2UdbupySmgv1rQyDFJg7F0NLBVi50qj4H0R9A8dPsUcmlpkv7C2yc/8Yzo6z4
        GgIGbptKGOm3daD6F2NzifUwEBNxkl6WgDtDoNp4NQePbARuXExhmHyWbxzJHa4Vii7M=
X-Google-Smtp-Source: ADFU+vvtywTW00JHXgTmYdoPDuLxyM5PFQighD5yyfaaNCUV3M2ewd1U1/Zc1dsWGLQqA3Oznrl3pJdi2LlmYg==
X-Received: by 2002:a5d:6910:: with SMTP id t16mr35268492wru.209.1584368122008;
 Mon, 16 Mar 2020 07:15:22 -0700 (PDT)
Date:   Mon, 16 Mar 2020 15:15:12 +0100
Message-Id: <20200316141512.70762-1-maennich@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH 4.4] mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()
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
 drivers/net/wireless/mwifiex/tdls.c | 70 ++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwi=
fiex/tdls.c
index 9275f9c3f869..14ce8ead5941 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -910,59 +910,117 @@ void mwifiex_process_tdls_action_frame(struct mwifie=
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

