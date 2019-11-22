Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA259106E78
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfKVLDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731437AbfKVLDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92203207FC;
        Fri, 22 Nov 2019 11:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420620;
        bh=dVNRZUOppbIJs5ql/gl9Dfu+yySfO+0rBHt2dBpyjbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s072tu2MA58vMHKgF9QKhexH4N8abuDn5wkA3OceOr7qHzUe8/9rjOwbQO7kzE2V7
         o40N+llf/5lgEsIkrNF0ezOzh1QWXNfs4HxXO/7DDEccV5C2hb8DlzI3pkovHIxOTs
         o41mb+7PMqZZM1PxsByCA8MkNT/FaUR8ayCreLQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/220] media: cec-gpio: select correct Signal Free Time
Date:   Fri, 22 Nov 2019 11:28:10 +0100
Message-Id: <20191122100921.767282759@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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



