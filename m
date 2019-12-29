Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21FF12C9A7
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbfL2SMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbfL2Rlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:41:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB3F3206A4;
        Sun, 29 Dec 2019 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641309;
        bh=r3Wb54eQ9Ab0ydwHvmzu9M4M3rsnxMteryXhsQ++IIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1l6jizZwH7Wi4cT/M8ECLJBHfyZJf1n0hXojB5U8cMekeXRwCDssZGKsmRZ10pcH
         BTkVUtt6iAoKLxf0oGz1n1QMIVFrn8wJ2DH+XCx+izUhefydryWdoMcVHZEiY9k4h6
         FJPtSBh0RuF1N0d4zbSqi+lEwbD126j5doWP8QQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 013/434] qede: Disable hardware gro when xdp prog is installed
Date:   Sun, 29 Dec 2019 18:21:06 +0100
Message-Id: <20191229172703.123415287@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 4c8dc00503db24deaf0b89dddfa84b7cba7cd4ce ]

commit 18c602dee472 ("qede: Use NETIF_F_GRO_HW.") introduced
a regression in driver that when xdp program is installed on
qede device, device's aggregation feature (hardware GRO) is not
getting disabled, which is unexpected with xdp.

Fixes: 18c602dee472 ("qede: Use NETIF_F_GRO_HW.")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1406,6 +1406,7 @@ static int qede_alloc_mem_rxq(struct qed
 		rxq->rx_buf_seg_size = roundup_pow_of_two(size);
 	} else {
 		rxq->rx_buf_seg_size = PAGE_SIZE;
+		edev->ndev->features &= ~NETIF_F_GRO_HW;
 	}
 
 	/* Allocate the parallel driver ring for Rx buffers */
@@ -1450,6 +1451,7 @@ static int qede_alloc_mem_rxq(struct qed
 		}
 	}
 
+	edev->gro_disable = !(edev->ndev->features & NETIF_F_GRO_HW);
 	if (!edev->gro_disable)
 		qede_set_tpa_param(rxq);
 err:
@@ -1702,8 +1704,6 @@ static void qede_init_fp(struct qede_dev
 		snprintf(fp->name, sizeof(fp->name), "%s-fp-%d",
 			 edev->ndev->name, queue_id);
 	}
-
-	edev->gro_disable = !(edev->ndev->features & NETIF_F_GRO_HW);
 }
 
 static int qede_set_real_num_queues(struct qede_dev *edev)


