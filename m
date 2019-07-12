Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BCF66F07
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfGLMUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfGLMUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:20:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF96221019;
        Fri, 12 Jul 2019 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934005;
        bh=BLNnb4yLAEjDZeHBc8DuW2fjRJSdPR8MudAIhIG9eJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14yqT4uO6zdO5K+1JOmt2E3gbcDoXM+liFSIJw1fyASNAkJ5G9lM6gvjaC6dVQw/z
         P+zcsprehSaYk9MkuVEXvTueupWkvHklObvvPYOoUN0GQmUaxZUlCNiLwwiOpnJUKr
         4g1sNxvdZWLKp6XFQ2vmJuzhq14y8ecgWQBBzPAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwen <huangwen@venustech.com.cn>,
        Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/91] mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()
Date:   Fri, 12 Jul 2019 14:18:19 +0200
Message-Id: <20190712121622.268339196@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 69ae4f6aac1578575126319d3f55550e7e440449 ]

A few places in mwifiex_uap_parse_tail_ies() perform memcpy()
unconditionally, which may lead to either buffer overflow or read over
boundary.

This patch addresses the issues by checking the read size and the
destination size at each place more properly.  Along with the fixes,
the patch cleans up the code slightly by introducing a temporary
variable for the token size, and unifies the error path with the
standard goto statement.

Reported-by: huangwen <huangwen@venustech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/ie.c | 47 +++++++++++++++--------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index 75cbd609d606..801a2d7b020a 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -329,6 +329,8 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 	struct ieee80211_vendor_ie *vendorhdr;
 	u16 gen_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
 	int left_len, parsed_len = 0;
+	unsigned int token_len;
+	int err = 0;
 
 	if (!info->tail || !info->tail_len)
 		return 0;
@@ -344,6 +346,12 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 	 */
 	while (left_len > sizeof(struct ieee_types_header)) {
 		hdr = (void *)(info->tail + parsed_len);
+		token_len = hdr->len + sizeof(struct ieee_types_header);
+		if (token_len > left_len) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		switch (hdr->element_id) {
 		case WLAN_EID_SSID:
 		case WLAN_EID_SUPP_RATES:
@@ -361,16 +369,19 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 			if (cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
 						    WLAN_OUI_TYPE_MICROSOFT_WMM,
 						    (const u8 *)hdr,
-						    hdr->len + sizeof(struct ieee_types_header)))
+						    token_len))
 				break;
 		default:
-			memcpy(gen_ie->ie_buffer + ie_len, hdr,
-			       hdr->len + sizeof(struct ieee_types_header));
-			ie_len += hdr->len + sizeof(struct ieee_types_header);
+			if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
+				err = -EINVAL;
+				goto out;
+			}
+			memcpy(gen_ie->ie_buffer + ie_len, hdr, token_len);
+			ie_len += token_len;
 			break;
 		}
-		left_len -= hdr->len + sizeof(struct ieee_types_header);
-		parsed_len += hdr->len + sizeof(struct ieee_types_header);
+		left_len -= token_len;
+		parsed_len += token_len;
 	}
 
 	/* parse only WPA vendor IE from tail, WMM IE is configured by
@@ -380,15 +391,17 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 						    WLAN_OUI_TYPE_MICROSOFT_WPA,
 						    info->tail, info->tail_len);
 	if (vendorhdr) {
-		memcpy(gen_ie->ie_buffer + ie_len, vendorhdr,
-		       vendorhdr->len + sizeof(struct ieee_types_header));
-		ie_len += vendorhdr->len + sizeof(struct ieee_types_header);
+		token_len = vendorhdr->len + sizeof(struct ieee_types_header);
+		if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
+			err = -EINVAL;
+			goto out;
+		}
+		memcpy(gen_ie->ie_buffer + ie_len, vendorhdr, token_len);
+		ie_len += token_len;
 	}
 
-	if (!ie_len) {
-		kfree(gen_ie);
-		return 0;
-	}
+	if (!ie_len)
+		goto out;
 
 	gen_ie->ie_index = cpu_to_le16(gen_idx);
 	gen_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON |
@@ -398,13 +411,15 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 
 	if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL, NULL,
 					 NULL, NULL)) {
-		kfree(gen_ie);
-		return -1;
+		err = -EINVAL;
+		goto out;
 	}
 
 	priv->gen_idx = gen_idx;
+
+ out:
 	kfree(gen_ie);
-	return 0;
+	return err;
 }
 
 /* This function parses different IEs-head & tail IEs, beacon IEs,
-- 
2.20.1



