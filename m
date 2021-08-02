Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06ED03DDA21
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbhHBOGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236011AbhHBOEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD9C060FC2;
        Mon,  2 Aug 2021 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912653;
        bh=oGIDwrhQA59BqYIi+ujH1CmZIRsuETtH2fTIyuKm8dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytNpvXYtLFcism8Oj6pvQyiA3X7EPSL46ds+9QmOsdFfAP4sooOf3Wl+UHcNn9jyo
         4mBDmxJwVE2eCccQfeu8LNsfBd5Y1xxnCSTudIRPIDpfSYlOmA0zDnFzq78PvH/g/s
         CWSlwE35uk7Tc3u5jUecY/cJ6ASdMJ9gqN8hTmro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 056/104] ionic: catch no ptp support earlier
Date:   Mon,  2 Aug 2021 15:44:53 +0200
Message-Id: <20210802134345.852801219@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit f79eef711eb57d56874b08ea11db69221de54a6d ]

If PTP configuration is attempted on ports that don't support
it, such as VF ports, the driver will return an error status
-95, or EOPNOSUPP and print an error message
    enp98s0: hwstamp set failed: -95

Because some daemons can retry every few seconds, this can end
up filling the dmesg log and pushing out other more useful
messages.

We can catch this issue earlier in our handling and return
the error without a log message.

Fixes: 829600ce5e4e ("ionic: add ts_config replay")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |  7 ++-----
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 10 +++++++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index af291303bd7a..69ab59fedb6c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -302,7 +302,7 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 int ionic_lif_size(struct ionic *ionic);
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
-int ionic_lif_hwstamp_replay(struct ionic_lif *lif);
+void ionic_lif_hwstamp_replay(struct ionic_lif *lif);
 int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr);
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr);
 ktime_t ionic_lif_phc_ktime(struct ionic_lif *lif, u64 counter);
@@ -311,10 +311,7 @@ void ionic_lif_unregister_phc(struct ionic_lif *lif);
 void ionic_lif_alloc_phc(struct ionic_lif *lif);
 void ionic_lif_free_phc(struct ionic_lif *lif);
 #else
-static inline int ionic_lif_hwstamp_replay(struct ionic_lif *lif)
-{
-	return -EOPNOTSUPP;
-}
+static inline void ionic_lif_hwstamp_replay(struct ionic_lif *lif) {}
 
 static inline int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index a87c87e86aef..6e2403c71608 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -188,6 +188,9 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	struct hwtstamp_config config;
 	int err;
 
+	if (!lif->phc || !lif->phc->ptp)
+		return -EOPNOTSUPP;
+
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
@@ -203,15 +206,16 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	return 0;
 }
 
-int ionic_lif_hwstamp_replay(struct ionic_lif *lif)
+void ionic_lif_hwstamp_replay(struct ionic_lif *lif)
 {
 	int err;
 
+	if (!lif->phc || !lif->phc->ptp)
+		return;
+
 	err = ionic_lif_hwstamp_set_ts_config(lif, NULL);
 	if (err)
 		netdev_info(lif->netdev, "hwstamp replay failed: %d\n", err);
-
-	return err;
 }
 
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
-- 
2.30.2



