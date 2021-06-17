Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90EB3AB50A
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 15:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFQNly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 09:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232598AbhFQNlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 09:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5324613CB;
        Thu, 17 Jun 2021 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623937186;
        bh=zfY0uBRWRqcv8s1VLqslShp0yyStIF/f4xOV/vy4cNo=;
        h=Subject:To:From:Date:From;
        b=bWrfeY2LlonzX+9uXopirYEFOMrVPmGSnMAXKqHkOT4MB+0vcJvhe4dY4HkzL/Ygq
         VGrpiwHVrBo9gTubFlqjXMsvb4dGOUTIjwJPeyGu2B4wwY+mYIAGDDwzoN0hfLl+XF
         bqcORFeAPQm1OuJ1cS4zi3grB11ZhDQxbff50UKU=
Subject: patch "usb: typec: tcpci: Fix up sink disconnect thresholds for PD" added to usb-testing
To:     badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 15:39:43 +0200
Message-ID: <162393718317076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpci: Fix up sink disconnect thresholds for PD

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4288debeaa4e21d8dd5132739ffba2d343892bbf Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Tue, 15 Jun 2021 10:43:23 -0700
Subject: usb: typec: tcpci: Fix up sink disconnect thresholds for PD

"Table 4-3 VBUS Sink Characteristics" of "Type-C Cable and Connector
Specification" defines the disconnect voltage thresholds of various
configurations. This change fixes the disconnect threshold voltage
calculation based on vSinkPD_min and vSinkDisconnectPD as defined
by the table.

Fixes: e1a97bf80a022 ("usb: typec: tcpci: Implement Auto discharge disconnect callbacks")
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20210615174323.1160132-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.32.0


