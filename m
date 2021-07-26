Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25273D6237
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhGZPfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhGZPeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDECF6056B;
        Mon, 26 Jul 2021 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316067;
        bh=MIRtdigQjRd10/NGJnkLyqs1dc1KSlw2sbuL0WPp5i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARFV8N1igqQpLinFQYRpm4e+6QZxjZ+t7ruZGfgJ+cysNgCK1fM/dKltRCtD2KyaQ
         jqEQkdgR2AWQvqXedEenJbEe8LEZD6kryv+ya0VvcmgefYmjNRCdlMxDooEx3urwxR
         5qYKm8AnFYnAQ3DfU+h5I1tSwh7W1hhjaC4vP0V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>
Subject: [PATCH 5.13 174/223] usb: typec: stusb160x: register role switch before interrupt registration
Date:   Mon, 26 Jul 2021 17:39:26 +0200
Message-Id: <20210726153851.887066028@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit 86762ad4abcc549deb7a155c8e5e961b9755bcf0 upstream.

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
 drivers/usb/typec/stusb160x.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/stusb160x.c
+++ b/drivers/usb/typec/stusb160x.c
@@ -739,10 +739,6 @@ static int stusb160x_probe(struct i2c_cl
 	typec_set_pwr_opmode(chip->port, chip->pwr_opmode);
 
 	if (client->irq) {
-		ret = stusb160x_irq_init(chip, client->irq);
-		if (ret)
-			goto port_unregister;
-
 		chip->role_sw = fwnode_usb_role_switch_get(fwnode);
 		if (IS_ERR(chip->role_sw)) {
 			ret = PTR_ERR(chip->role_sw);
@@ -752,6 +748,10 @@ static int stusb160x_probe(struct i2c_cl
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
@@ -775,6 +775,9 @@ static int stusb160x_probe(struct i2c_cl
 
 	return 0;
 
+role_sw_put:
+	if (chip->role_sw)
+		usb_role_switch_put(chip->role_sw);
 port_unregister:
 	typec_unregister_port(chip->port);
 all_reg_disable:


