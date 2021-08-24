Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975193F6484
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbhHXRFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238710AbhHXRDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B77613AB;
        Tue, 24 Aug 2021 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824353;
        bh=9JlFOErq7JLjtELfPuF4gJ1Nvsj3R1q+4TsDMP1trYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUwvsi+toAE2pbdinr7tZrUpKDYVuzIDOMZ4RNitlmvru0Z2BUU2a8hPqVO9dpNqm
         fhFpwcpAE2QOwVxWcBgEkYz/RqSchLDY2vB2LWmOOLRIJB9bvaxXDbI4O5mqxK9neZ
         ITWS5GYc2A8T4F9M4vExVw2gVKI44pGXj5x7RhWPY+8LP5XIQolB7+i6f1cZGIsu8q
         hJuz/78y4IdYTmgX5NbyHnWj63edMAQVtQp1VGy0QJfs/MxOdRNYTCFhTnXYpnR+Bb
         uojJ62aXQ1wOsVIQ6V+dDawG+8CXD+6gTPmhOk/RXVnit/tSYAnwQs1soy73T9YtGR
         nwI05Or+bahag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 03/98] ath: Export ath_hw_keysetmac()
Date:   Tue, 24 Aug 2021 12:57:33 -0400
Message-Id: <20210824165908.709932-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 7a364eca46d6..9d18105c449f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -203,6 +203,7 @@ int ath_key_config(struct ath_common *common,
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

