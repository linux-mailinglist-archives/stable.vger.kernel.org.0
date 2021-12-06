Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88905469EEF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378261AbhLFPow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390687AbhLFPmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BA7C0698E3;
        Mon,  6 Dec 2021 07:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1A361320;
        Mon,  6 Dec 2021 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D80C34901;
        Mon,  6 Dec 2021 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804562;
        bh=IUNXGK1BSKt1J7pbqVEgdzk0ZpiaW/L4bRt5lrL4tY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEV3i+TxNnpeyR36GCDjPdz/i6ZySuIFqM7awZ7wvrT0L/5gk6lvw/h0wthB7vPCC
         g6eyirlDRV7iVUp6MmMLzDd4+g/BoM8PYS14QTCVAUg9AnPF3hFeHjOPbXLHHlXF3s
         7MmNUNrulsOY5+MzmtBA2t8vDLAmL3BtvkbgCHPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.15 191/207] usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect
Date:   Mon,  6 Dec 2021 15:57:25 +0100
Message-Id: <20211206145616.891556798@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
 drivers/usb/typec/tcpm/tcpm.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4110,11 +4110,7 @@ static void run_state_machine(struct tcp
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


