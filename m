Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE433F66A1
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbhHXR0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240605AbhHXRWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1290D617E1;
        Tue, 24 Aug 2021 17:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824615;
        bh=Vvu19B4yHalICefNAcQH0OhZf60RKEY1qgHWUttZxgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuJtAqt4xQtT8ujBG6CpIcMRbLEbfMbu/lJKfxzuihU/sM8LE3rdFlVId8rMgeaGZ
         i7Up9YLV/pHIVZe5nIBkR17VDQ+7I7d0QuDcZ0SwEQn9skh/fBcFU+vBq+k8eK5yo1
         4IhvK25SxjAeP4yx3ZWZeg+HJKYtvU2WENX6nEtyYU0SshOnTQtUTBn2HCKJl+Z2mx
         RroWnOJozrT8pHvSHwMwr62aNayyOJSLnAD8KV91GdZgdpdhkNaAiRbsXUbGDoj0AA
         Wr1Zbdan+7q+vyw5o+R7akA6bIoNi2L3YKE1ykGlW6jYdWgY3erKa1XoIWd0ztamI4
         0+cmEWhLaqCbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 45/84] ath: Use safer key clearing with key cache entries
Date:   Tue, 24 Aug 2021 13:02:11 -0400
Message-Id: <20210824170250.710392-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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

