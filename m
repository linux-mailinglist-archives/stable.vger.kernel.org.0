Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAE150D55
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbgBCQnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbgBCQdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:08 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5AF4218AC;
        Mon,  3 Feb 2020 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747587;
        bh=UThbzfSf4Wwh3VgJmibCx6y+YMZQIWjX9JUof9n9J8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tdVuNlFEOVA+zj/bi1qnmVBozCAD8IYWw+9CZ6BithrFmiqEDIPql+5wW6ntyC8R
         D02BPZjdsW8hTInw6W/deOJvqtlMQgOJA6Rxbu+cvs5Ic0ljKG89QSKipervGRKNIt
         ZYSP+C8klGuN1lFaPosIOEsd6T9NYLHROd8zhybU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/70] rsi: add hci detach for hibernation and poweroff
Date:   Mon,  3 Feb 2020 16:19:18 +0000
Message-Id: <20200203161913.332966143@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

[ Upstream commit cbde979b33fa16e06dadc2c81093699a2bc787db ]

As we missed to detach HCI, while entering power off or hibernation,
an extra hci interface gets created whenever system is woken up, to
avoid this we added hci_detach() in rsi_disconnect(), rsi_freeze(),
and rsi_shutdown() functions which are invoked for these tests.
This patch fixes the issue

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 18 ++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  7 +++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 5733e440ecaff..81cc1044532d1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1129,6 +1129,12 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 	rsi_mac80211_detach(adapter);
 	mdelay(10);
 
+	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
+	    adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	/* Reset Chip */
 	rsi_reset_chip(adapter);
 
@@ -1305,6 +1311,12 @@ static int rsi_freeze(struct device *dev)
 		rsi_dbg(ERR_ZONE,
 			"##### Device can not wake up through WLAN\n");
 
+	if (IS_ENABLED(CONFIG_RSI_COEX) && common->coex_mode > 1 &&
+	    common->bt_adapter) {
+		rsi_bt_ops.detach(common->bt_adapter);
+		common->bt_adapter = NULL;
+	}
+
 	ret = rsi_sdio_disable_interrupts(pfunction);
 
 	if (sdev->write_fail)
@@ -1352,6 +1364,12 @@ static void rsi_shutdown(struct device *dev)
 	if (rsi_config_wowlan(adapter, wowlan))
 		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
 
+	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
+	    adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	rsi_sdio_disable_interrupts(sdev->pfunction);
 
 	if (sdev->write_fail)
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 90eb749e2b616..c62e7e0f82f32 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -818,6 +818,13 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		return;
 
 	rsi_mac80211_detach(adapter);
+
+	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
+	    adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.20.1



