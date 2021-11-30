Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09394462903
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 01:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhK3AWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 19:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhK3AWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 19:22:04 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D87AC061746
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:18:46 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id u11-20020a17090a4bcb00b001a6e77f7312so8752205pjl.5
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fqiIppSe7u1NnW3cvLakhtzd+THR0eb6aNRG1jCvBe4=;
        b=o+uUnHGtT31rOsMLzjD2lzn032LEfjUdq3Sw0top7vsPbr4ClyZZiDG2r3dG12KXzc
         ddIZgBMBZsAwPqGqU9bjdpTiJedG/w6RUN80tOam1c+EwmoIYC84qpPWyo8DAKaNg+Xe
         qKhuATpmTHS09T9YDJNAm/NsPa21R9JwQXsuOso97HZMAiyP9szju2Py5OZ5H/hUb8+W
         nflBKNoZQb5tWpdGPVogs9yATn5g4oB0Iw5Gwd5rp5xu11/6WiycWSVaSih4Q1UCEAU+
         E705eoE4QC+r0p2RBxl+EnRs2fLyWaxChEttYE3iTo2Zq4GvTfiVnVe2ZUX2eS5YTnAL
         rrjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fqiIppSe7u1NnW3cvLakhtzd+THR0eb6aNRG1jCvBe4=;
        b=bKn6QifYWQhWYn/z48CCqqDNkb155JnwgeUAmBIY67Geh7kuYHZMhPVmNP3FNaM2AO
         cZoqOMVU6qhQa9sdr8PKHsbFrgntvuquPHiedgke97ehohrRWasOSSQ+UZvVSiG2iBzh
         mnV4cr5d2OAlq0XZ0UrlqrSRhRP4FBpGzNcMRBS1wYRV1TnnoTDyBabXoV9PnPmIpBF4
         YiTuiNWxZ2znRXcQQDvq/P39xIKCmI5+sPZw5F6haCmTtx1Jwhtuc/8Z4NOK4+CxK07+
         z+LtJE3hnj53hmjOhb/PUmiZCKRAXwuHkZWBQAuwy6YazUm/rXk0w0U+igzg3rrWXhpm
         KQQQ==
X-Gm-Message-State: AOAM530eb9pN9/FYL57FSJ3D5fRAMM+PBsBNPttjsFOR8h3NZbPdGdzB
        NWCfwnVe5EPvhx6F0ygrvPk4n1uNBvs=
X-Google-Smtp-Source: ABdhPJy2g0UQKNf/QdSpzVdCY6bn6T4kSInxTQJ9sAF7rPJyaI+QNeOmoyBpD2Y/QM542UalnyZLBrNmIig=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:ee3f:d2a:7fda:5c6])
 (user=badhri job=sendgmr) by 2002:a05:6a00:8cc:b0:4a8:262:49e1 with SMTP id
 s12-20020a056a0008cc00b004a8026249e1mr27639423pfu.28.1638231525981; Mon, 29
 Nov 2021 16:18:45 -0800 (PST)
Date:   Mon, 29 Nov 2021 16:18:25 -0800
Message-Id: <20211130001825.3142830-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v2] usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 7f2f3ff1b391..6010b9901126 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4110,11 +4110,7 @@ static void run_state_machine(struct tcpm_port *port)
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
-- 
2.34.0.rc2.393.gf8c9666880-goog

