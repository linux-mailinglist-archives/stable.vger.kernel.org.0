Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFA5420B8F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhJDM6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhJDM51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01E2B61391;
        Mon,  4 Oct 2021 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352138;
        bh=wROo/nGdeyzk5+qZNFw6mmXJUM1XDXEqi8qY06qChLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0XqK0hdWMAiVUDceVpdG5EPSG0ETEwuC6ZCIj0A033Wwv+W3FvjGAU/WhHP0rkPs
         0TeD25r0RYVwtAVZcV96XsDwMtaFlA9Pw6BwuxJ7LXw51tC+ZYWlGzRxrp2Hroop58
         AQdz494Toqx98KxslHnsDYuE9KnSblslqUk5If9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 30/41] ipack: ipoctal: fix stack information leak
Date:   Mon,  4 Oct 2021 14:52:21 +0200
Message-Id: <20211004125027.529672495@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
References: <20211004125026.597501645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a89936cce87d60766a75732a9e7e25c51164f47c upstream.

The tty driver name is used also after registering the driver and must
specifically not be allocated on the stack to avoid leaking information
to user space (or triggering an oops).

Drivers should not try to encode topology information in the tty device
name but this one snuck in through staging without anyone noticing and
another driver has since copied this malpractice.

Fixing the ABI is a separate issue, but this at least plugs the security
hole.

Fixes: ba4dc61fe8c5 ("Staging: ipack: add support for IP-OCTAL mezzanine board")
Cc: stable@vger.kernel.org      # 3.5
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210917114622.5412-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/devices/ipoctal.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -269,7 +269,6 @@ static int ipoctal_inst_slot(struct ipoc
 	int res;
 	int i;
 	struct tty_driver *tty;
-	char name[20];
 	struct ipoctal_channel *channel;
 	struct ipack_region *region;
 	void __iomem *addr;
@@ -360,8 +359,11 @@ static int ipoctal_inst_slot(struct ipoc
 	/* Fill struct tty_driver with ipoctal data */
 	tty->owner = THIS_MODULE;
 	tty->driver_name = KBUILD_MODNAME;
-	sprintf(name, KBUILD_MODNAME ".%d.%d.", bus_nr, slot);
-	tty->name = name;
+	tty->name = kasprintf(GFP_KERNEL, KBUILD_MODNAME ".%d.%d.", bus_nr, slot);
+	if (!tty->name) {
+		res = -ENOMEM;
+		goto err_put_driver;
+	}
 	tty->major = 0;
 
 	tty->minor_start = 0;
@@ -377,8 +379,7 @@ static int ipoctal_inst_slot(struct ipoc
 	res = tty_register_driver(tty);
 	if (res) {
 		dev_err(&ipoctal->dev->dev, "Can't register tty driver.\n");
-		put_tty_driver(tty);
-		return res;
+		goto err_free_name;
 	}
 
 	/* Save struct tty_driver for use it when uninstalling the device */
@@ -415,6 +416,13 @@ static int ipoctal_inst_slot(struct ipoc
 				       ipoctal_irq_handler, ipoctal);
 
 	return 0;
+
+err_free_name:
+	kfree(tty->name);
+err_put_driver:
+	put_tty_driver(tty);
+
+	return res;
 }
 
 static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
@@ -704,6 +712,7 @@ static void __ipoctal_remove(struct ipoc
 	}
 
 	tty_unregister_driver(ipoctal->tty_drv);
+	kfree(ipoctal->tty_drv->name);
 	put_tty_driver(ipoctal->tty_drv);
 	kfree(ipoctal);
 }


