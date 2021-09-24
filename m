Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207E44173CC
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345902AbhIXNAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345608AbhIXM6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AB77613A8;
        Fri, 24 Sep 2021 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487966;
        bh=ngNmUlPR/Xp+NHz9Lz/zcKOjOcW4Q5roAf+5dY4S0/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOx2/LHcFsCSrUQMJ00dtJTl1DKNDVqBtQhy6r2xC6EddDOL7M9AsrOUppxzWhczP
         mvXekEuFpTvPx3RuSCQfDmZV9oSjbTljYCQf/QnezSKmOq7H//0k1O8fsBs9dVM6VT
         fNnCOAznUkfTfFGrOgvSelMTAeaJsAPbU9kIfQuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 030/100] dmaengine: idxd: fix abort status check
Date:   Fri, 24 Sep 2021 14:43:39 +0200
Message-Id: <20210924124342.462199245@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit b60bb6e2bfc192091b8f792781b83b5e0f9324f6 ]

Coverity static analysis of linux-next found issue.

The check (status == IDXD_COMP_DESC_ABORT) is always false since status
was previously masked with 0x7f and IDXD_COMP_DESC_ABORT is 0xff.

Fixes: 6b4b87f2c31a ("dmaengine: idxd: fix submission race window")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162698465160.3560828.18173186265683415384.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 2924819ca8f3..ba839d3569cd 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -269,7 +269,11 @@ static int irq_process_pending_llist(struct idxd_irq_entry *irq_entry,
 		u8 status = desc->completion->status & DSA_COMP_STATUS_MASK;
 
 		if (status) {
-			if (unlikely(status == IDXD_COMP_DESC_ABORT)) {
+			/*
+			 * Check against the original status as ABORT is software defined
+			 * and 0xff, which DSA_COMP_STATUS_MASK can mask out.
+			 */
+			if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT)) {
 				complete_desc(desc, IDXD_COMPLETE_ABORT);
 				(*processed)++;
 				continue;
@@ -333,7 +337,11 @@ static int irq_process_work_list(struct idxd_irq_entry *irq_entry,
 	list_for_each_entry(desc, &flist, list) {
 		u8 status = desc->completion->status & DSA_COMP_STATUS_MASK;
 
-		if (unlikely(status == IDXD_COMP_DESC_ABORT)) {
+		/*
+		 * Check against the original status as ABORT is software defined
+		 * and 0xff, which DSA_COMP_STATUS_MASK can mask out.
+		 */
+		if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT)) {
 			complete_desc(desc, IDXD_COMPLETE_ABORT);
 			continue;
 		}
-- 
2.33.0



