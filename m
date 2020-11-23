Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559EC2C0ABE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgKWM0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbgKWM0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:26:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F06420857;
        Mon, 23 Nov 2020 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134403;
        bh=fpRHnWk875PicaKG9ODEDzkL8KyVZHCkv1aQOYD+ftY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsLvocmX9dDpWQizAj79ZB6ZXRWE4asyvhsTWHHyxrsbP7RQmhbLqp7ORINkcFk+1
         io+8WtO/AcK3njlr+Tcp3rvQiRwfUIsIrPvkZfRgZBnTXnaHa6VflMIrBy/svsCXZ0
         6cIi0Qn6v6I4sqvaQJdMfcbhX9lF2vI2gJMWUKcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo.oduw@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/47] can: m_can: m_can_handle_state_change(): fix state change
Date:   Mon, 23 Nov 2020 13:22:15 +0100
Message-Id: <20201123121806.958114275@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo.oduw@gmail.com>

[ Upstream commit cd0d83eab2e0c26fe87a10debfedbb23901853c1 ]

m_can_handle_state_change() is called with the new_state as an argument.

In the switch statements for CAN_STATE_ERROR_ACTIVE, the comment and the
following code indicate that a CAN_STATE_ERROR_WARNING is handled.

This patch fixes this problem by changing the case to CAN_STATE_ERROR_WARNING.

Signed-off-by: Wu Bo <wubo.oduw@gmail.com>
Link: http://lore.kernel.org/r/20200129022330.21248-2-wubo.oduw@gmail.com
Cc: Dan Murphy <dmurphy@ti.com>
Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 195f15edb32e3..0bd7e71647964 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -572,7 +572,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	unsigned int ecr;
 
 	switch (new_state) {
-	case CAN_STATE_ERROR_ACTIVE:
+	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		priv->can.can_stats.error_warning++;
 		priv->can.state = CAN_STATE_ERROR_WARNING;
@@ -601,7 +601,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	__m_can_get_berr_counter(dev, &bec);
 
 	switch (new_state) {
-	case CAN_STATE_ERROR_ACTIVE:
+	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |= CAN_ERR_CRTL;
 		cf->data[1] = (bec.txerr > bec.rxerr) ?
-- 
2.27.0



