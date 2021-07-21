Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4583D0995
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhGUGg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 02:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234526AbhGUGgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 02:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A219860232;
        Wed, 21 Jul 2021 07:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626851817;
        bh=Pb+4tSpYWfZKPRJBA96GwYoW0o3klM7b3wLYBof2orw=;
        h=Subject:To:From:Date:From;
        b=SIHe3OW1DCSBiss24Yvn3SP+BWJTE8UARLH5uw/5eJmWGf+S1MP2km7m1lJqMXLPJ
         04yY8UAVCObY36Mpc4ebRRl0Y/4rLput1ULyu2T8Q3NfiW9mF/pz1oDUCUlqROQKYe
         INPo1V6uhUIylz5/m25l70gfcgqsvNPwmgYhzots=
Subject: patch "usb: typec: stusb160x: register role switch before interrupt" added to usb-linus
To:     amelie.delaunay@foss.st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:16:54 +0200
Message-ID: <1626851814161161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: stusb160x: register role switch before interrupt

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 86762ad4abcc549deb7a155c8e5e961b9755bcf0 Mon Sep 17 00:00:00 2001
From: Amelie Delaunay <amelie.delaunay@foss.st.com>
Date: Fri, 16 Jul 2021 14:07:17 +0200
Subject: usb: typec: stusb160x: register role switch before interrupt
 registration

During interrupt registration, attach state is checked. If attached,
then the Type-C state is updated with typec_set_xxx functions and role
switch is set with usb_role_switch_set_role().

If the usb_role_switch parameter is error or null, the function simply
returns 0.

So, to update usb_role_switch role if a device is attached before the
irq is registered, usb_role_switch must be registered before irq
registration.

Fixes: da0cb6310094 ("usb: typec: add support for STUSB160x Type-C controller family")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20210716120718.20398-2-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/stusb160x.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/stusb160x.c b/drivers/usb/typec/stusb160x.c
index 6eaeba9b096e..3d3848e7c2c2 100644
--- a/drivers/usb/typec/stusb160x.c
+++ b/drivers/usb/typec/stusb160x.c
@@ -739,10 +739,6 @@ static int stusb160x_probe(struct i2c_client *client)
 	typec_set_pwr_opmode(chip->port, chip->pwr_opmode);
 
 	if (client->irq) {
-		ret = stusb160x_irq_init(chip, client->irq);
-		if (ret)
-			goto port_unregister;
-
 		chip->role_sw = fwnode_usb_role_switch_get(fwnode);
 		if (IS_ERR(chip->role_sw)) {
 			ret = PTR_ERR(chip->role_sw);
@@ -752,6 +748,10 @@ static int stusb160x_probe(struct i2c_client *client)
 					ret);
 			goto port_unregister;
 		}
+
+		ret = stusb160x_irq_init(chip, client->irq);
+		if (ret)
+			goto role_sw_put;
 	} else {
 		/*
 		 * If Source or Dual power role, need to enable VDD supply
@@ -775,6 +775,9 @@ static int stusb160x_probe(struct i2c_client *client)
 
 	return 0;
 
+role_sw_put:
+	if (chip->role_sw)
+		usb_role_switch_put(chip->role_sw);
 port_unregister:
 	typec_unregister_port(chip->port);
 all_reg_disable:
-- 
2.32.0


