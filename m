Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2E1DB6FF
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgETO25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60924 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbgETOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:21 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00034x-7Y; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DO8-PJ; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Tobias Klauser" <tklauser@distanz.ch>
Date:   Wed, 20 May 2020 15:13:32 +0100
Message-ID: <lsq.1589984008.782735810@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 04/99] padata: Remove unused but set variables
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/padata.c | 4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -63,15 +63,11 @@ static int padata_cpu_hash(struct parall
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

