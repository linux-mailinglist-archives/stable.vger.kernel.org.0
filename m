Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F663F6580
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhHXRNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238743AbhHXRLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1813E61163;
        Tue, 24 Aug 2021 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824471;
        bh=Vvu19B4yHalICefNAcQH0OhZf60RKEY1qgHWUttZxgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaShLC5B60/9BVFcyRURlWCX2G6C2sIg4waA685iZJXJ1oc5zn7m79FV7R5HkTekU
         v77MefeFKbzAnRBxJOugVuHAOOZPEg6h4vDbdHPjj6s48QoF7ARaD7TQItqdTZ6/FM
         kwUSSTHqqEmRLaj8+xYUT9taqESzxgOD/EI/xp83k6LBAs/LAvqhQShl0xSzRhLoeY
         U8zgQCGE+tYCGyP5sVHoWypgO8Bpyef+pbsHuKTruj/vHKIc/jkSh77wxtH+IXaBFF
         QwHBZw+T7lDcyqpdOPf7iHklcFoUINeI7SXVdzkV39vb4R9hYOErL7jFqrrfIDTjoe
         MxiP4HV2wMQ0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 03/61] ath: Use safer key clearing with key cache entries
Date:   Tue, 24 Aug 2021 13:00:08 -0400
Message-Id: <20210824170106.710221-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/key.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 1816b4e7dc26..59618bb41f6c 100644
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
 
-- 
2.30.2

