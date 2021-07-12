Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BCE3C4B69
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241555AbhGLG5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240612AbhGLG4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83008613CA;
        Mon, 12 Jul 2021 06:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072800;
        bh=/0E7utqSA8THacPWs3WD0IvfcJIVjRd4pHuNFCA6MAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9xfCK5WPRhKb6/LRScE9GofsHuRbdfoMrf4kYznYfFdUoFu7LtHJDc3AiPVSFv2A
         3ZPwgliFGKrELBXn2Dpe+rpTHf6hIIveGqjGJKjA26Mq2qRXpDXIyMnTyTOtrunFaN
         KDoJT0ytXqaM5aHCZlBuCnQjhPLalfipTL0dROtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.12 025/700] usb: typec: tcpci: Fix up sink disconnect thresholds for PD
Date:   Mon, 12 Jul 2021 08:01:48 +0200
Message-Id: <20210712060928.239979267@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit 4288debeaa4e21d8dd5132739ffba2d343892bbf upstream.

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
 drivers/usb/typec/tcpm/tcpci.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

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
 
 #define tcpc_presenting_cc1_rd(reg) \
 	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
@@ -328,11 +332,13 @@ static int tcpci_set_auto_vbus_discharge
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


