Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9934369654A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjBNNqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 08:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbjBNNqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 08:46:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8444C2823B
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 05:45:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E34061638
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 13:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8E3C433D2;
        Tue, 14 Feb 2023 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676382240;
        bh=zWgDNnrCdq9JiT0eGDsAQK/R93UHFVKl3ZxsVjeonFo=;
        h=Subject:To:From:Date:From;
        b=ETZC9CEgySF/mH0CiN3rcrYU/Jf7XplVjNV0Uk4UlE28flKaUcBhaydv4AB9jgYjY
         vjUzz3R724vdYhWQiwVA/nIKxtyer8ucPuIlZ1rDd4KU1sxTSRRaUUcYD9Er90hFlM
         Zvf/t2pCPLuA+DkP41u63JD8zsoZxOTh9Oj6CO/A=
Subject: patch "usb: typec: tcpm: fix create duplicate source/sink-capabilities file" added to usb-testing
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Feb 2023 14:43:58 +0100
Message-ID: <167638223881128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: fix create duplicate source/sink-capabilities file

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f430e60b78c6359ba4cb4e521d7df7f9a0484e03 Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Tue, 14 Feb 2023 14:56:35 +0800
Subject: usb: typec: tcpm: fix create duplicate source/sink-capabilities file

The kernel will dump in the below cases:
sysfs: cannot create duplicate filename
'/devices/virtual/usb_power_delivery/pd1/source-capabilities'

1. After soft reset has completed, an Explicit Contract negotiation occurs.
The sink device will receive source capabilitys again. This will cause
a duplicate source-capabilities file be created.
2. Power swap twice on a device that is initailly sink role.

This will unregister existing capabilities when above cases occurs.

Fixes: 8203d26905ee ("usb: typec: tcpm: Register USB Power Delivery Capabilities")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230214065635.972698-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index a0d943d78580..7d8c53d96c3b 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4570,6 +4570,8 @@ static void run_state_machine(struct tcpm_port *port)
 	case SOFT_RESET:
 		port->message_id = 0;
 		port->rx_msgid = -1;
+		/* remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
 		tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
 		tcpm_ams_finish(port);
 		if (port->pwr_role == TYPEC_SOURCE) {
@@ -4589,6 +4591,8 @@ static void run_state_machine(struct tcpm_port *port)
 	case SOFT_RESET_SEND:
 		port->message_id = 0;
 		port->rx_msgid = -1;
+		/* remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
 		if (tcpm_pd_send_control(port, PD_CTRL_SOFT_RESET))
 			tcpm_set_state_cond(port, hard_reset_state(port), 0);
 		else
@@ -4718,6 +4722,8 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, SNK_STARTUP, 0);
 		break;
 	case PR_SWAP_SNK_SRC_SINK_OFF:
+		/* will be source, remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
 		/*
 		 * Prevent vbus discharge circuit from turning on during PR_SWAP
 		 * as this is not a disconnect.
-- 
2.39.1


