Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645563F6738
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241661AbhHXRbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241692AbhHXR3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B829061B44;
        Tue, 24 Aug 2021 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824733;
        bh=/oP4OrN/sR2q+/3ZtQW4BOw5KvcCIOZGz+DfgzJ39R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOmmxl8kVS2gEwZVii2ox7/NeY5LJIqLGTMdX30wl4KyeQmr1zfhjjvj8GRakBRTu
         i0bLR0bFrA++olyN5gMu69cWIXSbvlhT3c/MeICUQLH4x496xuQ64oookSyFjvuwm+
         +bju2SlVGWoqctF/z7dXivCXPhBqn/8wecGNhiBUczcov1Ymj4aiuPaq0wRPo8luLa
         poMRNtHW1cKoRL84X8RyGpCMPWRqoO6IwkH48sikRZqwG6qMzYmCzEbCMKUj34lQ+P
         B9Nkp6Nc9+7MSonPikv5qzJZamYGaHaTaQ20pFkwbZvuXayO0VeLImkXzVfzN93Ihu
         U4FBuOEeSlk8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 36/64] ath: Export ath_hw_keysetmac()
Date:   Tue, 24 Aug 2021 13:04:29 -0400
Message-Id: <20210824170457.710623-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

commit d2d3e36498dd8e0c83ea99861fac5cf9e8671226 upstream.

ath9k is going to use this for safer management of key cache entries.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214172118.18100-4-jouni@codeaurora.org
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath.h | 1 +
 drivers/net/wireless/ath/key.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index f3f2784f6ebd..3dffa0c3cae5 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -205,6 +205,7 @@ int ath_key_config(struct ath_common *common,
 			  struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key);
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac);
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
 
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 59618bb41f6c..cb266cf3c77c 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -84,8 +84,7 @@ bool ath_hw_keyreset(struct ath_common *common, u16 entry)
 }
 EXPORT_SYMBOL(ath_hw_keyreset);
 
-static bool ath_hw_keysetmac(struct ath_common *common,
-			     u16 entry, const u8 *mac)
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
 	u32 unicast_flag = AR_KEYTABLE_VALID;
@@ -125,6 +124,7 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 
 	return true;
 }
+EXPORT_SYMBOL(ath_hw_keysetmac);
 
 static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 				      const struct ath_keyval *k,
-- 
2.30.2

