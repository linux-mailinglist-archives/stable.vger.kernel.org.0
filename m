Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD22272E3E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgIUQr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727484AbgIUQr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7734C238A1;
        Mon, 21 Sep 2020 16:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706845;
        bh=TQ724LlbAfBjI8c191UgL/YAyZM3Yniz52KK9LyFGSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyHRmbmSf5sbMNKdA1NexSw62wwh9EbV+m2G3ySTXnVcdCTH89/Kw5rbflQWBNOlk
         1VA00DpUZW/Y4VyxXOhS09/PsoaQw/vETFIlFrs7xtHEy/OKf4ReRhZSc/AbdHJA/+
         D0I5N1Rf8esMpeEqn3RIfcQNJ5kcSYMlfW47TxNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zwane Mwaikambo <zwanem@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.8 090/118] usb: typec: ucsi: Prevent mode overrun
Date:   Mon, 21 Sep 2020 18:28:22 +0200
Message-Id: <20200921162040.534036103@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
@@ -216,14 +216,18 @@ void ucsi_altmode_update_active(struct u
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
@@ -258,8 +262,11 @@ static int ucsi_register_altmode(struct
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
@@ -292,8 +299,11 @@ static int ucsi_register_altmode(struct
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


