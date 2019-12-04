Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671F9113366
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbfLDSLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731382AbfLDSLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:11:07 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87E920865;
        Wed,  4 Dec 2019 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483067;
        bh=WbqjUggnJDh4A988fik+6/iGaJLlVSosFqW9yVNwscw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmGrkZghHZeUhTQgVtPzM0G0UktqPJ7PmdBDq3PR+pXPqM5izVhIegwC+Ce7uKrZn
         TwlqBJCMl8oulNVo+lq04TCoF6tVZaBqiDf09f7j3M7nb1ON+3JAiXMyXNRI3i5rAh
         84RpMm6TsL8Ja2LOESvf4Dld8xE3HG+0FVAlX70k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 007/125] can: peak_usb: report bus recovery as well
Date:   Wed,  4 Dec 2019 18:55:12 +0100
Message-Id: <20191204175312.017613060@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeroen Hofstee <jhofstee@victronenergy.com>

[ Upstream commit 128a1b87d3ceb2ba449d5aadb222fe22395adeb0 ]

While the state changes are reported when the error counters increase
and decrease, there is no event when the bus recovers and the error
counters decrease again. So add those as well.

Change the state going downward to be ERROR_PASSIVE -> ERROR_WARNING ->
ERROR_ACTIVE instead of directly to ERROR_ACTIVE again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Cc: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index e626c2afbbb11..0e1fc6c4360e7 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -441,8 +441,8 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 		}
 		if ((n & PCAN_USB_ERROR_BUS_LIGHT) == 0) {
 			/* no error (back to active state) */
-			mc->pdev->dev.can.state = CAN_STATE_ERROR_ACTIVE;
-			return 0;
+			new_state = CAN_STATE_ERROR_ACTIVE;
+			break;
 		}
 		break;
 
@@ -465,9 +465,9 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 		}
 
 		if ((n & PCAN_USB_ERROR_BUS_HEAVY) == 0) {
-			/* no error (back to active state) */
-			mc->pdev->dev.can.state = CAN_STATE_ERROR_ACTIVE;
-			return 0;
+			/* no error (back to warning state) */
+			new_state = CAN_STATE_ERROR_WARNING;
+			break;
 		}
 		break;
 
@@ -506,6 +506,11 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 		mc->pdev->dev.can.can_stats.error_warning++;
 		break;
 
+	case CAN_STATE_ERROR_ACTIVE:
+		cf->can_id |= CAN_ERR_CRTL;
+		cf->data[1] = CAN_ERR_CRTL_ACTIVE;
+		break;
+
 	default:
 		/* CAN_STATE_MAX (trick to handle other errors) */
 		cf->can_id |= CAN_ERR_CRTL;
-- 
2.20.1



