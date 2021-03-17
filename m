Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D520B33F7E2
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 19:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhCQSNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 14:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhCQSMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 14:12:53 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31318C061760
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 11:12:53 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id f8so611986qtv.22
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 11:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VJxxc1aWYvyrrwlQVS/dPT/va70MajmNF5/Ovh5tHqY=;
        b=kyQ8Hiv4GYcoi4+iUdOGxaPKf5RLY4MOrgjWePaGv9iAOuYjxdMqJFk1uR/pqtJtHk
         XeYUeXcy79FaEhJ4181E7nrIVXSXkQLf3Ffm9UDzQuIYyIh1S/fSP0Qi2cAxuzjmDs2T
         AwHsNTd/tZDGjVvy1EPWNxnGm4xRYf8dXcXlHX1hGYa13+6oItJxzotqfQBwyJnvVtUk
         onK7S7VXY1ktUjilkSDedQsLEpxW36TPwbdbGDdkbn0iqTx37ESwwlvewXZfttSE2Jeb
         EmRgHWR8B7h81/49d32oY5XGve3qANSXjiroAjT6pq5nSZ+8x+MiU8DTf+hZ3Pf5sBOF
         tP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VJxxc1aWYvyrrwlQVS/dPT/va70MajmNF5/Ovh5tHqY=;
        b=RZsKOUYl4cKopwGr4G/ufe58UE9xfTGMriy2vusx6fYkxeNkElaQj+8Gj4n2t5PaeD
         kRJIIvX0fhrKUbLFgZAGBFLpxeaTg7UGLYORFPKHrtauiP/rq9rHa2H6OCXrSnvtRU7z
         n4JGMw0WBOex9MGvTwEr0JKtv1K0uKcxww8sbAaHF8h6Uz3V9jfnXmeJKjl+Vf6dhRzr
         Sjpo4BkSz1i3cL0mSLJmgwcgn8oSdkOvZtgGx6DzdNOaNb9A1QP4V4ZZR/3+1x5S03Nm
         aYELCfMR+131xZBI+1IcKbMxI1IFsqL27sf+pr2L2ZTXC4naD+DY/yCfGBPN7XZTgVUW
         LDiQ==
X-Gm-Message-State: AOAM531yn9zMGoZMLkRUHZSVSxe8zvWggH8n3Yl9VmQMr+FqmJIBB587
        EqneM1rcOHJhBUjVr9N0ZjbsjqozTEA=
X-Google-Smtp-Source: ABdhPJw/Wivaj/kWp56aU+QGo3lEFgihQqOAAkIvy99F0Ym1kOta9QfL7jBHsbZ39lHIXecHsM2e9+KlTfU=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:dc6b:2250:2aa4:b316])
 (user=badhri job=sendgmr) by 2002:a05:6214:16c1:: with SMTP id
 d1mr370034qvz.29.1616004772217; Wed, 17 Mar 2021 11:12:52 -0700 (PDT)
Date:   Wed, 17 Mar 2021 11:12:48 -0700
Message-Id: <20210317181249.1062995-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2] usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tcpm-source-psy- does not invoke power_supply_changed API when
one of the published power supply properties is changed.
power_supply_changed needs to be called to notify
userspace clients(uevents) and kernel clients.

Fixes: f2a8aa053c176("typec: tcpm: Represent source supply through power_supply")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
Changes since V1:
- Fixed commit message as per Guenter's suggestion
- Added Reviewed-by tags
- cc'ed stable
---
 drivers/usb/typec/tcpm/tcpm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 11d0c40bc47d..e8936ea17f80 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -945,6 +945,7 @@ static int tcpm_set_current_limit(struct tcpm_port *port, u32 max_ma, u32 mv)
 
 	port->supply_voltage = mv;
 	port->current_limit = max_ma;
+	power_supply_changed(port->psy);
 
 	if (port->tcpc->set_current_limit)
 		ret = port->tcpc->set_current_limit(port->tcpc, max_ma, mv);
@@ -2931,6 +2932,7 @@ static int tcpm_pd_select_pdo(struct tcpm_port *port, int *sink_pdo,
 
 	port->pps_data.supported = false;
 	port->usb_type = POWER_SUPPLY_USB_TYPE_PD;
+	power_supply_changed(port->psy);
 
 	/*
 	 * Select the source PDO providing the most power which has a
@@ -2955,6 +2957,7 @@ static int tcpm_pd_select_pdo(struct tcpm_port *port, int *sink_pdo,
 				port->pps_data.supported = true;
 				port->usb_type =
 					POWER_SUPPLY_USB_TYPE_PD_PPS;
+				power_supply_changed(port->psy);
 			}
 			continue;
 		default:
@@ -3112,6 +3115,7 @@ static unsigned int tcpm_pd_select_pps_apdo(struct tcpm_port *port)
 						  port->pps_data.out_volt));
 		port->pps_data.op_curr = min(port->pps_data.max_curr,
 					     port->pps_data.op_curr);
+		power_supply_changed(port->psy);
 	}
 
 	return src_pdo;
@@ -3347,6 +3351,7 @@ static int tcpm_set_charge(struct tcpm_port *port, bool charge)
 			return ret;
 	}
 	port->vbus_charge = charge;
+	power_supply_changed(port->psy);
 	return 0;
 }
 
@@ -3530,6 +3535,7 @@ static void tcpm_reset_port(struct tcpm_port *port)
 	port->try_src_count = 0;
 	port->try_snk_count = 0;
 	port->usb_type = POWER_SUPPLY_USB_TYPE_C;
+	power_supply_changed(port->psy);
 	port->nr_sink_caps = 0;
 	port->sink_cap_done = false;
 	if (port->tcpc->enable_frs)
@@ -5957,7 +5963,7 @@ static int tcpm_psy_set_prop(struct power_supply *psy,
 		ret = -EINVAL;
 		break;
 	}
-
+	power_supply_changed(port->psy);
 	return ret;
 }
 
@@ -6110,6 +6116,7 @@ struct tcpm_port *tcpm_register_port(struct device *dev, struct tcpc_dev *tcpc)
 	err = devm_tcpm_psy_register(port);
 	if (err)
 		goto out_role_sw_put;
+	power_supply_changed(port->psy);
 
 	port->typec_port = typec_register_port(port->dev, &port->typec_caps);
 	if (IS_ERR(port->typec_port)) {
-- 
2.31.0.rc2.261.g7f71774620-goog

