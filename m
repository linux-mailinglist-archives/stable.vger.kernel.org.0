Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C13D1E2F10
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389595AbgEZSzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389588AbgEZSzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 080BE2086A;
        Tue, 26 May 2020 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519337;
        bh=6m/IfFYaFt/e5IWF5yeM6upXhY42/0Q6gHupJx6rjpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzICOvwdhRwyxfxMe8P7QXvMMQL8WevHiwW+LUHqpsAZfjNXj28pCrCK8us3jXjBY
         s0KtKVAFt1L5y5lCV8qTxFUOmk9idMmrOTQy5hLl6tM0eu4QXgZsp06uwGjEgOkO5d
         7LkCAJ8SXnrDbflmuqgW3yfhM7nOtU5B983W3AwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/65] padata: purge get_cpu and reorder_via_wq from padata_do_serial
Date:   Tue, 26 May 2020 20:52:48 +0200
Message-Id: <20200526183916.921551979@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 065cf577135a4977931c7a1e1edf442bfd9773dd]

With the removal of the padata timer, padata_do_serial no longer
needs special CPU handling, so remove it.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 43b72f5dfe07..c50975f43b34 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -322,24 +322,9 @@ static void padata_serial_worker(struct work_struct *serial_work)
  */
 void padata_do_serial(struct padata_priv *padata)
 {
-	int cpu;
-	struct padata_parallel_queue *pqueue;
-	struct parallel_data *pd;
-	int reorder_via_wq = 0;
-
-	pd = padata->pd;
-
-	cpu = get_cpu();
-
-	/* We need to enqueue the padata object into the correct
-	 * per-cpu queue.
-	 */
-	if (cpu != padata->cpu) {
-		reorder_via_wq = 1;
-		cpu = padata->cpu;
-	}
-
-	pqueue = per_cpu_ptr(pd->pqueue, cpu);
+	struct parallel_data *pd = padata->pd;
+	struct padata_parallel_queue *pqueue = per_cpu_ptr(pd->pqueue,
+							   padata->cpu);
 
 	spin_lock(&pqueue->reorder.lock);
 	list_add_tail(&padata->list, &pqueue->reorder.list);
@@ -353,8 +338,6 @@ void padata_do_serial(struct padata_priv *padata)
 	 */
 	smp_mb__after_atomic();
 
-	put_cpu();
-
 	padata_reorder(pd);
 }
 EXPORT_SYMBOL(padata_do_serial);
-- 
2.25.1



