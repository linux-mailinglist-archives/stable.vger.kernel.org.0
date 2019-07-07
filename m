Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41C2616C2
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfGGTmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:42:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57660 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727619AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006jk-9m; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005dn-0j; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.708190140@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 093/129] NFSv4.1: Reinitialise sequence results
 before retransmitting a request
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c1dffe0bf7f9c3d57d9f237a7cb2a81e62babd2b upstream.

If we have to retransmit a request, we should ensure that we reinitialise
the sequence results structure, since in the event of a signal
we need to treat the request as if it had not been sent.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -694,6 +694,13 @@ static int nfs4_sequence_done(struct rpc
 	return nfs41_sequence_done(task, res);
 }
 
+static void nfs41_sequence_res_init(struct nfs4_sequence_res *res)
+{
+	res->sr_timestamp = jiffies;
+	res->sr_status_flags = 0;
+	res->sr_status = 1;
+}
+
 int nfs41_setup_sequence(struct nfs4_session *session,
 				struct nfs4_sequence_args *args,
 				struct nfs4_sequence_res *res,
@@ -735,15 +742,9 @@ int nfs41_setup_sequence(struct nfs4_ses
 			slot->slot_nr, slot->seq_nr);
 
 	res->sr_slot = slot;
-	res->sr_timestamp = jiffies;
-	res->sr_status_flags = 0;
-	/*
-	 * sr_status is only set in decode_sequence, and so will remain
-	 * set to 1 if an rpc level failure occurs.
-	 */
-	res->sr_status = 1;
 	trace_nfs4_setup_sequence(session, args);
 out_success:
+	nfs41_sequence_res_init(res);
 	rpc_call_start(task);
 	return 0;
 out_sleep:

