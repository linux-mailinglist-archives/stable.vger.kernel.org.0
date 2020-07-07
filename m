Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5821717C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgGGPUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgGGPUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:20:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E26E20773;
        Tue,  7 Jul 2020 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135248;
        bh=j+luVCOiuymvrU9XJJwT00XGVyNwYxhXbV+YSqKKWww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7wPimwZXrdTaunEtEmISR+yMtEc++8tvOuLMDSo/5fwMAl5WbiCg4GrKT3vGt353
         fjZpHYyJIaYaRR6usW6qb8oNK4qmHL/6n1QcbZ+Hf3M7qF8MKhHtD8pWVLTWLC16e1
         iy86InFJIWXXZ8aOr83O1cfFUkdQM6HxsNPoLJy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+29dc7d4ae19b703ff947@syzkaller.appspotmail.com,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/65] usbnet: smsc95xx: Fix use-after-free after removal
Date:   Tue,  7 Jul 2020 17:16:43 +0200
Message-Id: <20200707145752.639594398@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

[ Upstream commit b835a71ef64a61383c414d6bf2896d2c0161deca ]

Syzbot reports an use-after-free in workqueue context:

BUG: KASAN: use-after-free in mutex_unlock+0x19/0x40 kernel/locking/mutex.c:737
 mutex_unlock+0x19/0x40 kernel/locking/mutex.c:737
 __smsc95xx_mdio_read drivers/net/usb/smsc95xx.c:217 [inline]
 smsc95xx_mdio_read+0x583/0x870 drivers/net/usb/smsc95xx.c:278
 check_carrier+0xd1/0x2e0 drivers/net/usb/smsc95xx.c:644
 process_one_work+0x777/0xf90 kernel/workqueue.c:2274
 worker_thread+0xa8f/0x1430 kernel/workqueue.c:2420
 kthread+0x2df/0x300 kernel/kthread.c:255

It looks like that smsc95xx_unbind() is freeing the structures that are
still in use by the concurrently running workqueue callback. Thus switch
to using cancel_delayed_work_sync() to ensure the work callback really
is no longer active.

Reported-by: syzbot+29dc7d4ae19b703ff947@syzkaller.appspotmail.com
Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 355be77f42418..3cf4dc3433f91 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1324,7 +1324,7 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
 
 	if (pdata) {
-		cancel_delayed_work(&pdata->carrier_check);
+		cancel_delayed_work_sync(&pdata->carrier_check);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
 		pdata = NULL;
-- 
2.25.1



