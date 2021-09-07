Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8836540250D
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 10:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242299AbhIGIZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 04:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240588AbhIGIZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 04:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3B86108E;
        Tue,  7 Sep 2021 08:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631003071;
        bh=tf0hsMvTGyH1kJjWg2WPZff+DOucx8mXURT8WBb/fQg=;
        h=From:To:Cc:Subject:Date:From;
        b=LH+KsWArqUzs/v9H+FeMx91h00ZkSGRndvcY8Oo/P8GmDYeMFTmQhkkMBr7nK6ylo
         cxqsdhB9VIXMmh8FCynof29lZZ6ePGuGzytngtNSmwqmnypmogMhreMVgKm75v06k+
         WTPtVDSIBTJA1ZHJbZ/a4cOXD3KU1r6qVv6ox19TSFVtdr/bxQkkmSATlV5jwKe4Gu
         tH1t7HzV3yOWMqb9jZeBhqAEXvWEXdjWrcvtGqCAcsr1T26bAzroSr7/RrC5l+Vws8
         HcOuFQfnLfU3izK6TunDyGY/oPePIeqb+EvxErj+Dsag/UciaEm5xT+gv+xit/aCdD
         js1pCXktie/6Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mNWOw-00022B-MA; Tue, 07 Sep 2021 10:24:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH v2] USB: cdc-acm: fix minor-number release
Date:   Tue,  7 Sep 2021 10:23:18 +0200
Message-Id: <20210907082318.7757-1-johan@kernel.org>
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

Changes in v2
 - add a dedicated define for the invalid minor number (Oliver)


 drivers/usb/class/cdc-acm.c | 7 +++++--
 drivers/usb/class/cdc-acm.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 4895325b16a4..5b90d0979c60 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -726,7 +726,8 @@ static void acm_port_destruct(struct tty_port *port)
 {
 	struct acm *acm = container_of(port, struct acm, port);
 
-	acm_release_minor(acm);
+	if (acm->minor != ACM_MINOR_INVALID)
+		acm_release_minor(acm);
 	usb_put_intf(acm->control);
 	kfree(acm->country_codes);
 	kfree(acm);
@@ -1323,8 +1324,10 @@ static int acm_probe(struct usb_interface *intf,
 	usb_get_intf(acm->control); /* undone in destruct() */
 
 	minor = acm_alloc_minor(acm);
-	if (minor < 0)
+	if (minor < 0) {
+		acm->minor = ACM_MINOR_INVALID;
 		goto err_put_port;
+	}
 
 	acm->minor = minor;
 	acm->dev = usb_dev;
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index 8aef5eb769a0..3aa7f0a3ad71 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -22,6 +22,8 @@
 #define ACM_TTY_MAJOR		166
 #define ACM_TTY_MINORS		256
 
+#define ACM_MINOR_INVALID	ACM_TTY_MINORS
+
 /*
  * Requests.
  */
-- 
2.32.0

