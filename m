Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0D31E2EC6
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgEZTbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390346AbgEZS61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B375F208B3;
        Tue, 26 May 2020 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519507;
        bh=Q0mdcF2oU/bh0nji/h7eSWN/ItT2o83JBEzU6HfSmMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1DhE66ceFT8Sf/fe7qDF9RCWNTlUe5MsxGOX0o9SkYZuwwveAwQaLCu/mmgpzaYB
         RZseVXnYiKKinEfaarnmM0ohL6be0zugcjBAKf5ZgwnzdvsFN0qnjCzxgSAt3C2GhM
         0tPBBw2HhusjzUVWRmfE8FBAxCpMRJuBkvym7Ppc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 03/64] padata: get_next is never NULL
Date:   Tue, 26 May 2020 20:52:32 +0200
Message-Id: <20200526183914.315757266@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 69b348449bda0f9588737539cfe135774c9939a7 upstream.

Per Dan's static checker warning, the code that returns NULL was removed
in 2010, so this patch updates the comments and fixes the code
assumptions.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/padata.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -156,8 +156,6 @@ EXPORT_SYMBOL(padata_do_parallel);
  * A pointer to the control struct of the next object that needs
  * serialization, if present in one of the percpu reorder queues.
  *
- * NULL, if all percpu reorder queues are empty.
- *
  * -EINPROGRESS, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
@@ -184,8 +182,6 @@ static struct padata_priv *padata_get_ne
 	cpu = padata_index_to_cpu(pd, next_index);
 	next_queue = per_cpu_ptr(pd->pqueue, cpu);
 
-	padata = NULL;
-
 	reorder = &next_queue->reorder;
 
 	spin_lock(&reorder->lock);
@@ -237,12 +233,11 @@ static void padata_reorder(struct parall
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


