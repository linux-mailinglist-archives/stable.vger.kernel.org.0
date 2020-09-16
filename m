Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0442D26C001
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIPJAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:00:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:59022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbgIPJAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 05:00:41 -0400
IronPort-SDR: YGmY+kJ7tZG5HPV8VYAU+whTYQmGvUWhUY+ENi4PfiOhdAK/ky5FHExp3/Vdx/r4B/QMUdG+Dd
 bgdbFIQVHZxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="177500635"
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="177500635"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 02:00:39 -0700
IronPort-SDR: qW+Ml2v/mo/jvkmTs2X9msRi5ehTzuASLDh2qGkoJ9WEm2dsZrxY5qTzkvtyVWhQwfSdsxQDci
 ehQaNvtcZxHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="409487543"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 16 Sep 2020 02:00:37 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Zwane Mwaikambo <zwanem@gmail.com>
Subject: [PATCH 2/2] usb: typec: ucsi: Prevent mode overrun
Date:   Wed, 16 Sep 2020 12:00:34 +0300
Message-Id: <20200916090034.25119-3-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916090034.25119-1-heikki.krogerus@linux.intel.com>
References: <20200916090034.25119-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/typec/ucsi/ucsi.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index e680fcfdee609..758b988ac518a 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -216,14 +216,18 @@ void ucsi_altmode_update_active(struct ucsi_connector *con)
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
@@ -258,8 +262,11 @@ static int ucsi_register_altmode(struct ucsi_connector *con,
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
@@ -292,8 +299,11 @@ static int ucsi_register_altmode(struct ucsi_connector *con,
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
-- 
2.28.0

