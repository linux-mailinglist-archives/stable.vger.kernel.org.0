Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AF4B1F64
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390367AbfIMNTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390356AbfIMNTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:05 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4613C20640;
        Fri, 13 Sep 2019 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380744;
        bh=Rsf/Khn2abksNM7glqVkUKryyHY9WwZ/3izWFKCXi04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgk6kqZZN8ZVPT6+gOOpy254aFaSJ2LDlUqi8QNIL06dJD+21ErfAdWTNfySbeLr8
         jOd9EGJ5PEm0n1TpyszBmjUCFzF6wNAxXAqAI/jDzx4pmdWm79Qk637QTRS9SGcpUf
         hxDQ6/mHP//1sRx+CmJ3ank38vzBbMRP7c0hVj+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/190] IB/hfi1: Avoid hardlockup with flushlist_lock
Date:   Fri, 13 Sep 2019 14:06:38 +0100
Message-Id: <20190913130611.424105762@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cf131a81967583ae737df6383a0893b9fee75b4e ]

Heavy contention of the sde flushlist_lock can cause hard lockups at
extreme scale when the flushing logic is under stress.

Mitigate by replacing the item at a time copy to the local list with
an O(1) list_splice_init() and using the high priority work queue to
do the flushes.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 88e326d6cc494..d648a4167832c 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -410,10 +410,7 @@ static void sdma_flush(struct sdma_engine *sde)
 	sdma_flush_descq(sde);
 	spin_lock_irqsave(&sde->flushlist_lock, flags);
 	/* copy flush list */
-	list_for_each_entry_safe(txp, txp_next, &sde->flushlist, list) {
-		list_del_init(&txp->list);
-		list_add_tail(&txp->list, &flushlist);
-	}
+	list_splice_init(&sde->flushlist, &flushlist);
 	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
 	/* flush from flush list */
 	list_for_each_entry_safe(txp, txp_next, &flushlist, list)
@@ -2426,7 +2423,7 @@ unlock_noconn:
 		wait->tx_count++;
 		wait->count += tx->num_desc;
 	}
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto unlock;
 nodesc:
@@ -2526,7 +2523,7 @@ unlock_noconn:
 		}
 	}
 	spin_unlock(&sde->flushlist_lock);
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto update_tail;
 nodesc:
-- 
2.20.1



