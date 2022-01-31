Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C394A4277
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359718AbiAaLMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377266AbiAaLJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1FA0B82A4D;
        Mon, 31 Jan 2022 11:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F38C340E8;
        Mon, 31 Jan 2022 11:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627390;
        bh=SdIECVcmzvG7Ae7fwzWMZkHzLtG0FTcE/FlWXeR9vOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPKog7Ch50SW8vbqW/vQ7X5aQNTCatQ37MR/VSGJ/8jsfhLdkZKyutacpdzY8Bng9
         B05Dr4w93C1bzCEXDSdYDN15qOamE+GTKo267s/LkXMPTqaclcn3AlpXzaYeNtGNPi
         Cr9FE961t/2fYB7AN8uQyijTq36VoLLEIXoXyp3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.15 061/171] usb: typec: tcpci: dont touch CC line if its Vconn source
Date:   Mon, 31 Jan 2022 11:55:26 +0100
Message-Id: <20220131105232.089036475@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit 5638b0dfb6921f69943c705383ff40fb64b987f2 upstream.

With the AMS and Collision Avoidance, tcpm often needs to change the CC's
termination. When one CC line is sourcing Vconn, if we still change its
termination, the voltage of the another CC line is likely to be fluctuant
and unstable.

Therefore, we should verify whether a CC line is sourcing Vconn before
changing its termination and only change the termination that is not
a Vconn line. This can be done by reading the Vconn Present bit of
POWER_ STATUS register. To determine the polarity, we can read the
Plug Orientation bit of TCPC_CONTROL register. Since Vconn can only be
sourced if Plug Orientation is set.

Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
cc: <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20220113092943.752372-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c |   26 ++++++++++++++++++++++++++
 drivers/usb/typec/tcpm/tcpci.h |    1 +
 2 files changed, 27 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -75,9 +75,25 @@ static int tcpci_write16(struct tcpci *t
 static int tcpci_set_cc(struct tcpc_dev *tcpc, enum typec_cc_status cc)
 {
 	struct tcpci *tcpci = tcpc_to_tcpci(tcpc);
+	bool vconn_pres;
+	enum typec_cc_polarity polarity = TYPEC_POLARITY_CC1;
 	unsigned int reg;
 	int ret;
 
+	ret = regmap_read(tcpci->regmap, TCPC_POWER_STATUS, &reg);
+	if (ret < 0)
+		return ret;
+
+	vconn_pres = !!(reg & TCPC_POWER_STATUS_VCONN_PRES);
+	if (vconn_pres) {
+		ret = regmap_read(tcpci->regmap, TCPC_TCPC_CTRL, &reg);
+		if (ret < 0)
+			return ret;
+
+		if (reg & TCPC_TCPC_CTRL_ORIENTATION)
+			polarity = TYPEC_POLARITY_CC2;
+	}
+
 	switch (cc) {
 	case TYPEC_CC_RA:
 		reg = (TCPC_ROLE_CTRL_CC_RA << TCPC_ROLE_CTRL_CC1_SHIFT) |
@@ -112,6 +128,16 @@ static int tcpci_set_cc(struct tcpc_dev
 		break;
 	}
 
+	if (vconn_pres) {
+		if (polarity == TYPEC_POLARITY_CC2) {
+			reg &= ~(TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT);
+			reg |= (TCPC_ROLE_CTRL_CC_OPEN << TCPC_ROLE_CTRL_CC1_SHIFT);
+		} else {
+			reg &= ~(TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT);
+			reg |= (TCPC_ROLE_CTRL_CC_OPEN << TCPC_ROLE_CTRL_CC2_SHIFT);
+		}
+	}
+
 	ret = regmap_write(tcpci->regmap, TCPC_ROLE_CTRL, reg);
 	if (ret < 0)
 		return ret;
--- a/drivers/usb/typec/tcpm/tcpci.h
+++ b/drivers/usb/typec/tcpm/tcpci.h
@@ -98,6 +98,7 @@
 #define TCPC_POWER_STATUS_SOURCING_VBUS	BIT(4)
 #define TCPC_POWER_STATUS_VBUS_DET	BIT(3)
 #define TCPC_POWER_STATUS_VBUS_PRES	BIT(2)
+#define TCPC_POWER_STATUS_VCONN_PRES	BIT(1)
 #define TCPC_POWER_STATUS_SINKING_VBUS	BIT(0)
 
 #define TCPC_FAULT_STATUS		0x1f


