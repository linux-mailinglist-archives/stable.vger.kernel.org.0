Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BB640F6FA
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 14:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbhIQMBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 08:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242509AbhIQMBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 08:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457A7611C8;
        Fri, 17 Sep 2021 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631880013;
        bh=2yPmJ42W5A7xKKMjI/J74HKQmoVcMojtw2NU/P8DpZo=;
        h=From:To:Cc:Subject:Date:From;
        b=hgq4gtSYEsfHTC4iyFbYw7TicgDaS5lBEky9vpyce7XrcTSyjQMoRkON9tUxGVSZK
         0KNiHBxBlAQW7kK7e0E5PNh4z35cSJgf/RVM01uYjcop7rKzMrfAUrkOiLcZWonRst
         auiu/ZQjbPHMCaJGbQ8LwMJq11PmxWU3y9FUzk1yY//pDVMSLIobdOmr0oY0V/MrFL
         ibiNPlNjXAkjv0Cs7hHhwWbiN2of9iu+FzN4AwCj1eReODBafzzPm0vxdvEu9tZ1dX
         wrF6e4Gi4f2NdhXriwSSs4xsWjtc7NhGqqwXWmbR1RfOON+VZ1ahpqxrlGBzXoAJOr
         MRdNQoYKyKV0A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRCXO-0001X3-1J; Fri, 17 Sep 2021 14:00:14 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Scott Branden <scott.branden@broadcom.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] misc: bcm-vk: fix tty registration race
Date:   Fri, 17 Sep 2021 13:57:36 +0200
Message-Id: <20210917115736.5816-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to set the tty class-device driver data before registering the
tty to avoid having a racing open() dereference a NULL pointer.

Fixes: 91ca10d6fa07 ("misc: bcm-vk: add ttyVK support")
Cc: stable@vger.kernel.org      # 5.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_tty.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_tty.c b/drivers/misc/bcm-vk/bcm_vk_tty.c
index 1b6076a89ca6..6669625ba4c8 100644
--- a/drivers/misc/bcm-vk/bcm_vk_tty.c
+++ b/drivers/misc/bcm-vk/bcm_vk_tty.c
@@ -267,13 +267,13 @@ int bcm_vk_tty_init(struct bcm_vk *vk, char *name)
 		struct device *tty_dev;
 
 		tty_port_init(&vk->tty[i].port);
-		tty_dev = tty_port_register_device(&vk->tty[i].port, tty_drv,
-						   i, dev);
+		tty_dev = tty_port_register_device_attr(&vk->tty[i].port,
+							tty_drv, i, dev, vk,
+							NULL);
 		if (IS_ERR(tty_dev)) {
 			err = PTR_ERR(tty_dev);
 			goto unwind;
 		}
-		dev_set_drvdata(tty_dev, vk);
 		vk->tty[i].is_opened = false;
 	}
 
-- 
2.32.0

