Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D83103FF0
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbfKTPrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:47:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52520 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729435AbfKTPkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:15 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004aU-SY; Wed, 20 Nov 2019 15:40:11 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004Gm-61; Wed, 20 Nov 2019 15:40:11 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ondrej Mosnacek" <omosnace@redhat.com>,
        syzbot+fee3a14d4cdf92646287@syzkaller.appspotmail.com,
        "Paul Moore" <paul@paul-moore.com>
Date:   Wed, 20 Nov 2019 15:37:27 +0000
Message-ID: <lsq.1574264230.799379366@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 17/83] selinux: fix memory leak in policydb_init()
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 45385237f65aeee73641f1ef737d7273905a233f upstream.

Since roles_init() adds some entries to the role hash table, we need to
destroy also its keys/values on error, otherwise we get a memory leak in
the error path.

Reported-by: syzbot+fee3a14d4cdf92646287@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/ss/policydb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -261,6 +261,8 @@ static int rangetr_cmp(struct hashtab *h
 	return v;
 }
 
+static int (*destroy_f[SYM_NUM]) (void *key, void *datum, void *datap);
+
 /*
  * Initialize a policy database structure.
  */
@@ -304,8 +306,10 @@ static int policydb_init(struct policydb
 out:
 	hashtab_destroy(p->filename_trans);
 	hashtab_destroy(p->range_tr);
-	for (i = 0; i < SYM_NUM; i++)
+	for (i = 0; i < SYM_NUM; i++) {
+		hashtab_map(p->symtab[i].table, destroy_f[i], NULL);
 		hashtab_destroy(p->symtab[i].table);
+	}
 	return rc;
 }
 

