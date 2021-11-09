Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C15F44AAB9
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 10:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244941AbhKIJpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 04:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243622AbhKIJpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 04:45:33 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23244C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 01:42:47 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso1790977wme.3
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 01:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fftvvpcviCHio0E7043Muy78rSgaoMH1Uvzaam7PMgM=;
        b=u/m6unjkqn4/xH5odzxDIJCsKxk0OvTtMcqkLgBd+1RWeW3soRDKOsbB0+3zBA+j2K
         9M/iWZv5WgQd6NRD1fTysBDmJZsoQF8Tyk8QuBz+G926dioe4or3IIhim5SPkv+tUir8
         0SY/b5E7te3JDguwlZiTAwvoXHll+T97JJ/b7u915Iopf8D7xH5dDyRYrqOHYC0529sf
         m4rrES2jGpf/Zz7/7QKgPjRy7LnS6agEaQpGjd79TUE5DfzWGRufAf1uwk//AvPMXFav
         OGDiWAH5Hesm9XbqHqgbWf8Y8ZezkjurZRMsCBJmbibLyAaAiEMiSsn85ZKLeXulbW41
         CR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fftvvpcviCHio0E7043Muy78rSgaoMH1Uvzaam7PMgM=;
        b=BkdEsYT/+k+2RIVubp2NhdEKhU3N5cojdr9v+kBHg1NkpS1UX+2b8WH8ahtCHzzNG2
         Y6/gg3NLqrSJYh4X+HGb2pKYlSXhEDB49aUjpOsFzzcIZMrUR/KXxuGCwftuVYPylrBW
         P807FqPnn8KimZWUOVvJFUukc4KsSZbPjgQ3z3fsQHicyCir6IIgMuU2psrpaL4eVciI
         89HgdVhXOLdH1TBWdP9/SmMQvf6z25QrPkBgP/eN85uXwFsFZi+akpEtWqDiQncppvnW
         7xdBqUY6jZxBfgqLrm6TDS82x3GYk5Gch6rFneKq6hR18tXjJYOn63sCTDh5c/7EXqqT
         NxgQ==
X-Gm-Message-State: AOAM5308VhzqEHYmadxe3j2h9ce1YQLpOEubCjGkfE+GIebh0FVZNUu4
        gpN/pZLoXUOQ7Y+T4peP6zseNQ==
X-Google-Smtp-Source: ABdhPJyFDvxCr1rVFAoM0WqTY+/TR7gYXEbCKz8KxNcwxJ2V7Uh+6WCznHa9ejmOek3j5XCQZ0m/gA==
X-Received: by 2002:a05:600c:4149:: with SMTP id h9mr4052647wmm.100.1636450965690;
        Tue, 09 Nov 2021 01:42:45 -0800 (PST)
Received: from localhost.localdomain ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id l18sm20224726wrt.81.2021.11.09.01.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 01:42:45 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 2/2] usb: hso: fix error handling code of hso_create_net_device
Date:   Tue,  9 Nov 2021 09:42:37 +0000
Message-Id: <20211109094237.174741-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211109094237.174741-1-lee.jones@linaro.org>
References: <20211109094237.174741-1-lee.jones@linaro.org>
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
index fa3f1b8700aa8..b35a887ba5944 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2522,7 +2522,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2535,13 +2535,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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
@@ -2551,21 +2551,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_urb_pool[i]) {
 			dev_err(&interface->dev, "Could not allocate rx urb\n");
-			goto exit;
+			goto err_mux_bulk_rx;
 		}
 		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
 							   GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_buf_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_urb) {
 		dev_err(&interface->dev, "Could not allocate tx urb\n");
-		goto exit;
+		goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_buf)
-		goto exit;
+		goto err_free_tx_urb;
 
 	add_net_device(hso_dev);
 
@@ -2573,7 +2573,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2581,8 +2581,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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

