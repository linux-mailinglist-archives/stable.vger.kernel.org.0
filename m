Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1907529C266
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819962AbgJ0Rfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760875AbgJ0Ogy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CFED2222C;
        Tue, 27 Oct 2020 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809414;
        bh=v4Faxe2oFWT9FGrJ/a98D50w3xZNO2pxrwsgAbFuMII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsQepco3o2IL0i3S2y9Fceeja1wpa87rUg26T0wryQeFwZwf+BtfgY2KqUEH7JDTS
         g1sjYQ/WUOPjLMaznd0w+TSl3mgpmQRHG00Smtgp5bO6lMnFmstvjQqVl3VxvXgkP2
         qb18bDhQB39UyzY4OiubQp1GSE9ruvXDO1buWbKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/408] scsi: mpt3sas: Fix sync irqs
Date:   Tue, 27 Oct 2020 14:51:24 +0100
Message-Id: <20201027135501.871004885@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 45181eab8ba79ed7a41b549f00500c0093828521 ]

_base_process_reply_queue() called from _base_interrupt() may schedule a
new irq poll. Fix this by calling synchronize_irq() first.

Also ensure that enable_irq() is called only when necessary to avoid
"Unbalanced enable for IRQ..." errors.

Link: https://lore.kernel.org/r/20200910142126.8147-1-thenzl@redhat.com
Fixes: 320e77acb327 ("scsi: mpt3sas: Irq poll to avoid CPU hard lockups")
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b7e44634d0dc2..3d58d24de6b61 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1708,18 +1708,22 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
 		/* TMs are on msix_index == 0 */
 		if (reply_q->msix_index == 0)
 			continue;
+		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 		if (reply_q->irq_poll_scheduled) {
 			/* Calling irq_poll_disable will wait for any pending
 			 * callbacks to have completed.
 			 */
 			irq_poll_disable(&reply_q->irqpoll);
 			irq_poll_enable(&reply_q->irqpoll);
-			reply_q->irq_poll_scheduled = false;
-			reply_q->irq_line_enable = true;
-			enable_irq(reply_q->os_irq);
-			continue;
+			/* check how the scheduled poll has ended,
+			 * clean up only if necessary
+			 */
+			if (reply_q->irq_poll_scheduled) {
+				reply_q->irq_poll_scheduled = false;
+				reply_q->irq_line_enable = true;
+				enable_irq(reply_q->os_irq);
+			}
 		}
-		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 	}
 }
 
-- 
2.25.1



