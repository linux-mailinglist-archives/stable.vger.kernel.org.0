Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADA111CA8
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfLCWqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbfLCWqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38A5E206DF;
        Tue,  3 Dec 2019 22:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413172;
        bh=J4IGNW/9vAhjBmCzGthwBreJTfmm0otLMjSIxpqY4gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDlMGgdB8KAh3PZN0ObWO4UUCf17bHxVyRfcjaatOr5J6liM++7enymWPVcGHjqny
         7a+KuTDLfIL/cK2rc5WVXIwxwkbEfMRtry+sBZuzNyV62eUvMSXYdq5Tw9L3p1M25m
         eyEK7ksOVHidpul4rZ7S3WnaSgrAcH6GyrpYBKUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/321] can: peak_usb: report bus recovery as well
Date:   Tue,  3 Dec 2019 23:31:32 +0100
Message-Id: <20191203223428.480056924@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index 61f33c2fb1cd7..215cd74800df4 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -444,8 +444,8 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 		}
 		if ((n & PCAN_USB_ERROR_BUS_LIGHT) == 0) {
 			/* no error (back to active state) */
-			mc->pdev->dev.can.state = CAN_STATE_ERROR_ACTIVE;
-			return 0;
+			new_state = CAN_STATE_ERROR_ACTIVE;
+			break;
 		}
 		break;
 
@@ -468,9 +468,9 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
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
 
@@ -509,6 +509,11 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
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



