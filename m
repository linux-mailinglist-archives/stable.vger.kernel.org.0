Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E32B5962E7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 21:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiHPTMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 15:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiHPTL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 15:11:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3C07D7BF
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:11:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f3959ba41so119559297b3.2
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=X/YkdclUGRbmTWtx7pCDnwB6JcrES8yYvjN/AvuuOws=;
        b=JBdb3tVJtQfGAYooIHg8G+7xnscUXc++JpjvqR7BGlAPRhgIIj4wkFphcp86Z7i9NS
         PUJfpaF9JABxy8z2VQV3FQZZEqBYabfppu4jrHtpOD56BqjYQxHKiQ+FLCpcze4CsMNc
         Pamq6on1eG5br1FaYUz/d9wClBGS7YVZ+OmViTijj5PliDle+4Jp/Y3hhT7fu4m3r56U
         zbkP7GNwE54SrFjfa1EswAu26i3mlhuTOB3uh6xAwygXwr2rp0sjfnSzYfgSJyuh0A1A
         hmQLFAPLg1jbc9spY8ABgKRzroNWadrB5VVQSuoJ74O6EGAiLHAMZj6QCKVyEWAGf+qC
         6Gyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=X/YkdclUGRbmTWtx7pCDnwB6JcrES8yYvjN/AvuuOws=;
        b=XUosIb4tOqqr+/WnKNdbaK0gAuEubkMSwrrnIj+PtwSvhHrqMxgwAfzbOlF5wjNW6A
         OBFVHxxTa7m1TCEgjZ/Ofy8DGB4KjTyo9F4QvxE0O017OKitMunroagxnY1S0k1uxC6R
         vc13z2MVNEGmQ7I8ooMFnfDdh/x54l9WhjXASU6zMwEq9OhI5JqlcORdUH8U01W6yoyP
         ax2t0IJq//Ip5L1BvDkZTixgsOWpzQyL7fNpmDLzm0/XGuymLrYXBAqQx/CXmiZmApQY
         1zGfvcCpRXMfEPnIAjHmIDqbrmYHcnC7VQOjyqRrXQM7SYKFV28th7eqancdBt09a5lG
         8glQ==
X-Gm-Message-State: ACgBeo3vKZfB1UPcdqOt/dJUvEsx/l96E+g8C4h4wdNjBijBdDRamBpV
        wJpxynRkpb4rUJjaYjvwiX9tlYMa7Qw=
X-Google-Smtp-Source: AA6agR7Ej5XeN1kk6sRNudElC0yOv+aIVrLG/331kS3Qv0cvLOVPouvYbE4PRfNshRSWWbsHNbvnpkTNarM=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:2019:e66e:d39a:1a4c])
 (user=badhri job=sendgmr) by 2002:a25:e756:0:b0:68f:f129:243c with SMTP id
 e83-20020a25e756000000b0068ff129243cmr117948ybh.493.1660677114308; Tue, 16
 Aug 2022 12:11:54 -0700 (PDT)
Date:   Tue, 16 Aug 2022 12:11:50 -0700
Message-Id: <20220816191150.1432166-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2] usb: typec: tcpm: Return ENOTSUPP for power supply prop writes
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the port does not support USB PD, prevent transition to PD
only states when power supply property is written. In this case,
TCPM transitions to SNK_NEGOTIATE_CAPABILITIES
which should not be the case given that the port is not pd_capable.

[   84.308251] state change SNK_READY -> SNK_NEGOTIATE_CAPABILITIES [rev3 NONE_AMS]
[   84.308335] Setting usb_comm capable false
[   84.323367] set_auto_vbus_discharge_threshold mode:3 pps_active:n vbus:5000 ret:0
[   84.323376] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_WAIT_CAPABILITIES [rev3 NONE_AMS]

Fixes: e9e6e164ed8f6 ("usb: typec: tcpm: Support non-PD mode")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
Changes since v1:
- Add Fixes tag.
---
 drivers/usb/typec/tcpm/tcpm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index ea5a917c51b1..904c7b4ce2f0 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6320,6 +6320,13 @@ static int tcpm_psy_set_prop(struct power_supply *psy,
 	struct tcpm_port *port = power_supply_get_drvdata(psy);
 	int ret;
 
+	/*
+	 * All the properties below are related to USB PD. The check needs to be
+	 * property specific when a non-pd related property is added.
+	 */
+	if (!port->pd_supported)
+		return -EOPNOTSUPP;
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		ret = tcpm_psy_set_online(port, val);
-- 
2.37.1.595.g718a3a8f04-goog

