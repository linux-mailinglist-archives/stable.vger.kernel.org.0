Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3C411A30
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbhITQru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240426AbhITQrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D057061177;
        Mon, 20 Sep 2021 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156365;
        bh=AxQTIhik+iGg5x937l9q+I1hv9mL5Euh4QdB2TyhZGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OII9+TPGdJe70Nl+DKGaks5wCZYDUDVhGbCT+B5FEW48cI18nnaWs9hEmQ0uPDZe0
         8B6pJ79lFbn1NSRB+qk3tjMxMuouvH4BGhEkM+SHv5vNDroRr/ME9ijWIGKx5DWu3Y
         aH13Cl53dUE7iiuE2jSUHWga0IoR+vg7VizhDydA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 008/133] ath: Use safer key clearing with key cache entries
Date:   Mon, 20 Sep 2021 18:41:26 +0200
Message-Id: <20210920163912.875316990@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

commit 56c5485c9e444c2e85e11694b6c44f1338fc20fd upstream.

It is possible for there to be pending frames in TXQs with a reference
to the key cache entry that is being deleted. If such a key cache entry
is cleared, those pending frame in TXQ might get transmitted without
proper encryption. It is safer to leave the previously used key into the
key cache in such cases. Instead, only clear the MAC address to prevent
RX processing from using this key cache entry.

This is needed in particularly in AP mode where the TXQs cannot be
flushed on station disconnection. This change alone may not be able to
address all cases where the key cache entry might get reused for other
purposes immediately (the key cache entry should be released for reuse
only once the TXQs do not have any remaining references to them), but
this makes it less likely to get unprotected frames and the more
complete changes may end up being significantly more complex.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214172118.18100-2-jouni@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/key.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -583,7 +583,16 @@ EXPORT_SYMBOL(ath_key_config);
  */
 void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 {
-	ath_hw_keyreset(common, key->hw_key_idx);
+	/* Leave CCMP and TKIP (main key) configured to avoid disabling
+	 * encryption for potentially pending frames already in a TXQ with the
+	 * keyix pointing to this key entry. Instead, only clear the MAC address
+	 * to prevent RX processing from using this key cache entry.
+	 */
+	if (test_bit(key->hw_key_idx, common->ccmp_keymap) ||
+	    test_bit(key->hw_key_idx, common->tkip_keymap))
+		ath_hw_keysetmac(common, key->hw_key_idx, NULL);
+	else
+		ath_hw_keyreset(common, key->hw_key_idx);
 	if (key->hw_key_idx < IEEE80211_WEP_NKID)
 		return;
 


