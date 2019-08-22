Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A9399D69
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391672AbfHVRXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391556AbfHVRWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:49 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AC74233FE;
        Thu, 22 Aug 2019 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494568;
        bh=6KUXWNDA8/+Pde2MDNRP2/6V1yRx83M8Ry5DX+w5b6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8T9IeOEzdB5bcmc3C1nto/O6YpadIn40vq5p+7G1WD+hvjx+lkyveEj86TTuyUc8
         KUexa4nen13A5BORvuI0PQJ55NI0vWMaOiaJPCatfIiPOInhk9ghXooZGIx5SIgSzE
         dMCoNmAKsnpqXtQDG4nh38lDxE7kI4Ttq5xTx+iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+1b2449b7b5dc240d107a@syzkaller.appspotmail.com
Subject: [PATCH 4.4 58/78] usb: cdc-acm: make sure a refcount is taken early enough
Date:   Thu, 22 Aug 2019 10:19:02 -0700
Message-Id: <20190822171833.717553055@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit c52873e5a1ef72f845526d9f6a50704433f9c625 upstream.

destroy() will decrement the refcount on the interface, so that
it needs to be taken so early that it never undercounts.

Fixes: 7fb57a019f94e ("USB: cdc-acm: Fix potential deadlock (lockdep warning)")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+1b2449b7b5dc240d107a@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190808142119.7998-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1319,13 +1319,6 @@ made_compressed_probe:
 	if (acm == NULL)
 		goto alloc_fail;
 
-	minor = acm_alloc_minor(acm);
-	if (minor < 0) {
-		dev_err(&intf->dev, "no more free acm devices\n");
-		kfree(acm);
-		return -ENODEV;
-	}
-
 	ctrlsize = usb_endpoint_maxp(epctrl);
 	readsize = usb_endpoint_maxp(epread) *
 				(quirks == SINGLE_RX_URB ? 1 : 2);
@@ -1333,6 +1326,16 @@ made_compressed_probe:
 	acm->writesize = usb_endpoint_maxp(epwrite) * 20;
 	acm->control = control_interface;
 	acm->data = data_interface;
+
+	usb_get_intf(acm->control); /* undone in destruct() */
+
+	minor = acm_alloc_minor(acm);
+	if (minor < 0) {
+		dev_err(&intf->dev, "no more free acm devices\n");
+		kfree(acm);
+		return -ENODEV;
+	}
+
 	acm->minor = minor;
 	acm->dev = usb_dev;
 	acm->ctrl_caps = ac_management_function;
@@ -1474,7 +1477,6 @@ skip_countries:
 	usb_driver_claim_interface(&acm_driver, data_interface, acm);
 	usb_set_intfdata(data_interface, acm);
 
-	usb_get_intf(control_interface);
 	tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
 	if (IS_ERR(tty_dev)) {


