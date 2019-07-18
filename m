Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863E26C687
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391659AbfGRDRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391844AbfGRDOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:14:36 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D00E21872;
        Thu, 18 Jul 2019 03:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419675;
        bh=7Xy0/I7Sujlv6TRxVs2wtZqeYcorXQQ+qBc52jq8EPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5X6yTy9xtFGtHghhYSvs9PgpgSMn6ASEQMgKvGHTmYDlSp6mqX+hDyEgIZLzeotY
         f1f1cwOMkvyHtDq0yDRgT7ce3LY9HtLHcJ+kFEGnqy/rJfX1tE6gc8K67DNpiGo9rJ
         9HrsegOVxYopO6oJNDgJICvDkCerK4va3m0zD+ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwen <huangwen@venustech.com.cn>,
        Takashi Iwai <tiwai@suse.de>, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 16/40] mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()
Date:   Thu, 18 Jul 2019 12:02:12 +0900
Message-Id: <20190718030044.173010604@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 69ae4f6aac1578575126319d3f55550e7e440449 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/mwifiex/ie.c |   45 +++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -328,6 +328,8 @@ static int mwifiex_uap_parse_tail_ies(st
 	struct ieee80211_vendor_ie *vendorhdr;
 	u16 gen_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
 	int left_len, parsed_len = 0;
+	unsigned int token_len;
+	int err = 0;
 
 	if (!info->tail || !info->tail_len)
 		return 0;
@@ -343,6 +345,12 @@ static int mwifiex_uap_parse_tail_ies(st
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
@@ -356,13 +364,16 @@ static int mwifiex_uap_parse_tail_ies(st
 		case WLAN_EID_VENDOR_SPECIFIC:
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
@@ -372,15 +383,17 @@ static int mwifiex_uap_parse_tail_ies(st
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
@@ -390,13 +403,15 @@ static int mwifiex_uap_parse_tail_ies(st
 
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


