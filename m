Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE810106F40
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfKVKx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbfKVKxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F7620715;
        Fri, 22 Nov 2019 10:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420003;
        bh=SQX4m5NVGnqJ3q72qKNhjXEzNYaDtD/tZoaOQ9DRSdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxgZPyRPUK4gfaSyypHJNkgvafVTr2J5/gfUYrgVg805wB3NoF2Mm0qr85FB3I9+r
         9TKFW0txRZkgw2ubwqInmukREzkAN908Ls/tX43Tb4qmuc1PbbOVnU0FbQ5I6CDXre
         cFpoL2/gOuEBG60yq7y/Jw9ZgC5mpY945w9uIFgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/122] media: cec-gpio: select correct Signal Free Time
Date:   Fri, 22 Nov 2019 11:28:48 +0100
Message-Id: <20191122100815.572000367@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

[ Upstream commit c439d5c1e13dbf66cff53455432f21d4d0536c51 ]

If a receive is in progress or starts before the transmit has
a chance, then lower the Signal Free Time of the upcoming transmit
to no more than CEC_SIGNAL_FREE_TIME_NEW_INITIATOR.

This is per the specification requirements.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-pin.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index c003b8eac6176..68fc6a24d0771 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -529,6 +529,17 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 			/* Start bit, switch to receive state */
 			pin->ts = ts;
 			pin->state = CEC_ST_RX_START_BIT_LOW;
+			/*
+			 * If a transmit is pending, then that transmit should
+			 * use a signal free time of no more than
+			 * CEC_SIGNAL_FREE_TIME_NEW_INITIATOR since it will
+			 * have a new initiator due to the receive that is now
+			 * starting.
+			 */
+			if (pin->tx_msg.len && pin->tx_signal_free_time >
+			    CEC_SIGNAL_FREE_TIME_NEW_INITIATOR)
+				pin->tx_signal_free_time =
+					CEC_SIGNAL_FREE_TIME_NEW_INITIATOR;
 			break;
 		}
 		if (pin->ts == 0)
@@ -690,6 +701,15 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 {
 	struct cec_pin *pin = adap->pin;
 
+	/*
+	 * If a receive is in progress, then this transmit should use
+	 * a signal free time of max CEC_SIGNAL_FREE_TIME_NEW_INITIATOR
+	 * since when it starts transmitting it will have a new initiator.
+	 */
+	if (pin->state != CEC_ST_IDLE &&
+	    signal_free_time > CEC_SIGNAL_FREE_TIME_NEW_INITIATOR)
+		signal_free_time = CEC_SIGNAL_FREE_TIME_NEW_INITIATOR;
+
 	pin->tx_signal_free_time = signal_free_time;
 	pin->tx_msg = *msg;
 	pin->work_tx_status = 0;
-- 
2.20.1



