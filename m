Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8D1E2A5E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389413AbgEZSzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389398AbgEZSzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E7EF208C3;
        Tue, 26 May 2020 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519315;
        bh=K997vUReKo1Eu7O2mp1JLzaOpovFSgasgP9aL7NtB+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3PRGKScyKupNgRntLWzDv5HK48gz3XRiaBBDAUCgT+giABNVXxKM8KzbAVGW3Ts+
         nyPZyHVMkvXq/Z7GsKGkB1NpE38qlx57ZEoKbBjmQylaLgQROzpTiS2rIVXrfgAHTg
         d3jGmubKeVhzM4HBmn7HfatbT2hVUh0jx0ZfnPM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 03/65] padata: get_next is never NULL
Date:   Tue, 26 May 2020 20:52:22 +0200
Message-Id: <20200526183907.627545971@linuxfoundation.org>
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
@@ -155,8 +155,6 @@ EXPORT_SYMBOL(padata_do_parallel);
  * A pointer to the control struct of the next object that needs
  * serialization, if present in one of the percpu reorder queues.
  *
- * NULL, if all percpu reorder queues are empty.
- *
  * -EINPROGRESS, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
@@ -183,8 +181,6 @@ static struct padata_priv *padata_get_ne
 	cpu = padata_index_to_cpu(pd, next_index);
 	next_queue = per_cpu_ptr(pd->pqueue, cpu);
 
-	padata = NULL;
-
 	reorder = &next_queue->reorder;
 
 	spin_lock(&reorder->lock);
@@ -236,12 +232,11 @@ static void padata_reorder(struct parall
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


