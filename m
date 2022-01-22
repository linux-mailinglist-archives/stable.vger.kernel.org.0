Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B077749694D
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 02:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiAVBza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 20:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiAVBz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 20:55:29 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C201C06173D
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 17:55:29 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c7-20020a25a2c7000000b00613e4dbaf97so18921691ybn.13
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 17:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=w+J03WX3dcYDAp4cPk2KTKsHcLGHwowGZLQnlpzXNlE=;
        b=R+Q2VH/AcsjDDr+ApptRh7eTbb51+F1grMcFt9Rf2pdd7udJOBFKiNXuHYRPt3vT2H
         1nd49QaT08vlGTVFrThrms/tXZAAfFnLlXINYts72GS7vRZbF0d7SRb6KjJvJ1klOijl
         HxRg8PspMA5IjWvGuSzjL1cW7Uq+o3G8kCTYm4BgymesQPpQ/UN9xlrhS+rV825X38um
         dIsVF91gbBMe3+0bIY+lXJK4kIuzIFpqtdz1C3zppnfPR9HdaIVZTf+MXsCDdwYgUwKp
         L59ke7gbbLhsNsCB0/DCCIdA+WuTdGSEi4BAaR2c9DHRJvjdrLqztI1C8Q3L2jqq256y
         D1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=w+J03WX3dcYDAp4cPk2KTKsHcLGHwowGZLQnlpzXNlE=;
        b=vdxIze2dhlrh73qFIwaYhFZFqsJUcN5g8FyVW4KrjG33avrWuE8Bhp6GRQcXfaxS+G
         9UrA4NMGAXxhqvrcTg9Y18/SIWzpFn6HPS+sqSETtsTGlySBmxOEXFe/BDk1PSIV6NIS
         hwK8ogc33ovwOFYWM+S45Ky7ODbiAWkW2Yz7mjmMf1SgONo5J5i93iPtR7bhu8UepdnH
         zQprD99HmuvBWU6EWl/JRNkRv2w989bGiNKY45qykJ2wIioH2V/d4Y59iWFfsL9vmymY
         o7ZVF9cC6GJj6yNfCnMqmTQWzWFTE55apeoCpq4BNbNOId5kgN1ecUC/2NV740k2LrT0
         BAQw==
X-Gm-Message-State: AOAM533YDD50jSGU/zYuy8h4h1LTzOLiglsxIKuTFMZAaQ4iC4jo2of3
        IDAT5q8qw222QKlLF9i9IgwawWzDCrs=
X-Google-Smtp-Source: ABdhPJxbMfwag8YhXW+FSnTNUaijX6hQWAmIoRvZruMOQxHrjVZNICee2Trn1oql85aYSyXHs1+59ct8adU=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:e346:6a9d:2ca2:5c1c])
 (user=badhri job=sendgmr) by 2002:a0d:d8c8:0:b0:2ca:287c:6beb with SMTP id
 00721157ae682-2ca287c6e3bmr07b3.144.1642816527942; Fri, 21 Jan 2022 17:55:27
 -0800 (PST)
Date:   Fri, 21 Jan 2022 17:55:19 -0800
Message-Id: <20220122015520.332507-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v1 1/2] usb: typec: tcpm: Do not disconnect while receiving
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
will report a VBUS off event causing TCPM to transition to
SNK_UNATTACHED where it should be waiting in either SNK_ATTACH_WAIT
or SNK_DEBOUNCED state. This patch makes TCPM avoid vbus off events
while in SNK_ATTACH_WAIT or SNK_DEBOUNCED state.

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
---
 drivers/usb/typec/tcpm/tcpm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 59d4fa2443f2..b8afe3d8c882 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5156,7 +5156,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 	case SNK_TRYWAIT_DEBOUNCE:
 		break;
 	case SNK_ATTACH_WAIT:
-		tcpm_set_state(port, SNK_UNATTACHED, 0);
+	case SNK_DEBOUNCED:
+		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */
 		break;
 
 	case SNK_NEGOTIATE_CAPABILITIES:
-- 
2.35.0.rc0.227.g00780c9af4-goog

