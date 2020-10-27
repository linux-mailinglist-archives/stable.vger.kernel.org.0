Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB48C29B8FA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802127AbgJ0Ppn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798717AbgJ0P3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D9D22202;
        Tue, 27 Oct 2020 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812587;
        bh=77DtIgcoht4/tTboVWKU0cgkwmuibW0NW7eZJHKZEcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3Z+noIZotPT1CmX09Pfb5V3lsiFa7zHxDAx2752/OuDCTRGglkKm6m9uGi2u0pns
         x83edAsit1zo+AltEOQuiXE7tytL82xhQAUONf9QgBCNz/2DPIHIPRLWgOHdJ/P+Hv
         IZGBD/UXQfDkFj4BvUEMcCr6ivmSuBWyAm1AUJIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 261/757] scsi: mpt3sas: Fix sync irqs
Date:   Tue, 27 Oct 2020 14:48:31 +0100
Message-Id: <20201027135502.821081939@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 8062bd99add85..e86682dc34eca 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1809,18 +1809,22 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
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



