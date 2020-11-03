Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267192A5449
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388560AbgKCVJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387859AbgKCVJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C2E207BC;
        Tue,  3 Nov 2020 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437783;
        bh=AUY8FVxePWJ41loX4HLUm4glxBurX+WbfUABdnbgmA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPpQq6B5aCRKiY72v1J99TWMZ8UZKzhHqvjp6KSo5yrBxPOfx6hKysJ295JLuMtqf
         5fLsii86PO2It3VDDN5bYC31ox5Gs0/2Y0U2ZINEpB9+62mm5hnpjnCNQ42xT5bJ09
         OZziZt1QgDoQpZruUe3ZdEA/iPyNF4ThEDlMdWv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/125] usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart
Date:   Tue,  3 Nov 2020 21:36:48 +0100
Message-Id: <20201103203201.232412657@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0



