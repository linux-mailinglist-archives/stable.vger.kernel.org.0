Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC30347AE18
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbhLTO6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46722 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbhLTO4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFBB0611A7;
        Mon, 20 Dec 2021 14:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB4C36AE8;
        Mon, 20 Dec 2021 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012162;
        bh=etleW5nvVh6ct6enWBhjGZaJ+hpyxb+CdON3P6S3VdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug2sPxf/+cD5JoWaB6rUUQPDqLzh2xM9/s5jWO9j1/A5KHrG9wg8eXlor1CR+XwXt
         IcRiPWPPM2enWrE8UZDOf0YSkfKSzzfYZDcaEcJfo7ctqsepLf0DAF2iFsHOCKB4hY
         2v45x+JerGM3wtRr2ku+jC9DkVRG3iK7MrhBtgeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Li <ming4.li@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/177] dmaengine: idxd: fix missed completion on abort path
Date:   Mon, 20 Dec 2021 15:33:40 +0100
Message-Id: <20211220143042.459678208@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 8affd8a4b5ce356c8900cfb037674f3a4a11fbdb ]

Ming reported that with the abort path of the descriptor submission, there
can be a window where a completed descriptor can be missed to be completed
by the irq completion thread:

CPU A				CPU B
Submit (successful)

Submit (fail)
				irq_process_work_list() // empty

llist_abort_desc()
// remove all descs from pending list

				irq_process_pending_llist() // empty
				exit idxd_wq_thread() with no processing

Add opportunistic descriptor completion in the abort path in order to
remove the missed completion.

Fixes: 6b4b87f2c31a ("dmaengine: idxd: fix submission race window")
Reported-by: Ming Li <ming4.li@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163898288714.443911.16084982766671976640.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index de76fb4abac24..83452fbbb168b 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -106,6 +106,7 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 {
 	struct idxd_desc *d, *t, *found = NULL;
 	struct llist_node *head;
+	LIST_HEAD(flist);
 
 	desc->completion->status = IDXD_COMP_DESC_ABORT;
 	/*
@@ -120,7 +121,11 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 				found = desc;
 				continue;
 			}
-			list_add_tail(&desc->list, &ie->work_list);
+
+			if (d->completion->status)
+				list_add_tail(&d->list, &flist);
+			else
+				list_add_tail(&d->list, &ie->work_list);
 		}
 	}
 
@@ -130,6 +135,17 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 
 	if (found)
 		complete_desc(found, IDXD_COMPLETE_ABORT);
+
+	/*
+	 * complete_desc() will return desc to allocator and the desc can be
+	 * acquired by a different process and the desc->list can be modified.
+	 * Delete desc from list so the list trasversing does not get corrupted
+	 * by the other process.
+	 */
+	list_for_each_entry_safe(d, t, &flist, list) {
+		list_del_init(&d->list);
+		complete_desc(d, IDXD_COMPLETE_NORMAL);
+	}
 }
 
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
-- 
2.33.0



