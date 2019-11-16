Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7649FF21F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfKPQRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729527AbfKPPqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:50 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D82F820870;
        Sat, 16 Nov 2019 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919210;
        bh=he1wjEhFAwwWAUwEw1PmINc7L+xpclqFnPx9YRYPgPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s68mZhIyBGM4niSF0zdSmJ4lDz1as6psZNcF/XTTDb7W3B1fgDRgE4OV7iP7a8tgF
         ha40/RvN8/pCDwc2r8iEOR5d/QNCJjBazKtjIPGJl34EMJ1VcpUjdfcHjJHt/WERPj
         Yqpwbo9rqhkOj+l/+Veq//BXwv5oD+1hcTbg9/yE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Badhri Jagan Sridharan <badhri@google.com>,
        Rob Herring <robh@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 215/237] usb: typec: tcpm: charge current handling for sink during hard reset
Date:   Sat, 16 Nov 2019 10:40:50 -0500
Message-Id: <20191116154113.7417-215-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

