Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB844AAB2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 10:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243122AbhKIJnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 04:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244949AbhKIJnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 04:43:10 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2587C061766
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 01:40:24 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t30so31852313wra.10
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 01:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2LaFxAyiWOhU4WhH+gJn2JlkMKiYeke8XTSsrsf3uN4=;
        b=U7QzRzts72PcDeiKO7QK1l+/76TcBQa5H9WHjgRkK58zlICKy3AHUpXuVSRxdlSpLN
         klqZDeT27qiP0mwiEK+DnYLgFW2h9MQLUxD4gMgdVToSTE7UBm7nnzNZpfYtYlmA2KeE
         /GByTW7oVU5pjshjB5inpfO4Sf7GQYUbZUaPWCAFDgfN1qA+2njP1FedUB1Ey+R5Gx0m
         9uzzZ6hO52L/sOPTatBxZM9EZyQu3N6MGvs5x1lHKwW+EGCA+Isa1Cy47lDssTJy9yMU
         b8UwSjhZjabuwgIThYEdc5C9qPN5PHrhgKRoWO/ft3eM9WAog+B10pgam/o3eQmIFt67
         R7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2LaFxAyiWOhU4WhH+gJn2JlkMKiYeke8XTSsrsf3uN4=;
        b=3UYK7xCY/Lck+tmFLIRzqR0MImnuYvXoj06auFEuwKt+5mJCuZlZPWjvs0RmL1kH8G
         T2Ec/ppXv9xgNSAOo3v5Lpth+FCUm7bYS5LniQYRVsmHs0L2DW6WLhjyEQILz9o/ZCJQ
         7XiuVpak2vUpzdfrRkBM+Ni1mLQxl+7LaQEjenJNPhs2vmX+UOQGFa5UYXHpbj6x9kZV
         CtkdkMxAGXRumuxUNj3VU4arUkL0rB7la14WpaIS1RgwqBEmNwj1PIwOKf2cXHqR2xKM
         J+fg+xDx8g/4Z1Tiy3pvK7jY/410i2G/rPEcN8OCl/szKCUNhsJzwXzoX6UQ9ZcdSf2p
         5Cjg==
X-Gm-Message-State: AOAM533mW481MESI3v4vb9c35ONNaGSajCyzchRCWop+LolTBfS/JMWL
        2bGE88fbALMIjbQtuz7S9TqKXkdOotoW+g==
X-Google-Smtp-Source: ABdhPJw9IN5PY9tkBagb6WCCsGGe/fHPapQ8VMl2Ef8J6VqEMyDPWvJeFoCiw5k+dmPkCNwTW49kww==
X-Received: by 2002:a5d:5504:: with SMTP id b4mr7748262wrv.307.1636450823199;
        Tue, 09 Nov 2021 01:40:23 -0800 (PST)
Received: from localhost.localdomain ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id o1sm20553748wrn.63.2021.11.09.01.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 01:40:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 2/2] usb: hso: fix error handling code of hso_create_net_device
Date:   Tue,  9 Nov 2021 09:39:59 +0000
Message-Id: <20211109093959.173885-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211109093959.173885-1-lee.jones@linaro.org>
References: <20211109093959.173885-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit a6ecfb39ba9d7316057cea823b196b734f6b18ca ]

The current error handling code of hso_create_net_device is
hso_free_net_device, no matter which errors lead to. For example,
WARNING in hso_free_net_device [1].

Fix this by refactoring the error handling code of
hso_create_net_device by handling different errors by different code.

[1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe

Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index fc1ba1e808e1a..a3a3d4b40a7cc 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2512,7 +2512,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2525,13 +2525,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 				      USB_DIR_IN);
 	if (!hso_net->in_endp) {
 		dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
 				       USB_DIR_OUT);
 	if (!hso_net->out_endp) {
 		dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	SET_NETDEV_DEV(net, &interface->dev);
 	SET_NETDEV_DEVTYPE(net, &hso_type);
@@ -2540,18 +2540,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_urb_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
 							   GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_buf_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_urb)
-		goto exit;
+		goto err_mux_bulk_rx;
 	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_buf)
-		goto exit;
+		goto err_free_tx_urb;
 
 	add_net_device(hso_dev);
 
@@ -2559,7 +2559,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2567,8 +2567,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	hso_create_rfkill(hso_dev, interface);
 
 	return hso_dev;
-exit:
-	hso_free_net_device(hso_dev);
+
+err_free_tx_buf:
+	remove_net_device(hso_dev);
+	kfree(hso_net->mux_bulk_tx_buf);
+err_free_tx_urb:
+	usb_free_urb(hso_net->mux_bulk_tx_urb);
+err_mux_bulk_rx:
+	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
+		usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
+		kfree(hso_net->mux_bulk_rx_buf_pool[i]);
+	}
+err_net:
+	free_netdev(net);
+err_hso_dev:
+	kfree(hso_dev);
 	return NULL;
 }
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

