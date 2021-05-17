Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38338318F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbhEQOhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240870AbhEQOfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F213613F3;
        Mon, 17 May 2021 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261022;
        bh=2UKzc0xB3KTC9iJdCW2P06kv5tZ6MZEPO7aFMw2lcOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKmUaImW5jkNtUJHf2q+JTRoIvYqXjRsdrb8UoPvdoUQoFu3z/86vhN7l7FD3ES74
         H2kuQtFvsTu4urFd28TJtHlSZr3oQBTuu/oMCfxfoEM5VligM4fgn9vjQCrGJdbSLd
         2S5Bl6vMSrz+iSEPZrBJLACow0HvP5V6pABvv0zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Kyle Tso <kyletso@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 292/363] usb: typec: tcpm: Fix wrong handling for Not_Supported in VDM AMS
Date:   Mon, 17 May 2021 16:02:38 +0200
Message-Id: <20210517140312.468598749@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

[ Upstream commit f1fbd950b59b67bc5c202216c8e1c6ca8c99a3b4 ]

Not_Supported Message is acceptable in VDM AMS. Redirect the VDM state
machine to VDM_STATE_DONE when receiving Not_Supported and finish the
VDM AMS.

Also, after the loop in vdm_state_machine_work, add more conditions of
VDM states to clear the vdm_sm_running flag because those are all
stopping states when leaving the loop.

In addition, finish the VDM AMS if the port partner responds BUSY.

Fixes: 8dea75e11380 ("usb: typec: tcpm: Protocol Error handling")
Fixes: 8d3a0578ad1a ("usb: typec: tcpm: Respond Wait if VDM state machine is running")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210507062300.1945009-3-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 1a086ba254d2..7386f3e2cb69 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1877,7 +1877,6 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 			}
 
 			if (res < 0) {
-				port->vdm_sm_running = false;
 				return;
 			}
 		}
@@ -1893,6 +1892,7 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 		port->vdo_data[0] = port->vdo_retry;
 		port->vdo_count = 1;
 		port->vdm_state = VDM_STATE_READY;
+		tcpm_ams_finish(port);
 		break;
 	case VDM_STATE_BUSY:
 		port->vdm_state = VDM_STATE_ERR_TMOUT;
@@ -1958,7 +1958,7 @@ static void vdm_state_machine_work(struct kthread_work *work)
 		 port->vdm_state != VDM_STATE_BUSY &&
 		 port->vdm_state != VDM_STATE_SEND_MESSAGE);
 
-	if (port->vdm_state == VDM_STATE_ERR_TMOUT)
+	if (port->vdm_state < VDM_STATE_READY)
 		port->vdm_sm_running = false;
 
 	mutex_unlock(&port->lock);
@@ -2549,6 +2549,16 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			port->sink_cap_done = true;
 			tcpm_set_state(port, ready_state(port), 0);
 			break;
+		case SRC_READY:
+		case SNK_READY:
+			if (port->vdm_state > VDM_STATE_READY) {
+				port->vdm_state = VDM_STATE_DONE;
+				if (tcpm_vdm_ams(port))
+					tcpm_ams_finish(port);
+				mod_vdm_delayed_work(port, 0);
+				break;
+			}
+			fallthrough;
 		default:
 			tcpm_pd_handle_state(port,
 					     port->pwr_role == TYPEC_SOURCE ?
-- 
2.30.2



