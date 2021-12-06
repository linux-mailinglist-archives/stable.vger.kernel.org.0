Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA77469BD6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359149AbhLFPRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47452 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354218AbhLFPOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1906B8111D;
        Mon,  6 Dec 2021 15:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0690CC341C1;
        Mon,  6 Dec 2021 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803440;
        bh=GmflVG0QWwQk7cEPi3CNRSu0mWZkwEKhXPuY55/kDUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEtiq+IFKuwoC4pNQJM7LajgY+DdC7a+1kkesJSR9XMRpJMrx7Nu+p6RGoJTBhxtH
         QxiGAZrzElvlQlbjI3i2Psso52CwisJGVxNg6QicG+UZOoOVUXV1NO7b+rQBZAKNnY
         bZ3jXD1TdNsXU/sgas/wvSRziQy9A1YnUb9h/wuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 4.19 42/48] usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect
Date:   Mon,  6 Dec 2021 15:56:59 +0100
Message-Id: <20211206145550.275195924@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit fbcd13df1e78eb2ba83a3c160eefe2d6f574beaf upstream.

Stub from the spec:
"4.5.2.2.4.2 Exiting from AttachWait.SNK State
A Sink shall transition to Unattached.SNK when the state of both
the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
A DRP shall transition to Unattached.SRC when the state of both
the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."

This change makes TCPM to wait in SNK_DEBOUNCED state until
CC1 and CC2 pins is SNK.Open for at least tPDDebounce. Previously,
TCPM resets the port if vbus is not present in PD_T_PS_SOURCE_ON.
This causes TCPM to loop continuously when connected to a
faulty power source that does not present vbus. Waiting in
SNK_DEBOUNCED also ensures that TCPM is adherant to
"4.5.2.2.4.2 Exiting from AttachWait.SNK State" requirements.

[ 6169.280751] CC1: 0 -> 0, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
[ 6169.280759] state change TOGGLING -> SNK_ATTACH_WAIT [rev2 NONE_AMS]
[ 6169.280771] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev2 NONE_AMS]
[ 6169.282427] CC1: 0 -> 0, CC2: 5 -> 5 [state SNK_ATTACH_WAIT, polarity 0, connected]
[ 6169.450825] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
[ 6169.450834] pending state change SNK_DEBOUNCED -> PORT_RESET @ 480 ms [rev2 NONE_AMS]
[ 6169.930892] state change SNK_DEBOUNCED -> PORT_RESET [delayed 480 ms]
[ 6169.931296] disable vbus discharge ret:0
[ 6169.931301] Setting usb_comm capable false
[ 6169.932783] Setting voltage/current limit 0 mV 0 mA
[ 6169.932802] polarity 0
[ 6169.933706] Requesting mux state 0, usb-role 0, orientation 0
[ 6169.936689] cc:=0
[ 6169.936812] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev2 NONE_AMS]
[ 6169.937157] CC1: 0 -> 0, CC2: 5 -> 0 [state PORT_RESET, polarity 0, disconnected]
[ 6170.036880] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
[ 6170.036890] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev2 NONE_AMS]
[ 6170.036896] Start toggling
[ 6170.041412] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]
[ 6170.042973] CC1: 0 -> 0, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
[ 6170.042976] state change TOGGLING -> SNK_ATTACH_WAIT [rev2 NONE_AMS]
[ 6170.042981] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev2 NONE_AMS]
[ 6170.213014] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
[ 6170.213019] pending state change SNK_DEBOUNCED -> PORT_RESET @ 480 ms [rev2 NONE_AMS]
[ 6170.693068] state change SNK_DEBOUNCED -> PORT_RESET [delayed 480 ms]
[ 6170.693304] disable vbus discharge ret:0
[ 6170.693308] Setting usb_comm capable false
[ 6170.695193] Setting voltage/current limit 0 mV 0 mA
[ 6170.695210] polarity 0
[ 6170.695990] Requesting mux state 0, usb-role 0, orientation 0
[ 6170.701896] cc:=0
[ 6170.702181] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev2 NONE_AMS]
[ 6170.703343] CC1: 0 -> 0, CC2: 5 -> 0 [state PORT_RESET, polarity 0, disconnected]

Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20211130001825.3142830-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -3098,11 +3098,7 @@ static void run_state_machine(struct tcp
 				       tcpm_try_src(port) ? SRC_TRY
 							  : SNK_ATTACHED,
 				       0);
-		else
-			/* Wait for VBUS, but not forever */
-			tcpm_set_state(port, PORT_RESET, PD_T_PS_SOURCE_ON);
 		break;
-
 	case SRC_TRY:
 		port->try_src_count++;
 		tcpm_set_cc(port, tcpm_rp_cc(port));


