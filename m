Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA341E2F29
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389153AbgEZSyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbgEZSyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:54:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CD9C207FB;
        Tue, 26 May 2020 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519288;
        bh=ndlsGo9CG4KB47l0cX6yHBs/uO2HRZHZPAYIShWTe5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhcA+pWnFNNDEX1LsncMvO6Prbl13HLTAyFMJ4qXnJd33GyhxuI/sg4UGhVm5J3+r
         IG/nfTXewka3Q9uZe4r1LPZJlV3sB0X20oP4OMfsceSFb+C8QREQcDHYgupnHg+J+2
         /BcwmqNCU4LbdyYfJIK6/4rwxChdkLAoBdUkaS34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 02/65] padata: Remove unused but set variables
Date:   Tue, 26 May 2020 20:52:21 +0200
Message-Id: <20200526183907.344060994@linuxfoundation.org>
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

From: Tobias Klauser <tklauser@distanz.ch>

commit 119a0798dc42ed4c4f96d39b8b676efcea73aec6 upstream.

Remove the unused but set variable pinst in padata_parallel_worker to
fix the following warning when building with 'W=1':

  kernel/padata.c: In function ‘padata_parallel_worker’:
  kernel/padata.c:68:26: warning: variable ‘pinst’ set but not used [-Wunused-but-set-variable]

Also remove the now unused variable pd which is only used to set pinst.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/padata.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -65,15 +65,11 @@ static int padata_cpu_hash(struct parall
 static void padata_parallel_worker(struct work_struct *parallel_work)
 {
 	struct padata_parallel_queue *pqueue;
-	struct parallel_data *pd;
-	struct padata_instance *pinst;
 	LIST_HEAD(local_list);
 
 	local_bh_disable();
 	pqueue = container_of(parallel_work,
 			      struct padata_parallel_queue, work);
-	pd = pqueue->pd;
-	pinst = pd->pinst;
 
 	spin_lock(&pqueue->parallel.lock);
 	list_replace_init(&pqueue->parallel.list, &local_list);


