Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8458F272E9E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgIUQuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730035AbgIUQul (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13B5D235FD;
        Mon, 21 Sep 2020 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707040;
        bh=6Av8mjYW2X/CRCRu0BjDWdz8pbXAT5QtNm1VqX/K88k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3BaGWpFW/AnXs96q9R03Tx21FJ6l/Vsv9CnQMFvUdDT6ciIhWYBBtsD/5g0KIcfx
         xoM9MiqNAGW00md+L8Oo3/f8/5jMCWb0uMXL10s3q2e6cT7YEssw7E63kAOuQhWcrv
         1hffocKBzS+FzkUjFykCPQw29ZJ/HPZoyuBkk7YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zwane Mwaikambo <zwanem@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.4 55/72] usb: typec: ucsi: Prevent mode overrun
Date:   Mon, 21 Sep 2020 18:31:34 +0200
Message-Id: <20200921163124.490692254@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 386e15a650447f53de3d2d8819ce9393f31650a4 upstream.

Sometimes the embedded controller firmware does not
terminate the list of alternate modes that the partner
supports in its response to the GET_ALTERNATE_MODES command.
Instead the firmware returns the supported alternate modes
over and over again until the driver stops requesting them.

If that happens, the number of modes for each alternate mode
will exceed the maximum 6 that is defined in the USB Power
Delivery specification. Making sure that can't happen by
adding a check for it.

This fixes NULL pointer dereference that is caused by the
overrun.

Fixes: ad74b8649beaf ("usb: typec: ucsi: Preliminary support for alternate modes")
Cc: stable@vger.kernel.org
Reported-by: Zwane Mwaikambo <zwanem@gmail.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200916090034.25119-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -246,14 +246,18 @@ void ucsi_altmode_update_active(struct u
 					    con->partner_altmode[i] == altmode);
 }
 
-static u8 ucsi_altmode_next_mode(struct typec_altmode **alt, u16 svid)
+static int ucsi_altmode_next_mode(struct typec_altmode **alt, u16 svid)
 {
 	u8 mode = 1;
 	int i;
 
-	for (i = 0; alt[i]; i++)
+	for (i = 0; alt[i]; i++) {
+		if (i > MODE_DISCOVERY_MAX)
+			return -ERANGE;
+
 		if (alt[i]->svid == svid)
 			mode++;
+	}
 
 	return mode;
 }
@@ -288,8 +292,11 @@ static int ucsi_register_altmode(struct
 			goto err;
 		}
 
-		desc->mode = ucsi_altmode_next_mode(con->port_altmode,
-						    desc->svid);
+		ret = ucsi_altmode_next_mode(con->port_altmode, desc->svid);
+		if (ret < 0)
+			return ret;
+
+		desc->mode = ret;
 
 		switch (desc->svid) {
 		case USB_TYPEC_DP_SID:
@@ -315,8 +322,11 @@ static int ucsi_register_altmode(struct
 			goto err;
 		}
 
-		desc->mode = ucsi_altmode_next_mode(con->partner_altmode,
-						    desc->svid);
+		ret = ucsi_altmode_next_mode(con->partner_altmode, desc->svid);
+		if (ret < 0)
+			return ret;
+
+		desc->mode = ret;
 
 		alt = typec_partner_register_altmode(con->partner, desc);
 		if (IS_ERR(alt)) {


