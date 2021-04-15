Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DABF360C4D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhDOOt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhDOOtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE20461029;
        Thu, 15 Apr 2021 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498167;
        bh=JY7Ad69Q0Oco+kIqiTjygCliXPw0MdAZkyY7fxSYPdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjYc7d+MChqvs+SZfONLRx42iwIDh5MADs4ZY6oGWwX0Tr4T2sQulUEzT/gp6nn6c
         1ahxKpzScxGzWy8RYcTaLiT2JC0aezvesFLGFa7LhsMvO/oAzNbB/aD5oDgY6mJZHN
         8VvZhDbbStauIIT6HqtvApO1OyVQTvZgnTw+z4Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 25/38] drivers: net: fix memory leak in peak_usb_create_dev
Date:   Thu, 15 Apr 2021 16:47:19 +0200
Message-Id: <20210415144414.150129194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit a0b96b4a62745397aee662670cfc2157bac03f55 upstream.

syzbot reported memory leak in peak_usb.
The problem was in case of failure after calling
->dev_init()[2] in peak_usb_create_dev()[1]. The data
allocated int dev_init() wasn't freed, so simple
->dev_free() call fix this problem.

backtrace:
    [<0000000079d6542a>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000079d6542a>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000079d6542a>] pcan_usb_fd_init+0x156/0x210 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:868   [2]
    [<00000000c09f9057>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:851 [inline] [1]
    [<00000000c09f9057>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:949

Reported-by: syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -882,7 +882,7 @@ static int peak_usb_create_dev(const str
 	if (dev->adapter->dev_set_bus) {
 		err = dev->adapter->dev_set_bus(dev, 0);
 		if (err)
-			goto lbl_unregister_candev;
+			goto adap_dev_free;
 	}
 
 	/* get device number early */
@@ -894,6 +894,10 @@ static int peak_usb_create_dev(const str
 
 	return 0;
 
+adap_dev_free:
+	if (dev->adapter->dev_free)
+		dev->adapter->dev_free(dev);
+
 lbl_unregister_candev:
 	unregister_candev(netdev);
 


