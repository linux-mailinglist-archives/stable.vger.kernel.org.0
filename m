Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1598010BA9D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfK0VE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:04:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732224AbfK0VE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CF8215F1;
        Wed, 27 Nov 2019 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888696;
        bh=he1wjEhFAwwWAUwEw1PmINc7L+xpclqFnPx9YRYPgPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeV9UqfoC85sz/UW1ZTmRibLd/Jm2ztGrNgGGy/ZGC6I2y0Ppt7yxotT0bl3e7Kxc
         OlMn6DaaDEMY+DfggqS+jg6Ddv3WIBm40i3aQDGtnhQHYOvhIITEx4QoIrVbN5YtTR
         HC0swtzXBk4ePHPluJMrYAcLcNEt982aP+4kTLJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Rob Herring <robh@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 232/306] usb: typec: tcpm: charge current handling for sink during hard reset
Date:   Wed, 27 Nov 2019 21:31:22 +0100
Message-Id: <20191127203131.957163978@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

[ Upstream commit 157c0f2f641a9938382b092c64548ebdabfe25e0 ]

During the initial connect to a non-pd port, sink would hard reset
twice before deeming that the port partner is non-pd. TCPM sets the
the charge path to false during the hard reset. This causes unnecessary
connects/disconnects of charge path and makes port take longer to
charge from the non-pd ports. Avoid this by not setting the charge path
to false unless the partner has already identified to be pd capable.

When partner is a pd port, set the charge path to false in
SNK_HARD_RESET_SINK_OFF. Set the current limits to default value based
of CC pull up and resume the charge path when port enters
SNK_HARD_RESET_SINK_ON.

Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

--------
Changes in V3:
Rebase on top of usb-next

Changes in V2:
Based on feedback of jackp@codeaurora.org
- vsafe_5v_hard_reset flag from tcpc_config is removed
- Patch only differentiates between pd port partner and non-pd port
partner

V1 version of the patch is here:
https://lkml.org/lkml/2018/9/14/11
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm.c b/drivers/usb/typec/tcpm.c
index 819ae3b2bd7e8..39cf190012393 100644
--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -3322,7 +3322,8 @@ static void run_state_machine(struct tcpm_port *port)
 	case SNK_HARD_RESET_SINK_OFF:
 		memset(&port->pps_data, 0, sizeof(port->pps_data));
 		tcpm_set_vconn(port, false);
-		tcpm_set_charge(port, false);
+		if (port->pd_capable)
+			tcpm_set_charge(port, false);
 		tcpm_set_roles(port, port->self_powered, TYPEC_SINK,
 			       TYPEC_DEVICE);
 		/*
@@ -3354,6 +3355,12 @@ static void run_state_machine(struct tcpm_port *port)
 		 * Similar, dual-mode ports in source mode should transition
 		 * to PE_SNK_Transition_to_default.
 		 */
+		if (port->pd_capable) {
+			tcpm_set_current_limit(port,
+					       tcpm_get_current_limit(port),
+					       5000);
+			tcpm_set_charge(port, true);
+		}
 		tcpm_set_attached_state(port, true);
 		tcpm_set_state(port, SNK_STARTUP, 0);
 		break;
-- 
2.20.1



