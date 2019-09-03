Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41EEA6FBE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbfICQ16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbfICQ15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98772238C5;
        Tue,  3 Sep 2019 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528076;
        bh=Jx4h1OLqgtM+TERApXP4s/2ms0EySlgEHJea4wI2Qf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DH7yIoGwDMBTdYv3qFeQSRvtY6GlzdhCxWqSgXJkLrP2DfIg7UOCxa4i1de3YteXg
         WcuQj56idzDoSJ1zcLdkuf2TIW4dob1UErDoo/PyCrrNuwMyIHTUw3yGKPZvG0GEwB
         zqIcSldOknaaGI+tu1ZWQxM2e9SDdpqwtqZPuQdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 089/167] usb: typec: tcpm: Try PD-2.0 if sink does not respond to 3.0 source-caps
Date:   Tue,  3 Sep 2019 12:24:01 -0400
Message-Id: <20190903162519.7136-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 976daf9d1199932df80e7b04546d1a1bd4ed5ece ]

PD 2.0 sinks are supposed to accept src-capabilities with a 3.0 header and
simply ignore any src PDOs which the sink does not understand such as PPS
but some 2.0 sinks instead ignore the entire PD_DATA_SOURCE_CAP message,
causing contract negotiation to fail.

This commit fixes such sinks not working by re-trying the contract
negotiation with PD-2.0 source-caps messages if we don't have a contract
after PD_N_HARD_RESET_COUNT hard-reset attempts.

The problem fixed by this commit was noticed with a Type-C to VGA dongle.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm.c b/drivers/usb/typec/tcpm.c
index 5f29ce8d6c3f9..e8524ad5a4c0a 100644
--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -37,6 +37,7 @@
 	S(SRC_ATTACHED),			\
 	S(SRC_STARTUP),				\
 	S(SRC_SEND_CAPABILITIES),		\
+	S(SRC_SEND_CAPABILITIES_TIMEOUT),	\
 	S(SRC_NEGOTIATE_CAPABILITIES),		\
 	S(SRC_TRANSITION_SUPPLY),		\
 	S(SRC_READY),				\
@@ -2987,10 +2988,34 @@ static void run_state_machine(struct tcpm_port *port)
 			/* port->hard_reset_count = 0; */
 			port->caps_count = 0;
 			port->pd_capable = true;
-			tcpm_set_state_cond(port, hard_reset_state(port),
+			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
 					    PD_T_SEND_SOURCE_CAP);
 		}
 		break;
+	case SRC_SEND_CAPABILITIES_TIMEOUT:
+		/*
+		 * Error recovery for a PD_DATA_SOURCE_CAP reply timeout.
+		 *
+		 * PD 2.0 sinks are supposed to accept src-capabilities with a
+		 * 3.0 header and simply ignore any src PDOs which the sink does
+		 * not understand such as PPS but some 2.0 sinks instead ignore
+		 * the entire PD_DATA_SOURCE_CAP message, causing contract
+		 * negotiation to fail.
+		 *
+		 * After PD_N_HARD_RESET_COUNT hard-reset attempts, we try
+		 * sending src-capabilities with a lower PD revision to
+		 * make these broken sinks work.
+		 */
+		if (port->hard_reset_count < PD_N_HARD_RESET_COUNT) {
+			tcpm_set_state(port, HARD_RESET_SEND, 0);
+		} else if (port->negotiated_rev > PD_REV20) {
+			port->negotiated_rev--;
+			port->hard_reset_count = 0;
+			tcpm_set_state(port, SRC_SEND_CAPABILITIES, 0);
+		} else {
+			tcpm_set_state(port, hard_reset_state(port), 0);
+		}
+		break;
 	case SRC_NEGOTIATE_CAPABILITIES:
 		ret = tcpm_pd_check_request(port);
 		if (ret < 0) {
-- 
2.20.1

