Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B798113A53C
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgANKFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbgANKFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F85120678;
        Tue, 14 Jan 2020 10:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996343;
        bh=YYDNboL4m8g3g4m2YUaCkwrjnE5SH4FJd0ATILs0d6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdNEH5ni1RtDaYm7wa6Lge4o5vjwxLvFbEwcqK202ldZf5pXGkq2AGHIXVLR3QOZw
         7aiEPOo8t4jdg9zN6huAgap6QAl6KzqWZaSan6CERpHxVco9KtcfVKsV//ETZktgcf
         mw003QeC28KGO+jZgt0fw4HsUhpV/z9JqfLrcuGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 40/78] staging: vt6656: set usb_set_intfdata on driver fail.
Date:   Tue, 14 Jan 2020 11:01:14 +0100
Message-Id: <20200114094358.969291521@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit c0bcf9f3f5b661d4ace2a64a79ef661edd2a4dc8 upstream.

intfdata will contain stale pointer when the device is detached after
failed initialization when referenced in vt6656_disconnect

Provide driver access to it here and NULL it.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/6de448d7-d833-ef2e-dd7b-3ef9992fee0e@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/device.h   |    1 +
 drivers/staging/vt6656/main_usb.c |    1 +
 drivers/staging/vt6656/wcmd.c     |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -259,6 +259,7 @@ struct vnt_private {
 	u8 mac_hw;
 	/* netdev */
 	struct usb_device *usb;
+	struct usb_interface *intf;
 
 	u64 tsf_time;
 	u8 rx_rate;
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -993,6 +993,7 @@ vt6656_probe(struct usb_interface *intf,
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->usb = udev;
+	priv->intf = intf;
 
 	vnt_set_options(priv);
 
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -99,6 +99,7 @@ void vnt_run_command(struct work_struct
 		if (vnt_init(priv)) {
 			/* If fail all ends TODO retry */
 			dev_err(&priv->usb->dev, "failed to start\n");
+			usb_set_intfdata(priv->intf, NULL);
 			ieee80211_free_hw(priv->hw);
 			return;
 		}


