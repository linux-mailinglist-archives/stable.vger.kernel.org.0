Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B8B643331
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiLETe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiLETec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749F38B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:30:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3506FB80EFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0352C433D6;
        Mon,  5 Dec 2022 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268598;
        bh=txzRAABCFF3UQR3XNXFq2ueaC3J5sii85xQFg8Zg1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Adn+8ZgQgFVKNrhriJDmqNqZTMt7THIWJp1Z++jUvXrLs/uVbjsDC7XqP+lrqvd9h
         t0Hn1qsBJkhMchk//Blt0LeXP5Dgi6Q+3kAV5N318xv0iIlmDH1IQ4oyo+8LfZH+5X
         DBSpny5NsygUrZYWDCAJOQ1EEd4bVub+oxJwDWP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Izabela Bakollari <ibakolla@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/92] aquantia: Do not purge addresses when setting the number of rings
Date:   Mon,  5 Dec 2022 20:09:48 +0100
Message-Id: <20221205190804.627559314@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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
index de2a9348bc3f..1d512e6a89f5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -13,6 +13,7 @@
 #include "aq_ptp.h"
 #include "aq_filters.h"
 #include "aq_macsec.h"
+#include "aq_main.h"
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -841,7 +842,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 
 	if (netif_running(ndev)) {
 		ndev_running = true;
-		dev_close(ndev);
+		aq_ndev_close(ndev);
 	}
 
 	cfg->rxds = max(ring->rx_pending, hw_caps->rxds_min);
@@ -857,7 +858,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 		goto err_exit;
 
 	if (ndev_running)
-		err = dev_open(ndev, NULL);
+		err = aq_ndev_open(ndev);
 
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index ff245f75fa3d..1401fc4632b5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -53,7 +53,7 @@ struct net_device *aq_ndev_alloc(void)
 	return ndev;
 }
 
-static int aq_ndev_open(struct net_device *ndev)
+int aq_ndev_open(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
@@ -83,7 +83,7 @@ static int aq_ndev_open(struct net_device *ndev)
 	return err;
 }
 
-static int aq_ndev_close(struct net_device *ndev)
+int aq_ndev_close(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.h b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
index a5a624b9ce73..2a562ab7a5af 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
@@ -14,5 +14,7 @@
 
 void aq_ndev_schedule_work(struct work_struct *work);
 struct net_device *aq_ndev_alloc(void);
+int aq_ndev_open(struct net_device *ndev);
+int aq_ndev_close(struct net_device *ndev);
 
 #endif /* AQ_MAIN_H */
-- 
2.35.1



