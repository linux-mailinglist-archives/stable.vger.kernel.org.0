Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4354324B650
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbgHTKfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731343AbgHTKTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:19:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73EA20658;
        Thu, 20 Aug 2020 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918745;
        bh=He8D27RUgtVkrpdDKqvL1ZvbxJaLrXCDhhWsBSygfEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIXhx60Lg6FBQcvyXQFlkXWqT+WaHQnU8ICDqiNCLS/xhA6MoQXbU48hGmEiOU7Z1
         n3EJyiuoHYYH89w/cRH8gVrMfs85ReSiHYxmvBdCOx+0NYAGg0EQbsirSF8loEgCtg
         ROlun66XvAvRFkjnRZJrBGUJBQCT6dlg/+x5o7t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
Subject: [PATCH 4.4 051/149] usb: hso: check for return value in hso_serial_common_create()
Date:   Thu, 20 Aug 2020 11:22:08 +0200
Message-Id: <20200820092128.201332561@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit e911e99a0770f760377c263bc7bac1b1593c6147 ]

in case of an error tty_register_device_attr() returns ERR_PTR(),
add IS_ERR() check

Reported-and-tested-by: syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=67b2bd0e34f952d0321e
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2280,12 +2280,14 @@ static int hso_serial_common_create(stru
 
 	minor = get_free_serial_index();
 	if (minor < 0)
-		goto exit;
+		goto exit2;
 
 	/* register our minor number */
 	serial->parent->dev = tty_port_register_device_attr(&serial->port,
 			tty_drv, minor, &serial->parent->interface->dev,
 			serial->parent, hso_serial_dev_groups);
+	if (IS_ERR(serial->parent->dev))
+		goto exit2;
 	dev = serial->parent->dev;
 
 	/* fill in specific data for later use */
@@ -2335,6 +2337,7 @@ static int hso_serial_common_create(stru
 	return 0;
 exit:
 	hso_serial_tty_unregister(serial);
+exit2:
 	hso_serial_common_free(serial);
 	return -1;
 }


