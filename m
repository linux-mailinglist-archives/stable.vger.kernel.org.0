Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75585299EE7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440893AbgJ0ASk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439139AbgJ0AKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE7F62224A;
        Tue, 27 Oct 2020 00:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757406;
        bh=Y35t+FAtesUBduLhCwVJNmP5YXfnIB7GODydZDlUC7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuM59a0UlR9Jus+YIYwKT1E89Vwzr+Sm9v4SfllsIkM3MXHuRtSkWTgl2KZJhNWgK
         JBgMJwxvtzfxOTguJJsszIZfKzB8TUdZW7udsmAsPIrFzAmLYiG4PXnUMARq55EOvk
         QeQkdvWxrsF0ggw50Oawv+/dsrdbXbAAQyTcbd8I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 16/46] usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart
Date:   Mon, 26 Oct 2020 20:09:15 -0400
Message-Id: <20201027000946.1026923-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

[ Upstream commit 6bbe2a90a0bb4af8dd99c3565e907fe9b5e7fd88 ]

The patch addresses the compliance test failures while running
TD.PD.CP.E3, TD.PD.CP.E4, TD.PD.CP.E5 of the "Deterministic PD
Compliance MOI" test plan published in https://www.usb.org/usbc.
For a product to be Type-C compliant, it's expected that these tests
are run on usb.org certified Type-C compliance tester as mentioned in
https://www.usb.org/usbc.

The purpose of the tests TD.PD.CP.E3, TD.PD.CP.E4, TD.PD.CP.E5 is to
verify the PR_SWAP response of the device. While doing so, the test
asserts that Source Capabilities message is NOT received from the test
device within tSwapSourceStart min (20 ms) from the time the last bit
of GoodCRC corresponding to the RS_RDY message sent by the UUT was
sent. If it does then the test fails.

This is in line with the requirements from the USB Power Delivery
Specification Revision 3.0, Version 1.2:
"6.6.8.1 SwapSourceStartTimer
The SwapSourceStartTimer Shall be used by the new Source, after a
Power Role Swap or Fast Role Swap, to ensure that it does not send
Source_Capabilities Message before the new Sink is ready to receive
the
Source_Capabilities Message. The new Source Shall Not send the
Source_Capabilities Message earlier than tSwapSourceStart after the
last bit of the EOP of GoodCRC Message sent in response to the PS_RDY
Message sent by the new Source indicating that its power supply is
ready."

The patch makes sure that TCPM does not send the Source_Capabilities
Message within tSwapSourceStart(20ms) by transitioning into
SRC_STARTUP only after  tSwapSourceStart(20ms).

Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200817183828.1895015-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/typec/pd.h   | 1 +
 drivers/staging/typec/tcpm.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/typec/pd.h b/drivers/staging/typec/pd.h
index 30b32ad72acd7..a18ab898fa668 100644
--- a/drivers/staging/typec/pd.h
+++ b/drivers/staging/typec/pd.h
@@ -280,6 +280,7 @@ static inline unsigned int rdo_max_power(u32 rdo)
 #define PD_T_ERROR_RECOVERY	100	/* minimum 25 is insufficient */
 #define PD_T_SRCSWAPSTDBY      625     /* Maximum of 650ms */
 #define PD_T_NEWSRC            250     /* Maximum of 275ms */
+#define PD_T_SWAP_SRC_START	20	/* Minimum of 20ms */
 
 #define PD_T_DRP_TRY		100	/* 75 - 150 ms */
 #define PD_T_DRP_TRYWAIT	600	/* 400 - 800 ms */
diff --git a/drivers/staging/typec/tcpm.c b/drivers/staging/typec/tcpm.c
index f237e31926f4c..686037a498c19 100644
--- a/drivers/staging/typec/tcpm.c
+++ b/drivers/staging/typec/tcpm.c
@@ -2741,7 +2741,7 @@ static void run_state_machine(struct tcpm_port *port)
 		 */
 		tcpm_set_pwr_role(port, TYPEC_SOURCE);
 		tcpm_pd_send_control(port, PD_CTRL_PS_RDY);
-		tcpm_set_state(port, SRC_STARTUP, 0);
+		tcpm_set_state(port, SRC_STARTUP, PD_T_SWAP_SRC_START);
 		break;
 
 	case VCONN_SWAP_ACCEPT:
-- 
2.25.1

