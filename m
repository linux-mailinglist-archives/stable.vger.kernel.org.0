Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8853A6CC534
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjC1PMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjC1PMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF4CA39
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1409E61856
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C10C433EF;
        Tue, 28 Mar 2023 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016238;
        bh=6sxIN8ClML2VM3JBt6M/xEhoXDJk8KscwYmO6E5DcZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBGRkU/YdUQlgKEVoJExB+Yf7xPRvv3oM72fkI+Fs06kqO5S612hQOfG2tVr6jtep
         qMINEGQXJ/ZzOLs0QRT+/lohi9yPbnUmGBIawdKQxtJejHud5zDPDOL2SAZqPHPfqN
         fhu1GBbXWrM0LnBPpGu9g4cp5MzFqIuiQb8LmwIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Yang <xu.yang_2@nxp.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 115/146] usb: typec: tcpm: fix warning when handle discover_identity message
Date:   Tue, 28 Mar 2023 16:43:24 +0200
Message-Id: <20230328142607.444335484@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit abfc4fa28f0160df61c7149567da4f6494dfb488 upstream.

Since both source and sink device can send discover_identity message in
PD3, kernel may dump below warning:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 169 at drivers/usb/typec/tcpm/tcpm.c:1446 tcpm_queue_vdm+0xe0/0xf0
Modules linked in:
CPU: 0 PID: 169 Comm: 1-0050 Not tainted 6.1.1-00038-g6a3c36cf1da2-dirty #567
Hardware name: NXP i.MX8MPlus EVK board (DT)
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : tcpm_queue_vdm+0xe0/0xf0
lr : tcpm_queue_vdm+0x2c/0xf0
sp : ffff80000c19bcd0
x29: ffff80000c19bcd0 x28: 0000000000000001 x27: ffff0000d11c8ab8
x26: ffff0000d11cc000 x25: 0000000000000000 x24: 00000000ff008081
x23: 0000000000000001 x22: 00000000ff00a081 x21: ffff80000c19bdbc
x20: 0000000000000000 x19: ffff0000d11c8080 x18: ffffffffffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: ffff0000d716f580
x14: 0000000000000001 x13: ffff0000d716f507 x12: 0000000000000001
x11: 0000000000000000 x10: 0000000000000020 x9 : 00000000000ee098
x8 : 00000000ffffffff x7 : 000000000000001c x6 : ffff0000d716f580
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : ffff80000c19bdbc x1 : 00000000ff00a081 x0 : 0000000000000004
Call trace:
tcpm_queue_vdm+0xe0/0xf0
tcpm_pd_rx_handler+0x340/0x1ab0
kthread_worker_fn+0xcc/0x18c
kthread+0x10c/0x110
ret_from_fork+0x10/0x20
---[ end trace 0000000000000000 ]---

Below sequences may trigger this warning:

tcpm_send_discover_work(work)
  tcpm_send_vdm(port, USB_SID_PD, CMD_DISCOVER_IDENT, NULL, 0);
   tcpm_queue_vdm(port, header, data, count);
    port->vdm_state = VDM_STATE_READY;

vdm_state_machine_work(work);
			<-- received discover_identity from partner
 vdm_run_state_machine(port);
  port->vdm_state = VDM_STATE_SEND_MESSAGE;
   mod_vdm_delayed_work(port, x);

tcpm_pd_rx_handler(work);
 tcpm_pd_data_request(port, msg);
  tcpm_handle_vdm_request(port, msg->payload, cnt);
   tcpm_queue_vdm(port, response[0], &response[1], rlen - 1);
--> WARN_ON(port->vdm_state > VDM_STATE_DONE);

For this case, the state machine could still send out discover
identity message later if we skip current discover_identity message.
So we should handle the received message firstly and override the pending
discover_identity message without warning in this case. Then, a delayed
send_discover work will send discover_identity message again.

Fixes: e00943e91678 ("usb: typec: tcpm: PD3.0 sinks can send Discover Identity even in device mode")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230216031515.4151117-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1428,10 +1428,18 @@ static int tcpm_ams_start(struct tcpm_po
 static void tcpm_queue_vdm(struct tcpm_port *port, const u32 header,
 			   const u32 *data, int cnt)
 {
+	u32 vdo_hdr = port->vdo_data[0];
+
 	WARN_ON(!mutex_is_locked(&port->lock));
 
-	/* Make sure we are not still processing a previous VDM packet */
-	WARN_ON(port->vdm_state > VDM_STATE_DONE);
+	/* If is sending discover_identity, handle received message first */
+	if (PD_VDO_SVDM(vdo_hdr) && PD_VDO_CMD(vdo_hdr) == CMD_DISCOVER_IDENT) {
+		port->send_discover = true;
+		mod_send_discover_delayed_work(port, SEND_DISCOVER_RETRY_MS);
+	} else {
+		/* Make sure we are not still processing a previous VDM packet */
+		WARN_ON(port->vdm_state > VDM_STATE_DONE);
+	}
 
 	port->vdo_count = cnt + 1;
 	port->vdo_data[0] = header;
@@ -1934,11 +1942,13 @@ static void vdm_run_state_machine(struct
 			switch (PD_VDO_CMD(vdo_hdr)) {
 			case CMD_DISCOVER_IDENT:
 				res = tcpm_ams_start(port, DISCOVER_IDENTITY);
-				if (res == 0)
+				if (res == 0) {
 					port->send_discover = false;
-				else if (res == -EAGAIN)
+				} else if (res == -EAGAIN) {
+					port->vdo_data[0] = 0;
 					mod_send_discover_delayed_work(port,
 								       SEND_DISCOVER_RETRY_MS);
+				}
 				break;
 			case CMD_DISCOVER_SVID:
 				res = tcpm_ams_start(port, DISCOVER_SVIDS);
@@ -2021,6 +2031,7 @@ static void vdm_run_state_machine(struct
 			unsigned long timeout;
 
 			port->vdm_retries = 0;
+			port->vdo_data[0] = 0;
 			port->vdm_state = VDM_STATE_BUSY;
 			timeout = vdm_ready_timeout(vdo_hdr);
 			mod_vdm_delayed_work(port, timeout);


