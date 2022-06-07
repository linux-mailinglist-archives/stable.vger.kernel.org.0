Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6808D540A82
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350977AbiFGSWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352998AbiFGSRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CBC13FD7F;
        Tue,  7 Jun 2022 10:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CECC617A7;
        Tue,  7 Jun 2022 17:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBB9C3411F;
        Tue,  7 Jun 2022 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624374;
        bh=LbqyjluyiwqorG7sAuTBbY2h6uEWrKDh7XnSBWLGDfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpcRilogoW97qf+eKamCpf7fpwzCI0SI0BLBFkiM9/gbhykNy28bh1K9BYoApu2ag
         AbJ2Wzmt2l1mNup6G0eSxJRgXjhqRsGTOmIjYqLFfcKaSekmre9m/k35Q0wE7zOWUv
         P2RXd8HxNM9Jajq85WzJ3Ofsw2daL6HPYlFLyxTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/667] wilc1000: fix crash observed in AP mode with cfg80211_register_netdevice()
Date:   Tue,  7 Jun 2022 18:59:27 +0200
Message-Id: <20220607164943.834817510@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

[ Upstream commit 868f0e28290c7a33e8cb79bfe97ebdcbb756e048 ]

Monitor(mon.) interface is used for handling the AP mode and 'ieee80211_ptr'
reference is not getting set for it. Like earlier implementation,
use register_netdevice() instead of cfg80211_register_netdevice() which
expects valid 'ieee80211_ptr' reference to avoid the possible crash.

Fixes: 2fe8ef106238 ("cfg80211: change netdev registration/unregistration semantics")
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220504161924.2146601-3-ajay.kathat@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/mon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index 6bd63934c2d8..b5a1b65c087c 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -233,7 +233,7 @@ struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
 	wl->monitor_dev->netdev_ops = &wilc_wfi_netdev_ops;
 	wl->monitor_dev->needs_free_netdev = true;
 
-	if (cfg80211_register_netdevice(wl->monitor_dev)) {
+	if (register_netdevice(wl->monitor_dev)) {
 		netdev_err(real_dev, "register_netdevice failed\n");
 		free_netdev(wl->monitor_dev);
 		return NULL;
@@ -251,7 +251,7 @@ void wilc_wfi_deinit_mon_interface(struct wilc *wl, bool rtnl_locked)
 		return;
 
 	if (rtnl_locked)
-		cfg80211_unregister_netdevice(wl->monitor_dev);
+		unregister_netdevice(wl->monitor_dev);
 	else
 		unregister_netdev(wl->monitor_dev);
 	wl->monitor_dev = NULL;
-- 
2.35.1



