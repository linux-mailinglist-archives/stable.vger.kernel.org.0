Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6603A87EC
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 19:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFORpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 13:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhFORpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 13:45:33 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EDBC06175F
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 10:43:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p17-20020a056a000b51b02902f9e70d70ecso2763pfo.5
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 10:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=50dJ8BchFOci3A0yvk4/mrwi6BOktMhfxZ2dJA5Q/50=;
        b=dHSg5uHO+WryCWM/qB2U8Qc31sZ4MGk7Lf6JgXykCFPS3T5BiiSvzatPC/ky+oogVg
         PSbYno76lPg7XCYY8YFzMeOK62omeBzDd6sNyAKONT3uh7G4nYekPrx9PB1h7jKFqYV4
         b58Aq3mPO7jVKefTpn1+bjZf8Tmvks8jDMfekXrrIGMBmBoKtzIPqFaVff/9SqT4/eTB
         rBa1yl9vEn3z9pTiqjlDHodstPE35tO7H3t9MuAwXkWLreVjXFIQsMBmhuFI8AjoPRC8
         5kUs8sjS5awXpcOZR4zi9A5MFclnw682vXIVmbJvRRNoMBsP62bO+V3RiSo4qjD3y6WE
         MX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=50dJ8BchFOci3A0yvk4/mrwi6BOktMhfxZ2dJA5Q/50=;
        b=aWP8OfAf9gHSshmQ8cz/Z7p24dN10JUQWfjrCaHlSeXQGQKt5/z58yGD6Im4SlFLnY
         yY2bKBsPcAuR2XTYASio5tWMwdMjccI2YIOX2HmetfjM5sGSBCMrXeVolVKCaKCrbn1m
         q4MrFnFoky0qTrEkaOG7zOYEZHIBHyvNoFV0me1I+RBplS43YdZkfom71XyrRM3qZIfB
         9FZJkZ/dvf6IA30aBdwGi4nr4xlvUfj38eO4vKvnrc20FHjNa7u/bHc5O/n6aVRKRRvG
         nolGzkfqF9c5LYGfusc7b6SzTbXvTQeKOmLncTAllu/mDqrAjLJ1GGlqmAO5ZqwaEqes
         3ghA==
X-Gm-Message-State: AOAM532sTILCMJREuusWjZc8Cg6yzn934MHVTmCETqgSOpxi6F+xFcCk
        cUab/6ayXePmg8LI0CMbHA3Ac3So/eU=
X-Google-Smtp-Source: ABdhPJywZcKWzV+RRUOI+TqAyZn8x3y5mnLXQPhCIk0HihBrSmcHSc4rultD1YJxN6KoaMgxDDO0g08HvhM=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:74bf:7746:fe5:5dad])
 (user=badhri job=sendgmr) by 2002:a17:90a:2acc:: with SMTP id
 i12mr110133pjg.0.1623779006876; Tue, 15 Jun 2021 10:43:26 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:43:23 -0700
Message-Id: <20210615174323.1160132-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v1] usb: typec: tcpci: Fix up sink disconnect thresholds for PD
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

"Table 4-3 VBUS Sink Characteristics" of "Type-C Cable and Connector
Specification" defines the disconnect voltage thresholds of various
configurations. This change fixes the disconnect threshold voltage
calculation based on vSinkPD_min and vSinkDisconnectPD as defined
by the table.

Fixes: e1a97bf80a022 ("usb: typec: tcpci: Implement Auto discharge disconnect callbacks")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpci.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 22862345d1ab..9858716698df 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -21,8 +21,12 @@
 #define	PD_RETRY_COUNT_DEFAULT			3
 #define	PD_RETRY_COUNT_3_0_OR_HIGHER		2
 #define	AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV	3500
-#define	AUTO_DISCHARGE_PD_HEADROOM_MV		850
-#define	AUTO_DISCHARGE_PPS_HEADROOM_MV		1250
+#define	VSINKPD_MIN_IR_DROP_MV			750
+#define	VSRC_NEW_MIN_PERCENT			95
+#define	VSRC_VALID_MIN_MV			500
+#define	VPPS_NEW_MIN_PERCENT			95
+#define	VPPS_VALID_MIN_MV			100
+#define	VSINKDISCONNECT_PD_MIN_PERCENT		90
 
 #define tcpc_presenting_rd(reg, cc) \
 	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
@@ -351,11 +355,13 @@ static int tcpci_set_auto_vbus_discharge_threshold(struct tcpc_dev *dev, enum ty
 		threshold = AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV;
 	} else if (mode == TYPEC_PWR_MODE_PD) {
 		if (pps_active)
-			threshold = (95 * requested_vbus_voltage_mv / 100) -
-				AUTO_DISCHARGE_PD_HEADROOM_MV;
+			threshold = ((VPPS_NEW_MIN_PERCENT * requested_vbus_voltage_mv / 100) -
+				     VSINKPD_MIN_IR_DROP_MV - VPPS_VALID_MIN_MV) *
+				     VSINKDISCONNECT_PD_MIN_PERCENT / 100;
 		else
-			threshold = (95 * requested_vbus_voltage_mv / 100) -
-				AUTO_DISCHARGE_PPS_HEADROOM_MV;
+			threshold = ((VSRC_NEW_MIN_PERCENT * requested_vbus_voltage_mv / 100) -
+				     VSINKPD_MIN_IR_DROP_MV - VSRC_VALID_MIN_MV) *
+				     VSINKDISCONNECT_PD_MIN_PERCENT / 100;
 	} else {
 		/* 3.5V for non-pd sink */
 		threshold = AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV;
-- 
2.32.0.272.g935e593368-goog

