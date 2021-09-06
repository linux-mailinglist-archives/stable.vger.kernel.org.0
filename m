Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28577401B5B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbhIFMpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242143AbhIFMpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA0460EE6;
        Mon,  6 Sep 2021 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630932275;
        bh=2LXqSReT8SHF8LfIKml+aOLX7rlWLst/LYZu0lXukhc=;
        h=From:To:Cc:Subject:Date:From;
        b=OjIvZZYJAPvK97M3PpNaRASfWP7+Kp2/rLXGUbvB7ocH0/0q288viavvI91HA45EL
         aHiUIQjKJcvXh9KHxnn1Xe4XMtK7ETp3rLOqZcPktGEvuJuqkoPuCaQlbvNF/U1dt+
         whuOL84Ga1APMLmhjpod1ZXJsBC1UBsJjr8aFZdBzeDSPAsTQx1FCcZCbUSYACyEBJ
         hyxJHVTYpPBbWUCLoVexSRzgOvRHR8Q+yFQ+84y4wXi2HnOl7S4PPPwKfKDjLuCL1K
         bSaHnN0B6zgZYM0fZU4LOgtbkC1b92kQtxtnVviFTvcswBaOkrq1wqs2SW6xbN66Hh
         z56w29WXYR2MQ==
Received: from johan by xi with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mNDz3-0005ny-Rk; Mon, 06 Sep 2021 14:44:22 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH] USB: cdc-acm: fix minor-number release
Date:   Mon,  6 Sep 2021 14:43:39 +0200
Message-Id: <20210906124339.22264-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the driver runs out of minor numbers it would release minor 0 and
allow another device to claim the minor while still in use.

Fortunately, registering the tty class device of the second device would
fail (with a stack dump) due to the sysfs name collision so no memory is
leaked.

Fixes: cae2bc768d17 ("usb: cdc-acm: Decrement tty port's refcount if probe() fail")
Cc: stable@vger.kernel.org      # 4.19
Cc: Jaejoong Kim <climbbb.kim@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 4895325b16a4..5f0260bc4469 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -726,7 +726,8 @@ static void acm_port_destruct(struct tty_port *port)
 {
 	struct acm *acm = container_of(port, struct acm, port);
 
-	acm_release_minor(acm);
+	if (acm->minor != ACM_TTY_MINORS)
+		acm_release_minor(acm);
 	usb_put_intf(acm->control);
 	kfree(acm->country_codes);
 	kfree(acm);
@@ -1323,8 +1324,10 @@ static int acm_probe(struct usb_interface *intf,
 	usb_get_intf(acm->control); /* undone in destruct() */
 
 	minor = acm_alloc_minor(acm);
-	if (minor < 0)
+	if (minor < 0) {
+		acm->minor = ACM_TTY_MINORS;
 		goto err_put_port;
+	}
 
 	acm->minor = minor;
 	acm->dev = usb_dev;
-- 
2.32.0

