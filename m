Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F8B3C4B35
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbhGLG4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240495AbhGLGxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 860A26100B;
        Mon, 12 Jul 2021 06:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072647;
        bh=vR1ABgpeMbmxhzXKFQ4b7rI1k/DtsrB2lwmR0yyCI3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJE5JIj3BcKNLcOfzOMJpJCgWtt5d2PQE+UbFaptBZWu3a/2IGnYx/FWZ6lt9pfK7
         /YNiC4rniGW/5z35p5GppeXHSI2cPMwj/x1Rt/xdNMQ4u09YXccOTDAnct7ztXjScA
         uyZhddYE+x9NIb900y0jP99utCYbZEu07Dbpp2T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 524/593] staging: rtl8712: fix error handling in r871xu_drv_init
Date:   Mon, 12 Jul 2021 08:11:24 +0200
Message-Id: <20210712060950.596659244@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit d1d3e3cdfda8eb91f0e24be7ec8be1e6e01b3a1c ]

Previous error handling path was unique for all
possible errors and there was unnecessary branching.
Also, one step for freeing drv_sw was missing. All
these problems was fixed by restructuring error
handling path.

Also, moved out free_netdev() from r8712_free_drv_sw() for
correct error handling.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/febb00f72354449bb4d305f373d6d2f47e539ab4.1623620630.git.paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/os_intfs.c |  4 ----
 drivers/staging/rtl8712/usb_intf.c | 24 ++++++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 0c3ae8495afb..2214aca09730 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -328,8 +328,6 @@ int r8712_init_drv_sw(struct _adapter *padapter)
 
 void r8712_free_drv_sw(struct _adapter *padapter)
 {
-	struct net_device *pnetdev = padapter->pnetdev;
-
 	r8712_free_cmd_priv(&padapter->cmdpriv);
 	r8712_free_evt_priv(&padapter->evtpriv);
 	r8712_DeInitSwLeds(padapter);
@@ -339,8 +337,6 @@ void r8712_free_drv_sw(struct _adapter *padapter)
 	_r8712_free_sta_priv(&padapter->stapriv);
 	_r8712_free_recv_priv(&padapter->recvpriv);
 	mp871xdeinit(padapter);
-	if (pnetdev)
-		free_netdev(pnetdev);
 }
 
 static void enable_video_mode(struct _adapter *padapter, int cbw40_value)
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index dc21e7743349..b760bc355937 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -361,7 +361,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	/* step 1. */
 	pnetdev = r8712_init_netdev();
 	if (!pnetdev)
-		goto error;
+		goto put_dev;
 	padapter = netdev_priv(pnetdev);
 	disable_ht_for_spec_devid(pdid, padapter);
 	pdvobjpriv = &padapter->dvobjpriv;
@@ -381,16 +381,16 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	 * initialize the dvobj_priv
 	 */
 	if (!padapter->dvobj_init) {
-		goto error;
+		goto put_dev;
 	} else {
 		status = padapter->dvobj_init(padapter);
 		if (status != _SUCCESS)
-			goto error;
+			goto free_netdev;
 	}
 	/* step 4. */
 	status = r8712_init_drv_sw(padapter);
 	if (status)
-		goto error;
+		goto dvobj_deinit;
 	/* step 5. read efuse/eeprom data and get mac_addr */
 	{
 		int i, offset;
@@ -570,17 +570,20 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	}
 	/* step 6. Load the firmware asynchronously */
 	if (rtl871x_load_fw(padapter))
-		goto error;
+		goto deinit_drv_sw;
 	spin_lock_init(&padapter->lock_rx_ff0_filter);
 	mutex_init(&padapter->mutex_start);
 	return 0;
-error:
+
+deinit_drv_sw:
+	r8712_free_drv_sw(padapter);
+dvobj_deinit:
+	padapter->dvobj_deinit(padapter);
+free_netdev:
+	free_netdev(pnetdev);
+put_dev:
 	usb_put_dev(udev);
 	usb_set_intfdata(pusb_intf, NULL);
-	if (padapter && padapter->dvobj_deinit)
-		padapter->dvobj_deinit(padapter);
-	if (pnetdev)
-		free_netdev(pnetdev);
 	return -ENODEV;
 }
 
@@ -612,6 +615,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 		r8712_stop_drv_timers(padapter);
 		r871x_dev_unload(padapter);
 		r8712_free_drv_sw(padapter);
+		free_netdev(pnetdev);
 
 		/* decrease the reference count of the usb device structure
 		 * when disconnect
-- 
2.30.2



