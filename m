Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2113CB707
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJDJHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDJHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:07:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A9620867;
        Fri,  4 Oct 2019 09:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570180023;
        bh=T18DGzqFPZ3zpux9RU9o9DrVH45PNxTFxCssQeR7Qy8=;
        h=Subject:To:From:Date:From;
        b=ap44rYIFxrwheASxsFz7lFHrLmzP94o0ftESpqmUIj2yL30wE/VClhSLkC4+LXyyF
         S14H29sxbWkVt4AIAArUqo8uahUkDVczVa0YL/V3d0Mzi0h5+whgc8WVLgVN5EtQ4F
         l0lv6pCoyDktDcWKanvgCYsJARH3CZZoFqDbMarE=
Subject: patch "usb: typec: tcpm: usb: typec: tcpm: Fix a signedness bug in" added to usb-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 11:07:00 +0200
Message-ID: <157018002097114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: usb: typec: tcpm: Fix a signedness bug in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7101949f36fc77b530b73e4c6bd0066a2740d75b Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 1 Oct 2019 15:01:17 +0300
Subject: usb: typec: tcpm: usb: typec: tcpm: Fix a signedness bug in
 tcpm_fw_get_caps()

The "port->typec_caps.data" and "port->typec_caps.type" variables are
enums and in this context GCC will treat them as an unsigned int so they
can never be less than zero.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191001120117.GA23528@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 96562744101c..5f61d9977a15 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4409,18 +4409,20 @@ static int tcpm_fw_get_caps(struct tcpm_port *port,
 	/* USB data support is optional */
 	ret = fwnode_property_read_string(fwnode, "data-role", &cap_str);
 	if (ret == 0) {
-		port->typec_caps.data = typec_find_port_data_role(cap_str);
-		if (port->typec_caps.data < 0)
-			return -EINVAL;
+		ret = typec_find_port_data_role(cap_str);
+		if (ret < 0)
+			return ret;
+		port->typec_caps.data = ret;
 	}
 
 	ret = fwnode_property_read_string(fwnode, "power-role", &cap_str);
 	if (ret < 0)
 		return ret;
 
-	port->typec_caps.type = typec_find_port_power_role(cap_str);
-	if (port->typec_caps.type < 0)
-		return -EINVAL;
+	ret = typec_find_port_power_role(cap_str);
+	if (ret < 0)
+		return ret;
+	port->typec_caps.type = ret;
 	port->port_type = port->typec_caps.type;
 
 	if (port->port_type == TYPEC_PORT_SNK)
-- 
2.23.0


