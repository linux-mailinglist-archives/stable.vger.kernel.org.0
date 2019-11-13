Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A378FA559
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfKMCW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfKMBxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F4D222CD;
        Wed, 13 Nov 2019 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610009;
        bh=dVNRZUOppbIJs5ql/gl9Dfu+yySfO+0rBHt2dBpyjbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YH/Ct24kvlkeGoRV4FcQPbHgieEzYyf9DV4wTLI5Pum4uu7P+lUK45V0vooigDCFr
         K0NGvu29OxHjHFQtuaYv6yETpCAfSgojkcoPGFAe0HL75l9rC/gugtkpq84sh3fCS2
         MD+53ymf3wGufBDs189dKXVQPL5IzJ+cKlsPdjKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 114/209] media: cec-gpio: select correct Signal Free Time
Date:   Tue, 12 Nov 2019 20:48:50 -0500
Message-Id: <20191113015025.9685-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0496d93b2b8fa..8f987bc0dd883 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -936,6 +936,17 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
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
 		if (ktime_to_ns(pin->ts) == 0)
@@ -1158,6 +1169,15 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
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
 	pin->tx_extra_bytes = 0;
 	pin->tx_msg = *msg;
-- 
2.20.1

