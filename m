Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7538449BA7D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbiAYRiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:38:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52060 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353904AbiAYRh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:37:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAA346147F
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81E4C340E0;
        Tue, 25 Jan 2022 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643132245;
        bh=6um7pGtiXt81gBqTp8Y0shzCIjDFWelPKfQh9EpYRCo=;
        h=Subject:To:From:Date:From;
        b=g0rB7GFhJXskrcrip0JB5iC98JO2zHtBeGgi6KrR9kVeSygLbooR7mSPsmQuYP3Rs
         lUB4gzdFD72+BR4LO6je6j6Srz9buv2/mglcsSGY2hvElipI1RVpu6RaBKeLMZ0JDV
         QuyZzpP/qSFuV/4Yhc23giIMwi64LpPaCgW7dkdY=
Subject: patch "usb: typec: tcpci: don't touch CC line if it's Vconn source" added to usb-linus
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 25 Jan 2022 18:37:22 +0100
Message-ID: <1643132242252183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpci: don't touch CC line if it's Vconn source

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5638b0dfb6921f69943c705383ff40fb64b987f2 Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Thu, 13 Jan 2022 17:29:43 +0800
Subject: usb: typec: tcpci: don't touch CC line if it's Vconn source

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
 drivers/usb/typec/tcpm/tcpci.c | 26 ++++++++++++++++++++++++++
 drivers/usb/typec/tcpm/tcpci.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 35a1307349a2..e07d26a3cd8e 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -75,9 +75,25 @@ static int tcpci_write16(struct tcpci *tcpci, unsigned int reg, u16 val)
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
@@ -112,6 +128,16 @@ static int tcpci_set_cc(struct tcpc_dev *tcpc, enum typec_cc_status cc)
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
diff --git a/drivers/usb/typec/tcpm/tcpci.h b/drivers/usb/typec/tcpm/tcpci.h
index 2be7a77d400e..b2edd45f13c6 100644
--- a/drivers/usb/typec/tcpm/tcpci.h
+++ b/drivers/usb/typec/tcpm/tcpci.h
@@ -98,6 +98,7 @@
 #define TCPC_POWER_STATUS_SOURCING_VBUS	BIT(4)
 #define TCPC_POWER_STATUS_VBUS_DET	BIT(3)
 #define TCPC_POWER_STATUS_VBUS_PRES	BIT(2)
+#define TCPC_POWER_STATUS_VCONN_PRES	BIT(1)
 #define TCPC_POWER_STATUS_SINKING_VBUS	BIT(0)
 
 #define TCPC_FAULT_STATUS		0x1f
-- 
2.35.0


