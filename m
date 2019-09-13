Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F40B1F28
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388198AbfIMNQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388921AbfIMNQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:22 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 274FC20717;
        Fri, 13 Sep 2019 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380581;
        bh=ska6GvcMvDccfwAgcRVlSXG3/h/lqthHXrPwemOftNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIzPkQHCLewdRK+2DjIRsQHAiji9eBjrlWawdkGgrGx9uS41Rj07/wDx0AeVdcM1X
         EKJ6/0o31EJNOOhpg/DN1qzK9XxCCx5Zm5ED+n6IoblW+rpvYdwSYR8dirb8tvIydp
         k2QTlLoGG+ieRP+GpIoS+1DMvuk+4HI9Ah/VcOyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/190] usb: typec: tcpm: Try PD-2.0 if sink does not respond to 3.0 source-caps
Date:   Fri, 13 Sep 2019 14:06:05 +0100
Message-Id: <20190913130608.527985720@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fb20aa974ae12..819ae3b2bd7e8 100644
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



