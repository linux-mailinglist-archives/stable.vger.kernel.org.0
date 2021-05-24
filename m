Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF2C38E72E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 15:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhEXNQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 09:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232462AbhEXNQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 09:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CAB1613AD;
        Mon, 24 May 2021 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621862078;
        bh=X6jkeLkqSu8UGSMezgHb9yzgcBj6Rp4UkK1wvlIBSXk=;
        h=Subject:To:From:Date:From;
        b=lo1NpyW+AXXYBqvknDFk7UYWGfaqm4Q1WvVdiFPg8hOarSfc1W0CsmiXhlIF26BvV
         X9FqEGBJLpmuySLnJatPXKsSxXFSX64PuPtZ43AuH9kcOD1JCB+JzvnB3FMzFsGH46
         uzlW8CUjtOm3Ii5t7GOXjIHFRJxAtTeTjsyOfBLw=
Subject: patch "usb: typec: tcpm: Properly interrupt VDM AMS" added to usb-linus
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 15:14:36 +0200
Message-ID: <162186207663142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Properly interrupt VDM AMS

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0bc3ee92880d910a1d100b73a781904f359e1f1c Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Sun, 23 May 2021 09:58:54 +0800
Subject: usb: typec: tcpm: Properly interrupt VDM AMS

When a VDM AMS is interrupted by Messages other than VDM, the AMS needs
to be finished properly. Also start a VDM AMS if receiving SVDM Commands
from the port partner to complement the functionality of tcpm_vdm_ams().

Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210523015855.1785484-2-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 8fdfd7f65ad7..6ea5df3782cf 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1550,6 +1550,8 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 			if (PD_VDO_SVDM_VER(p[0]) < svdm_version)
 				typec_partner_set_svdm_version(port->partner,
 							       PD_VDO_SVDM_VER(p[0]));
+
+			tcpm_ams_start(port, DISCOVER_IDENTITY);
 			/* 6.4.4.3.1: Only respond as UFP (device) */
 			if (port->data_role == TYPEC_DEVICE &&
 			    port->nr_snk_vdo) {
@@ -1568,14 +1570,19 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 			}
 			break;
 		case CMD_DISCOVER_SVID:
+			tcpm_ams_start(port, DISCOVER_SVIDS);
 			break;
 		case CMD_DISCOVER_MODES:
+			tcpm_ams_start(port, DISCOVER_MODES);
 			break;
 		case CMD_ENTER_MODE:
+			tcpm_ams_start(port, DFP_TO_UFP_ENTER_MODE);
 			break;
 		case CMD_EXIT_MODE:
+			tcpm_ams_start(port, DFP_TO_UFP_EXIT_MODE);
 			break;
 		case CMD_ATTENTION:
+			tcpm_ams_start(port, ATTENTION);
 			/* Attention command does not have response */
 			*adev_action = ADEV_ATTENTION;
 			return 0;
@@ -2287,6 +2294,12 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 	bool frs_enable;
 	int ret;
 
+	if (tcpm_vdm_ams(port) && type != PD_DATA_VENDOR_DEF) {
+		port->vdm_state = VDM_STATE_ERR_BUSY;
+		tcpm_ams_finish(port);
+		mod_vdm_delayed_work(port, 0);
+	}
+
 	switch (type) {
 	case PD_DATA_SOURCE_CAP:
 		for (i = 0; i < cnt; i++)
@@ -2459,6 +2472,16 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 	enum pd_ctrl_msg_type type = pd_header_type_le(msg->header);
 	enum tcpm_state next_state;
 
+	/*
+	 * Stop VDM state machine if interrupted by other Messages while NOT_SUPP is allowed in
+	 * VDM AMS if waiting for VDM responses and will be handled later.
+	 */
+	if (tcpm_vdm_ams(port) && type != PD_CTRL_NOT_SUPP && type != PD_CTRL_GOOD_CRC) {
+		port->vdm_state = VDM_STATE_ERR_BUSY;
+		tcpm_ams_finish(port);
+		mod_vdm_delayed_work(port, 0);
+	}
+
 	switch (type) {
 	case PD_CTRL_GOOD_CRC:
 	case PD_CTRL_PING:
@@ -2717,6 +2740,13 @@ static void tcpm_pd_ext_msg_request(struct tcpm_port *port,
 	enum pd_ext_msg_type type = pd_header_type_le(msg->header);
 	unsigned int data_size = pd_ext_header_data_size_le(msg->ext_msg.header);
 
+	/* stopping VDM state machine if interrupted by other Messages */
+	if (tcpm_vdm_ams(port)) {
+		port->vdm_state = VDM_STATE_ERR_BUSY;
+		tcpm_ams_finish(port);
+		mod_vdm_delayed_work(port, 0);
+	}
+
 	if (!(le16_to_cpu(msg->ext_msg.header) & PD_EXT_HDR_CHUNKED)) {
 		tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 		tcpm_log(port, "Unchunked extended messages unsupported");
-- 
2.31.1


