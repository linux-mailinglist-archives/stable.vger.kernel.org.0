Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D147AE52
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhLTPAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33976 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237954AbhLTO6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38238B80EA3;
        Mon, 20 Dec 2021 14:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B9C36AE8;
        Mon, 20 Dec 2021 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012296;
        bh=SCg00STyrfaFex0eeFYWbQPsIjRSiLEQ0MoJ24bMPmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBkTqXftJ6Y/uljyz3BxzbdN0LpU9hUlFQ06XTKS52lH60lMAa/Ui/9NN2+XzbCKt
         YoU/GwkZc6XD3HtcJFPFwuDxiKJmSjgCSRWwjVKoP1mHQqe96ldTEGvIW9IXf4+p/K
         JF4vHmqFVpxNKt6s/qrmIpz/9tFTn2K5tJZPFHdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 151/177] Revert "can: m_can: remove support for custom bit timing"
Date:   Mon, 20 Dec 2021 15:35:01 +0100
Message-Id: <20211220143045.162295661@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

commit ea768b2ffec6cc9c3e17c37ef75d0539b8f89ff5 upstream.

The timing limits specified by the Elkhart Lake CPU datasheets do not
match the defaults. Let's reintroduce the support for custom bit timings.

This reverts commit 0ddd83fbebbc5537f9d180d31f659db3564be708.

Link: https://lore.kernel.org/all/00c9e2596b1a548906921a574d4ef7a03c0dace0.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |   24 ++++++++++++++++++------
 drivers/net/can/m_can/m_can.h |    3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1494,20 +1494,32 @@ static int m_can_dev_setup(struct m_can_
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = &m_can_bittiming_const_30X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_30X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_30X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_31X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
 	case 33:
 		/* Support both MCAN version v3.2.x and v3.3.0 */
-		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_31X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_31X;
 
 		cdev->can.ctrlmode_supported |=
 			(m_can_niso_supported(cdev) ?
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,6 +85,9 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
+	struct can_bittiming_const *bit_timing;
+	struct can_bittiming_const *data_timing;
+
 	struct m_can_ops *ops;
 
 	int version;


