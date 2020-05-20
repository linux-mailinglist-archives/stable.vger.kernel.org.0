Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65171DB6F2
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgETOWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:22:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60936 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726805AbgETOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:21 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00034y-78; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DOD-QL; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Date:   Wed, 20 May 2020 15:13:33 +0100
Message-ID: <lsq.1589984008.290826964@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 05/99] padata: avoid race in reordering
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

commit de5540d088fe97ad583cc7d396586437b32149a5 upstream.

Under extremely heavy uses of padata, crashes occur, and with list
debugging turned on, this happens instead:

[87487.298728] WARNING: CPU: 1 PID: 882 at lib/list_debug.c:33
__list_add+0xae/0x130
[87487.301868] list_add corruption. prev->next should be next
(ffffb17abfc043d0), but was ffff8dba70872c80. (prev=ffff8dba70872b00).
[87487.339011]  [<ffffffff9a53d075>] dump_stack+0x68/0xa3
[87487.342198]  [<ffffffff99e119a1>] ? console_unlock+0x281/0x6d0
[87487.345364]  [<ffffffff99d6b91f>] __warn+0xff/0x140
[87487.348513]  [<ffffffff99d6b9aa>] warn_slowpath_fmt+0x4a/0x50
[87487.351659]  [<ffffffff9a58b5de>] __list_add+0xae/0x130
[87487.354772]  [<ffffffff9add5094>] ? _raw_spin_lock+0x64/0x70
[87487.357915]  [<ffffffff99eefd66>] padata_reorder+0x1e6/0x420
[87487.361084]  [<ffffffff99ef0055>] padata_do_serial+0xa5/0x120

padata_reorder calls list_add_tail with the list to which its adding
locked, which seems correct:

spin_lock(&squeue->serial.lock);
list_add_tail(&padata->list, &squeue->serial.list);
spin_unlock(&squeue->serial.lock);

This therefore leaves only place where such inconsistency could occur:
if padata->list is added at the same time on two different threads.
This pdata pointer comes from the function call to
padata_get_next(pd), which has in it the following block:

next_queue = per_cpu_ptr(pd->pqueue, cpu);
padata = NULL;
reorder = &next_queue->reorder;
if (!list_empty(&reorder->list)) {
       padata = list_entry(reorder->list.next,
                           struct padata_priv, list);
       spin_lock(&reorder->lock);
       list_del_init(&padata->list);
       atomic_dec(&pd->reorder_objects);
       spin_unlock(&reorder->lock);

       pd->processed++;

       goto out;
}
out:
return padata;

I strongly suspect that the problem here is that two threads can race
on reorder list. Even though the deletion is locked, call to
list_entry is not locked, which means it's feasible that two threads
pick up the same padata object and subsequently call list_add_tail on
them at the same time. The fix is thus be hoist that lock outside of
that block.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/padata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -185,19 +185,20 @@ static struct padata_priv *padata_get_ne
 
 	reorder = &next_queue->reorder;
 
+	spin_lock(&reorder->lock);
 	if (!list_empty(&reorder->list)) {
 		padata = list_entry(reorder->list.next,
 				    struct padata_priv, list);
 
-		spin_lock(&reorder->lock);
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
-		spin_unlock(&reorder->lock);
 
 		pd->processed++;
 
+		spin_unlock(&reorder->lock);
 		goto out;
 	}
+	spin_unlock(&reorder->lock);
 
 	if (__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);

