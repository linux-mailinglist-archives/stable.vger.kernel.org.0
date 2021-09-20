Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE0411B24
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244651AbhITQ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238609AbhITQyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB0260F6E;
        Mon, 20 Sep 2021 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156626;
        bh=SXdcB+wnMpMouMRbowSBCr0qL7+JfhLwmHDUwFaS01w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9ID4diacunLlkgF81q+BxRVnZoBIzRRY47mNBJmZVybe2mOKAZJuS4egqFPuuL8A
         qtX3eyZTYtM9nebKcdjsI6aXTIQ2oWYW3J9FT0kP5Dpp1NvEEYR6iiRe/zxezxqJul
         Ck7/hZLcDw0V6NB8kB3FhlqYwOKeGyrpaCBoFZtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 012/175] ath: Export ath_hw_keysetmac()
Date:   Mon, 20 Sep 2021 18:41:01 +0200
Message-Id: <20210920163918.468730214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath.h |    1 +
 drivers/net/wireless/ath/key.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -205,6 +205,7 @@ int ath_key_config(struct ath_common *co
 			  struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key);
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac);
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
 
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -84,8 +84,7 @@ bool ath_hw_keyreset(struct ath_common *
 }
 EXPORT_SYMBOL(ath_hw_keyreset);
 
-static bool ath_hw_keysetmac(struct ath_common *common,
-			     u16 entry, const u8 *mac)
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
 	u32 unicast_flag = AR_KEYTABLE_VALID;
@@ -125,6 +124,7 @@ static bool ath_hw_keysetmac(struct ath_
 
 	return true;
 }
+EXPORT_SYMBOL(ath_hw_keysetmac);
 
 static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 				      const struct ath_keyval *k,


