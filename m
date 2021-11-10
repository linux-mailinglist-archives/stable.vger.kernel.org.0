Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D52D44C7B5
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhKJSyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:54:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233519AbhKJSwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:52:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E2E76128E;
        Wed, 10 Nov 2021 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570086;
        bh=C8a3MwOrR8m+3IiuKM9vKOkETQUCWt9ErBJwNT+WfR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCVn15HlKqFQm3jkZBfiQhWMAlluWq7SdKhLKdJnAmInXDZYU6JBPJYAZGtg0xSvx
         LWFEiFJKt6tMvCwcA11fJ5GhklbSmbOccytajyePGuvYi4tgRTx3NE+TYrY+1Ompvp
         TqGq5VhqxDuvx1xXU0IONJ5docCzQxroUn9qvXkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+c55162be492189fb4f51@syzkaller.appspotmail.com
Subject: [PATCH 5.10 11/21] staging: rtl8712: fix use-after-free in rtl8712_dl_fw
Date:   Wed, 10 Nov 2021 19:43:57 +0100
Message-Id: <20211110182003.315710855@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit c052cc1a069c3e575619cf64ec427eb41176ca70 upstream.

Syzbot reported use-after-free in rtl8712_dl_fw(). The problem was in
race condition between r871xu_dev_remove() ->ndo_open() callback.

It's easy to see from crash log, that driver accesses released firmware
in ->ndo_open() callback. It may happen, since driver was releasing
firmware _before_ unregistering netdev. Fix it by moving
unregister_netdev() before cleaning up resources.

Call Trace:
...
 rtl871x_open_fw drivers/staging/rtl8712/hal_init.c:83 [inline]
 rtl8712_dl_fw+0xd95/0xe10 drivers/staging/rtl8712/hal_init.c:170
 rtl8712_hal_init drivers/staging/rtl8712/hal_init.c:330 [inline]
 rtl871x_hal_init+0xae/0x180 drivers/staging/rtl8712/hal_init.c:394
 netdev_open+0xe6/0x6c0 drivers/staging/rtl8712/os_intfs.c:380
 __dev_open+0x2bc/0x4d0 net/core/dev.c:1484

Freed by task 1306:
...
 release_firmware+0x1b/0x30 drivers/base/firmware_loader/main.c:1053
 r871xu_dev_remove+0xcc/0x2c0 drivers/staging/rtl8712/usb_intf.c:599
 usb_unbind_interface+0x1d8/0x8d0 drivers/usb/core/driver.c:458

Fixes: 8c213fa59199 ("staging: r8712u: Use asynchronous firmware loading")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+c55162be492189fb4f51@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20211019211718.26354-1-paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/usb_intf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -598,12 +598,12 @@ static void r871xu_dev_remove(struct usb
 
 	/* never exit with a firmware callback pending */
 	wait_for_completion(&padapter->rtl8712_fw_ready);
+	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
+		unregister_netdev(pnetdev); /* will call netdev_close() */
 	usb_set_intfdata(pusb_intf, NULL);
 	release_firmware(padapter->fw);
 	if (drvpriv.drv_registered)
 		padapter->surprise_removed = true;
-	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
-		unregister_netdev(pnetdev); /* will call netdev_close() */
 	r8712_flush_rwctrl_works(padapter);
 	r8712_flush_led_works(padapter);
 	udelay(1);


