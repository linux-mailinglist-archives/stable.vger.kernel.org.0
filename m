Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD473F0588
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 16:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhHROAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 10:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238445AbhHROAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 10:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFCBF60238;
        Wed, 18 Aug 2021 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629295184;
        bh=/hiOLlG8NUinBJgNN2g1i2R+eLAEkHw51nr6y3eN/wU=;
        h=Subject:To:From:Date:From;
        b=VarHn3ehoAWHfYlLXHTMOvi7cypsn/UnCOIxl76UzpGvUVtoyzWAYZay7i2oSYdFe
         E14QflsJ0CnUs8UzdPqCwLNTMPKMY19r3wh9TTvWpvpqcmhFQ4oL+aDrlO8VcegEUx
         1ANDkYpJn2LSvaglXV7AwOm6KHEI9xtMkWLVxJvQ=
Subject: patch "usb: typec: tcpm: Fix VDMs sometimes not being forwarded to alt-mode" added to usb-linus
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, kyletso@google.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Aug 2021 15:59:41 +0200
Message-ID: <162929518165162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Fix VDMs sometimes not being forwarded to alt-mode

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5571ea3117ca22849072adb58074fb5a2fd12c00 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 16 Aug 2021 17:46:32 +0200
Subject: usb: typec: tcpm: Fix VDMs sometimes not being forwarded to alt-mode
 drivers

Commit a20dcf53ea98 ("usb: typec: tcpm: Respond Not_Supported if no
snk_vdo"), stops tcpm_pd_data_request() calling tcpm_handle_vdm_request()
when port->nr_snk_vdo is not set. But the VDM might be intended for an
altmode-driver, in which case nr_snk_vdo does not matter.

This change breaks the forwarding of connector hotplug (HPD) events
for displayport altmode on devices which don't set nr_snk_vdo.

tcpm_pd_data_request() is the only caller of tcpm_handle_vdm_request(),
so we can move the nr_snk_vdo check to inside it, at which point we
have already looked up the altmode device so we can check for this too.

Doing this check here also ensures that vdm_state gets set to
VDM_STATE_DONE if it was VDM_STATE_BUSY, even if we end up with
responding with PD_MSG_CTRL_NOT_SUPP later.

Note that tcpm_handle_vdm_request() was already sending
PD_MSG_CTRL_NOT_SUPP in some circumstances, after moving the nr_snk_vdo
check the same error-path is now taken when that check fails. So that
we have only one error-path for this and not two. Replace the
tcpm_queue_message(PD_MSG_CTRL_NOT_SUPP) used by the existing error-path
with the more robust tcpm_pd_handle_msg() from the (now removed) second
error-path.

Fixes: a20dcf53ea98 ("usb: typec: tcpm: Respond Not_Supported if no snk_vdo")
Cc: stable <stable@vger.kernel.org>
Cc: Kyle Tso <kyletso@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Kyle Tso <kyletso@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210816154632.381968-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b9bb63d749ec..f4079b5cb26d 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1737,6 +1737,10 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 	return rlen;
 }
 
+static void tcpm_pd_handle_msg(struct tcpm_port *port,
+			       enum pd_msg_request message,
+			       enum tcpm_ams ams);
+
 static void tcpm_handle_vdm_request(struct tcpm_port *port,
 				    const __le32 *payload, int cnt)
 {
@@ -1764,11 +1768,11 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 		port->vdm_state = VDM_STATE_DONE;
 	}
 
-	if (PD_VDO_SVDM(p[0])) {
+	if (PD_VDO_SVDM(p[0]) && (adev || tcpm_vdm_ams(port) || port->nr_snk_vdo)) {
 		rlen = tcpm_pd_svdm(port, adev, p, cnt, response, &adev_action);
 	} else {
 		if (port->negotiated_rev >= PD_REV30)
-			tcpm_queue_message(port, PD_MSG_CTRL_NOT_SUPP);
+			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 	}
 
 	/*
@@ -2471,10 +2475,7 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 					   NONE_AMS);
 		break;
 	case PD_DATA_VENDOR_DEF:
-		if (tcpm_vdm_ams(port) || port->nr_snk_vdo)
-			tcpm_handle_vdm_request(port, msg->payload, cnt);
-		else if (port->negotiated_rev > PD_REV20)
-			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
+		tcpm_handle_vdm_request(port, msg->payload, cnt);
 		break;
 	case PD_DATA_BIST:
 		port->bist_request = le32_to_cpu(msg->payload[0]);
-- 
2.32.0


