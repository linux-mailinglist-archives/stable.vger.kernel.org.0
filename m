Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEEE499B40
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574916AbiAXVun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357688AbiAXVhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CEAC0BD118;
        Mon, 24 Jan 2022 12:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E354B81239;
        Mon, 24 Jan 2022 20:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AA5C340E5;
        Mon, 24 Jan 2022 20:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055789;
        bh=I83jkJq/WrYb2koe1pfNdBN/QukfSOV9ISZf16cQILE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qldjHC7H8e3Y/CwUgeMJwRtScg3ZB4NPwfNx9da/Xm4abCLnQF5PAshqfJ/c1LxhS
         pPekF8YLqWxgbcOG8yu7bbLzGOgNsjx7hssic1tqEhLyEeEhpp26KRe+fDBrK08FTQ
         9fWZ/UoDRYLJmeZkXFcoBmPUbcNLk+He/b83yW5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/846] wilc1000: fix double free error in probe()
Date:   Mon, 24 Jan 2022 19:36:24 +0100
Message-Id: <20220124184110.139459629@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4894edacfa93d7046bec4fc61fc402ac6a2ac9e8 ]

Smatch complains that there is a double free in probe:

drivers/net/wireless/microchip/wilc1000/spi.c:186 wilc_bus_probe() error: double free of 'spi_priv'
drivers/net/wireless/microchip/wilc1000/sdio.c:163 wilc_sdio_probe() error: double free of 'sdio_priv'

The problem is that wilc_netdev_cleanup() function frees "wilc->bus_data".
That's confusing and a layering violation.  Leave the frees in probe(),
delete the free in wilc_netdev_cleanup(), and add some new frees to the
remove() functions.

Fixes: dc8b338f3bcd ("wilc1000: use goto labels on error path")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211217150311.GC16611@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 1 -
 drivers/net/wireless/microchip/wilc1000/sdio.c   | 2 ++
 drivers/net/wireless/microchip/wilc1000/spi.c    | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 7e4d9235251cb..9dfb1a285e6a4 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -901,7 +901,6 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 
 	wilc_wlan_cfg_deinit(wilc);
 	wlan_deinit_locks(wilc);
-	kfree(wilc->bus_data);
 	wiphy_unregister(wilc->wiphy);
 	wiphy_free(wilc->wiphy);
 }
diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 42e03a701ae16..8b3b735231085 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -167,9 +167,11 @@ free:
 static void wilc_sdio_remove(struct sdio_func *func)
 {
 	struct wilc *wilc = sdio_get_drvdata(func);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 
 	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
+	kfree(sdio_priv);
 }
 
 static int wilc_sdio_reset(struct wilc *wilc)
diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index dd481dc0b5ce0..c98c0999a6b67 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -182,9 +182,11 @@ free:
 static int wilc_bus_remove(struct spi_device *spi)
 {
 	struct wilc *wilc = spi_get_drvdata(spi);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 
 	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
+	kfree(spi_priv);
 
 	return 0;
 }
-- 
2.34.1



