Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EAD1DB703
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgETO3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:29:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60938 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726804AbgETOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:21 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00034z-7T; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DOJ-RC; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Date:   Wed, 20 May 2020 15:13:34 +0100
Message-ID: <lsq.1589984008.79928707@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 06/99] padata: get_next is never NULL
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 69b348449bda0f9588737539cfe135774c9939a7 upstream.

Per Dan's static checker warning, the code that returns NULL was removed
in 2010, so this patch updates the comments and fixes the code
assumptions.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/padata.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -153,8 +153,6 @@ EXPORT_SYMBOL(padata_do_parallel);
  * A pointer to the control struct of the next object that needs
  * serialization, if present in one of the percpu reorder queues.
  *
- * NULL, if all percpu reorder queues are empty.
- *
  * -EINPROGRESS, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
@@ -181,8 +179,6 @@ static struct padata_priv *padata_get_ne
 	cpu = padata_index_to_cpu(pd, next_index);
 	next_queue = per_cpu_ptr(pd->pqueue, cpu);
 
-	padata = NULL;
-
 	reorder = &next_queue->reorder;
 
 	spin_lock(&reorder->lock);
@@ -234,12 +230,11 @@ static void padata_reorder(struct parall
 		padata = padata_get_next(pd);
 
 		/*
-		 * All reorder queues are empty, or the next object that needs
-		 * serialization is parallel processed by another cpu and is
-		 * still on it's way to the cpu's reorder queue, nothing to
-		 * do for now.
+		 * If the next object that needs serialization is parallel
+		 * processed by another cpu and is still on it's way to the
+		 * cpu's reorder queue, nothing to do for now.
 		 */
-		if (!padata || PTR_ERR(padata) == -EINPROGRESS)
+		if (PTR_ERR(padata) == -EINPROGRESS)
 			break;
 
 		/*

