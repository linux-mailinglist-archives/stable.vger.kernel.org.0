Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C3249C0FC
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 03:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiAZCA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 21:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiAZCAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 21:00:24 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85887C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:00:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so45430712ybg.8
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kRF0DIpm+1X7TVEtpuLwufuaaYhaX1D4iAM/RZ5ifBU=;
        b=mZi6Fx2jqpQSFDEvYVLiX63ZP5KThUtDgI7rcawn3RPj10LWxDXuDPGG04yoak7F7e
         1x/xB+OK8cjxUin+sBNf3JX50l3+WjkXkOuSvDnGZF/9zWte89txF/FeiD9/d9Y1saSy
         MG1iKLRDgT+vXjcfC46M2nRnqF+v7nn40d3eqiY1JrH3WdPfHQVWlEssP6NcZ/3S7bVN
         o8ZzZbRx8qXkJcVCMSj5OYKyca18XN0M9D9J4ZCDg+KIXqqifTcQxTeIcooJhM7smKdS
         CUGDTi36FCXS0fJuhq/NfG1406D0a17obNjgd6lOnriUhtSwqGE4pFmqtzLAIv+IHtOb
         wP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kRF0DIpm+1X7TVEtpuLwufuaaYhaX1D4iAM/RZ5ifBU=;
        b=xJj1rvVMCBfibzoph+eE3MFDWAJst5hOfVBfQLP4XPGN1LwK+PVZsPGn8CzyAwwnR9
         2ZsYKtfbsSQgTgt2Jns3h8JHq0rox4a6FFxKgwhQ2J1gKHRGl9M6Rnfjd0mYizPzrw0W
         /vYLlkVoOKwDw/eHgxHyz4WvYYtkI05VQsqgzCeI9v08lsynr0h8lJl0gy7kK5gNB7kG
         cFh5T2Pnfg8moDrEsiW/dsdPdOIAcmiLliI4ooYDFhnlFNoM0cfLO7lOowfGohzMZl6D
         1sKCo8XNQCNrTweVq9GApfL+DnIPwZSlwt93nVcpe4KNFqiRGMOlZh25RLjZ5+8uMx02
         5lwg==
X-Gm-Message-State: AOAM532COxzkpqvBtlXlslGXf2gf4CrZdExVUzNPIs9yQXuTXKA2Tp5u
        BQiFo0WMqtWC38ubre3tPg8je3JjAZs=
X-Google-Smtp-Source: ABdhPJw8FNNdBVfZHXJw6ZBA6HllHOEcyV7zTLkyMLmy7dWR0e1lkE+Bc+w088c0EiTqQ7nAKsHZcQKslpg=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:f4a7:8e16:f301:160])
 (user=badhri job=sendgmr) by 2002:a25:1f41:: with SMTP id f62mr32575122ybf.118.1643162422615;
 Tue, 25 Jan 2022 18:00:22 -0800 (PST)
Date:   Tue, 25 Jan 2022 18:00:15 -0800
Message-Id: <20220126020016.3159598-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 1/2] usb: typec: tcpm: Do not disconnect while receiving
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
---
Changes since v1:
- Fix typos stated by Guenter Roeck.
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

