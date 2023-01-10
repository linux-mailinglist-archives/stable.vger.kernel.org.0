Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6F664832
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbjAJSKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238863AbjAJSJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDEABC9E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43D32B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B439C433D2;
        Tue, 10 Jan 2023 18:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374015;
        bh=J7FBa41VCdWOW3WhQvIKSo9zaLEjMakbdgyb0o5uhg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJDSQEY5MfLoKldeDaYihNNA9aSf7Rhu78AURWqbbtboHUIvtMhLMAbBqu435Jaw6
         YqR/feZNCSUEMofWSU409PZPMUyJp6OIdoQthapyGuXkm8+b+Xx/daxZn9SxggchNq
         /2z8ONTJSEHPT6FtAVjG2AinNjInk8jhLs1AGB2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 013/148] wifi: ath9k: use proper statements in conditionals
Date:   Tue, 10 Jan 2023 19:01:57 +0100
Message-Id: <20230110180017.606510705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b7dc753fe33a707379e2254317794a4dad6c0fe2 ]

A previous cleanup patch accidentally broke some conditional
expressions by replacing the safe "do {} while (0)" constructs
with empty macros. gcc points this out when extra warnings
are enabled:

drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_complete':
drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
  251 |                         TX_STAT_INC(hif_dev, skb_failed);

Make both sets of macros proper expressions again.

Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221215165553.1950307-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 30f0765fb9fd..237f4ec2cffd 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,9 +327,9 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
-#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
-#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_priv ? (expr) : 0); } while (0)
+#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++); } while (0)
+#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stats[q]++); } while (0)
 
 #define TX_STAT_INC(hif_dev, c) \
 		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
@@ -378,10 +378,10 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 			    struct ethtool_stats *stats, u64 *data);
 #else
 
-#define TX_STAT_INC(hif_dev, c)
-#define TX_STAT_ADD(hif_dev, c, a)
-#define RX_STAT_INC(hif_dev, c)
-#define RX_STAT_ADD(hif_dev, c, a)
+#define TX_STAT_INC(hif_dev, c)		do { } while (0)
+#define TX_STAT_ADD(hif_dev, c, a)	do { } while (0)
+#define RX_STAT_INC(hif_dev, c)		do { } while (0)
+#define RX_STAT_ADD(hif_dev, c, a)	do { } while (0)
 
 #define CAB_STAT_INC(priv)
 #define TX_QSTAT_INC(priv, c)
-- 
2.35.1



