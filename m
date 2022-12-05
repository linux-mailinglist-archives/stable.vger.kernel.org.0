Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781DF6432AE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiLET2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiLET1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA1127FED
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D078F612D8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B3CC433D6;
        Mon,  5 Dec 2022 19:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268284;
        bh=0dOC2853pUkqoBBB9gD125uOp0Um9BgNFPjBd1+AYuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiixUxGuCUIlknohfPqwDNm/BfcZzFEr4LWlXB/TqxZ7B5WfFHwsn6ODD+Zjf3s79
         9LehUDKkobxIDDl12LmWp714J1XjS37wn+TJB2zJmB6eHsJV2Mc5Q2Ai/rB34m8zrR
         OBRvIJJOtY7GfWi4MXAvvVqPUdpcwH/mtFoWswA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Izabela Bakollari <ibakolla@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 046/124] aquantia: Do not purge addresses when setting the number of rings
Date:   Mon,  5 Dec 2022 20:09:12 +0100
Message-Id: <20221205190809.748988187@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Izabela Bakollari <ibakolla@redhat.com>

[ Upstream commit 2a83891130512dafb321418a8e7c9c09268d8c59 ]

IPV6 addresses are purged when setting the number of rx/tx
rings using ethtool -G. The function aq_set_ringparam
calls dev_close, which removes the addresses. As a solution,
call an internal function (aq_ndev_close).

Fixes: c1af5427954b ("net: aquantia: Ethtool based ring size configuration")
Signed-off-by: Izabela Bakollari <ibakolla@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 5 +++--
 drivers/net/ethernet/aquantia/atlantic/aq_main.c    | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_main.h    | 2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 1daecd483b8d..9c1378c22a8e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -13,6 +13,7 @@
 #include "aq_ptp.h"
 #include "aq_filters.h"
 #include "aq_macsec.h"
+#include "aq_main.h"
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -858,7 +859,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 
 	if (netif_running(ndev)) {
 		ndev_running = true;
-		dev_close(ndev);
+		aq_ndev_close(ndev);
 	}
 
 	cfg->rxds = max(ring->rx_pending, hw_caps->rxds_min);
@@ -874,7 +875,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 		goto err_exit;
 
 	if (ndev_running)
-		err = dev_open(ndev, NULL);
+		err = aq_ndev_open(ndev);
 
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 8a0af371e7dc..77609dc0a08d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -58,7 +58,7 @@ struct net_device *aq_ndev_alloc(void)
 	return ndev;
 }
 
-static int aq_ndev_open(struct net_device *ndev)
+int aq_ndev_open(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
@@ -88,7 +88,7 @@ static int aq_ndev_open(struct net_device *ndev)
 	return err;
 }
 
-static int aq_ndev_close(struct net_device *ndev)
+int aq_ndev_close(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.h b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
index 99870865f66d..a78c1a168d8e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
@@ -16,5 +16,7 @@ DECLARE_STATIC_KEY_FALSE(aq_xdp_locking_key);
 
 void aq_ndev_schedule_work(struct work_struct *work);
 struct net_device *aq_ndev_alloc(void);
+int aq_ndev_open(struct net_device *ndev);
+int aq_ndev_close(struct net_device *ndev);
 
 #endif /* AQ_MAIN_H */
-- 
2.35.1



