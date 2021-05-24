Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4943838E730
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 15:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhEXNQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 09:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232483AbhEXNQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 09:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B506861260;
        Mon, 24 May 2021 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621862087;
        bh=ErXCnsou/FZKZVgLgLLBodNkDwpHwFzUvtXSOtcKm8c=;
        h=Subject:To:From:Date:From;
        b=lSRzXVO/KYyvii3JN3Fe4scVUVVCkcfY/lcsnKu6kNWQGMRIHwMj3nNEQlWW/5k66
         uIivM03phIITNWo/JpQ2OquQlX1lfZNwgQrGG5XPZJBEvFy5QyjlNH76lSsDT4jFjy
         t3q0hl3sFb71P/8bKUHV1RlSOo/kLkHmHH371R78=
Subject: patch "usb: typec: tcpm: Respond Not_Supported if no snk_vdo" added to usb-linus
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 15:14:37 +0200
Message-ID: <162186207715525@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Respond Not_Supported if no snk_vdo

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a20dcf53ea9836387b229c4878f9559cf1b55b71 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Sun, 23 May 2021 09:58:55 +0800
Subject: usb: typec: tcpm: Respond Not_Supported if no snk_vdo

If snk_vdo is not populated from fwnode, it implies the port does not
support responding to SVDM commands. Not_Supported Message shall be sent
if the contract is in PD3. And for PD2, the port shall ignore the
commands.

Fixes: 193a68011fdc ("staging: typec: tcpm: Respond to Discover Identity commands")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210523015855.1785484-3-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 6ea5df3782cf..9ce8c9af4da5 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2430,7 +2430,10 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 					   NONE_AMS);
 		break;
 	case PD_DATA_VENDOR_DEF:
-		tcpm_handle_vdm_request(port, msg->payload, cnt);
+		if (tcpm_vdm_ams(port) || port->nr_snk_vdo)
+			tcpm_handle_vdm_request(port, msg->payload, cnt);
+		else if (port->negotiated_rev > PD_REV20)
+			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 		break;
 	case PD_DATA_BIST:
 		port->bist_request = le32_to_cpu(msg->payload[0]);
-- 
2.31.1


