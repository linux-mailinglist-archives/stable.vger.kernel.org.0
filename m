Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6589395C5A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhEaNb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232507AbhEaN3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FA7613EF;
        Mon, 31 May 2021 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467366;
        bh=pkENjceWvvQTLhaUKmJP3HeNrQDY+i5ko6l6lM1M2HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpNGJb1A03qWvrFZAfsVIum8t5m1vA1YKx3RFoI891K9oytZ+VzXLUJhvnEfK7CZu
         cAr4G/fqTqw8HeQxFla2dewM7xwdItT69NAnSlshNPDSJMr9ijKfdGRc0clCbEznqd
         3M0XPoV9DOoVXL7CqGV1qT+WuttJoVOP0UxWJlLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.vger.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
Subject: [PATCH 4.19 039/116] net: usb: fix memory leak in smsc75xx_bind
Date:   Mon, 31 May 2021 15:13:35 +0200
Message-Id: <20210531130641.490394948@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 46a8b29c6306d8bbfd92b614ef65a47c900d8e70 upstream.

Syzbot reported memory leak in smsc75xx_bind().
The problem was is non-freed memory in case of
errors after memory allocation.

backtrace:
  [<ffffffff84245b62>] kmalloc include/linux/slab.h:556 [inline]
  [<ffffffff84245b62>] kzalloc include/linux/slab.h:686 [inline]
  [<ffffffff84245b62>] smsc75xx_bind+0x7a/0x334 drivers/net/usb/smsc75xx.c:1460
  [<ffffffff82b5b2e6>] usbnet_probe+0x3b6/0xc30 drivers/net/usb/usbnet.c:1728

Fixes: d0cad871703b ("smsc75xx: SMSC LAN75xx USB gigabit ethernet adapter driver")
Cc: stable@kernel.vger.org
Reported-and-tested-by: syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc75xx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1495,7 +1495,7 @@ static int smsc75xx_bind(struct usbnet *
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		return ret;
+		goto err;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1504,7 +1504,7 @@ static int smsc75xx_bind(struct usbnet *
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1514,6 +1514,10 @@ static int smsc75xx_bind(struct usbnet *
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 	dev->net->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	return 0;
+
+err:
+	kfree(pdata);
+	return ret;
 }
 
 static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)


