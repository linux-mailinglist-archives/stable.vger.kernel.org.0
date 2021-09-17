Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3040F6D5
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242376AbhIQLv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242143AbhIQLv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 197C761246;
        Fri, 17 Sep 2021 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631879404;
        bh=jM5pVI7ArVyFMw54FNFbCHZZ1zuQegYsQ5VqBu/O4W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paVYw5QIoeE0qULSIDqORHEkt+mRy2Bt3QZL7D8QVXaBroyuCcaJynr6CFMyF0WP2
         iXSEXR4HoKXre1q0lLcUTweB06b4ddmy/rQg9KMK23SXUHxf2MgTuez0YP3MWVS6oU
         H1Z9PSL1zxWYSOdXBHtzLe5FuJdZrMpcfpd5eQljT4I//k/f/+lFmVHdbbpKx08nlV
         nLmmPZjb4gShMaKHqADopOVswYaPXZP5lg1x/VUY929+c+1HfRf9H239yLv8FmtpZG
         lQJXfgDq9yzNBYzSgbZviQHXu9sLrtMovlX/GtsDFz/Ccd6OJspZIhCOy3TcDhnQHB
         nRe9uAnfzUGcw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRCNZ-0001RP-Ki; Fri, 17 Sep 2021 13:50:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/6] ipack: ipoctal: fix stack information leak
Date:   Fri, 17 Sep 2021 13:46:17 +0200
Message-Id: <20210917114622.5412-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917114622.5412-1-johan@kernel.org>
References: <20210917114622.5412-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index c14e65a5d38f..c62fec75987c 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -264,7 +264,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	int res;
 	int i;
 	struct tty_driver *tty;
-	char name[20];
 	struct ipoctal_channel *channel;
 	struct ipack_region *region;
 	void __iomem *addr;
@@ -355,8 +354,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
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
@@ -371,8 +373,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	res = tty_register_driver(tty);
 	if (res) {
 		dev_err(&ipoctal->dev->dev, "Can't register tty driver.\n");
-		tty_driver_kref_put(tty);
-		return res;
+		goto err_free_name;
 	}
 
 	/* Save struct tty_driver for use it when uninstalling the device */
@@ -409,6 +410,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 				       ipoctal_irq_handler, ipoctal);
 
 	return 0;
+
+err_free_name:
+	kfree(tty->name);
+err_put_driver:
+	tty_driver_kref_put(tty);
+
+	return res;
 }
 
 static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
@@ -696,6 +704,7 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	}
 
 	tty_unregister_driver(ipoctal->tty_drv);
+	kfree(ipoctal->tty_drv->name);
 	tty_driver_kref_put(ipoctal->tty_drv);
 	kfree(ipoctal);
 }
-- 
2.32.0

