Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB6B586E30
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiHAQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 12:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHAP77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 11:59:59 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99883343D
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:59:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [95.31.173.239])
        by mail.ispras.ru (Postfix) with ESMTPSA id 21EFB407624C;
        Mon,  1 Aug 2022 15:59:55 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 1/2] ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
Date:   Mon,  1 Aug 2022 18:59:07 +0300
Message-Id: <20220801155908.1539833-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220801155908.1539833-1-pchelkin@ispras.ru>
References: <20220801155908.1539833-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit b0ec7e55fce65f125bd1d7f02e2dc4de62abee34 upstream.

syzbot is reporting lockdep warning followed by kernel panic at
ath9k_htc_rxep() [1], for ath9k_htc_rxep() depends on ath9k_rx_init()
being already completed.

Since ath9k_htc_rxep() is set by ath9k_htc_connect_svc(WMI_BEACON_SVC)
 from ath9k_init_htc_services(), it is possible that ath9k_htc_rxep() is
called via timer interrupt before ath9k_rx_init() from ath9k_init_device()
is called.

Since we can't call ath9k_init_device() before ath9k_init_htc_services(),
let's hold ath9k_htc_rxep() no-op until ath9k_rx_init() completes.

Link: https://syzkaller.appspot.com/bug?extid=4d2d56175b934b9a7bf9 [1]
Reported-by: syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/2b88f416-b2cb-7a18-d688-951e6dc3fe92@i-love.sakura.ne.jp
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e67..4f71e962279a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -281,6 +281,7 @@ struct ath9k_htc_rxbuf {
 struct ath9k_htc_rx {
 	struct list_head rxbuf;
 	spinlock_t rxbuflock;
+	bool initialized;
 };
 
 #define ATH9K_HTC_TX_CLEANUP_INTERVAL 50 /* ms */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 30ddf333e04d..592034ea4b68 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1133,6 +1133,10 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	unsigned long flags;
 
+	/* Check if ath9k_rx_init() completed. */
+	if (!data_race(priv->rx.initialized))
+		goto err;
+
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
 		if (!tmp_buf->in_process) {
@@ -1188,6 +1192,10 @@ int ath9k_rx_init(struct ath9k_htc_priv *priv)
 		list_add_tail(&rxbuf->list, &priv->rx.rxbuf);
 	}
 
+	/* Allow ath9k_htc_rxep() to operate. */
+	smp_wmb();
+	priv->rx.initialized = true;
+
 	return 0;
 
 err:
-- 
2.25.1

