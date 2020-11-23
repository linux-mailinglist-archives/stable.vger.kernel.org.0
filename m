Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0342C0620
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKWM2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:28:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730390AbgKWM2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:28:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1E2F20728;
        Mon, 23 Nov 2020 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134479;
        bh=YxspgIcfsGSxpHBOzsNLR95d45ufnwb0/diUX2ysqO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLJ0BAD9LrRpBx/LUQYQayXR2LJBRhdSij9F6vjiVfj435dQAO7V0dEqZiALTA8x7
         Dy2cZaqQYZSY64zYX10DQ1Ze+W6OCpDEXdLFnbyWeI711UFwrWbVASvKT8ML03XLZM
         zkqIs+0ZNnH6ZLQvey8BjyhjEOby32XeVCFgEUps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo.oduw@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/60] can: m_can: m_can_handle_state_change(): fix state change
Date:   Mon, 23 Nov 2020 13:22:17 +0100
Message-Id: <20201123121806.741802085@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
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
index ebad93ac8f118..680ee8345211f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -671,7 +671,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	unsigned int ecr;
 
 	switch (new_state) {
-	case CAN_STATE_ERROR_ACTIVE:
+	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		priv->can.can_stats.error_warning++;
 		priv->can.state = CAN_STATE_ERROR_WARNING;
@@ -700,7 +700,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	__m_can_get_berr_counter(dev, &bec);
 
 	switch (new_state) {
-	case CAN_STATE_ERROR_ACTIVE:
+	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |= CAN_ERR_CRTL;
 		cf->data[1] = (bec.txerr > bec.rxerr) ?
-- 
2.27.0



