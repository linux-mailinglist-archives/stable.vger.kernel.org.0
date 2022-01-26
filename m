Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828A549C269
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 05:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiAZEEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 23:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiAZEEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 23:04:52 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D135C061744
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 20:04:52 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s7-20020a5b0447000000b005fb83901511so45726354ybp.11
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 20:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QwxLJwmoqd07JuSH9SLqDQX7ullgrCcHXvI+bgIzrTE=;
        b=lDIeDFzJ80jBeA928G8m+g6sPzt76PBYaMG4kwfZwWmpqXzoO8rlpE9Al9VBhO4d6K
         0mA9KeVOktB41epEOvrl6JMuVxG2lq8gJ8H8nxYndsVVF0o+gS5LIz4wxOx0X0pjLZx6
         JOdO/+j9TegK2nxxHZ/GFz1hmyUpaLIYsR82jrZmtSj1d+lly5ShCA/npI6LMrvsvjgo
         JnDaoUzy2D7OB2rCBrpWx0xeGdp2vvoA58MH6LLFzfv0gx/pDj/EYL39EuX4+f5ZTXBV
         XxUWb5Q/sBxQyYLbuuui8n+7Fvq80ccDM+LpRCTNZ4UGkxJ3M3bcS0J4i2MfSOoavJhB
         Mddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QwxLJwmoqd07JuSH9SLqDQX7ullgrCcHXvI+bgIzrTE=;
        b=7BRr8g+LV6HnzR68W1GUMFxKFePeOafL2MT98Ve5sFhslPuaaqZ1pBv2aDNLt8lGnu
         gD21nmcJ4J+iph78q2swc+4mg81FsH1AtI4kf9IBlyRHwcfPhOwwWrvFxR3o5Mlb68l1
         tJndY9hI1yc/snEa3Vsz+IrAWaD0L/++nrokROqxVWHEmnIpP8t+0yogeFGpG7O/QM0U
         nBfDuiXSUz3UKMI7dJ8Y2JrIsbTBqHLYq41/hxfC4fNEJw+TcuMOsgEECBjc2qKrxLPK
         BnOuLp14MHY1JLeEz5liqPeJB7GRT4aVGT89d7cpZk9T+8MeQ2MQMdkHHXPILKLI+Kk7
         yKcA==
X-Gm-Message-State: AOAM532fuNp3cvbk2Io2lignRGItzDmyHOZLHpYt35qkKaloe+A4RVH+
        rdUZigkNU4gZz9ITTU3BYq+QQT5JXCA=
X-Google-Smtp-Source: ABdhPJwUITrNjvxxgsP8hNxO6pG8m3zBJSqTIPlHqDPOOp0LmmLatYe2TYN1ocTktSm6IrB3QJ5bJKvtUuc=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:f4a7:8e16:f301:160])
 (user=badhri job=sendgmr) by 2002:a25:8550:: with SMTP id f16mr32238494ybn.319.1643169891564;
 Tue, 25 Jan 2022 20:04:51 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:04:46 -0800
Message-Id: <20220126040447.3186233-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v3 1/2] usb: typec: tcpm: Do not disconnect while receiving
 VBUS off
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

With some chargers, vbus might momentarily raise above VSAFE5V and fall
back to 0V before tcpm gets to read port->tcpc->get_vbus. This will
report a VBUS off event causing TCPM to transition to SNK_UNATTACHED
where it should be waiting in either SNK_ATTACH_WAIT or SNK_DEBOUNCED
state. This patch makes TCPM avoid vbus off events while in
SNK_ATTACH_WAIT or SNK_DEBOUNCED state.

Stub from the spec:
    "4.5.2.2.4.2 Exiting from AttachWait.SNK State
    A Sink shall transition to Unattached.SNK when the state of both
    the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
    A DRP shall transition to Unattached.SRC when the state of both
    the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."

[23.194131] CC1: 0 -> 0, CC2: 0 -> 5 [state SNK_UNATTACHED, polarity 0, connected]
[23.201777] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[23.209949] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
[23.300579] VBUS off
[23.300668] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [rev3 NONE_AMS]
[23.301014] VBUS VSAFE0V
[23.301111] Start toggling

Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
Changes since v1:
- Fix typos stated by Guenter Roeck.
Changes since v2:
- Added reviewed/acked-by tags
---
 drivers/usb/typec/tcpm/tcpm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 59d4fa2443f2..3bf79f52bd34 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5156,7 +5156,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 	case SNK_TRYWAIT_DEBOUNCE:
 		break;
 	case SNK_ATTACH_WAIT:
-		tcpm_set_state(port, SNK_UNATTACHED, 0);
+	case SNK_DEBOUNCED:
+		/* Do nothing, as TCPM is still waiting for vbus to reach VSAFE5V to connect */
 		break;
 
 	case SNK_NEGOTIATE_CAPABILITIES:
-- 
2.35.0.rc0.227.g00780c9af4-goog

