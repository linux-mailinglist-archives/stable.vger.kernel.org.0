Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097D081A3E
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbfHENEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbfHENEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:04:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 580EE2173C;
        Mon,  5 Aug 2019 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010260;
        bh=j8uzukzOaljmQbwdKf6UHODmpG6duIbaQra2BZu+GU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhFTus651N5ZyhGpZe82kr4EauJBE0S/K+SH+MnkG2g8p4n87tObC4MeCFvekyoHy
         wuqBghgaVwO68epN0It12pvI1sr3/a/sQHRr1YQeZLJbXfIby6CHnRBskr+Byw98Ez
         Rm3XgkZ6PMouNat7aD/6RENPYXVwVBtgDOqkjIas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fee3a14d4cdf92646287@syzkaller.appspotmail.com,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.4 20/22] selinux: fix memory leak in policydb_init()
Date:   Mon,  5 Aug 2019 15:02:57 +0200
Message-Id: <20190805124923.189417648@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
References: <20190805124918.070468681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 45385237f65aeee73641f1ef737d7273905a233f upstream.

Since roles_init() adds some entries to the role hash table, we need to
destroy also its keys/values on error, otherwise we get a memory leak in
the error path.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+fee3a14d4cdf92646287@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/ss/policydb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -266,6 +266,8 @@ static int rangetr_cmp(struct hashtab *h
 	return v;
 }
 
+static int (*destroy_f[SYM_NUM]) (void *key, void *datum, void *datap);
+
 /*
  * Initialize a policy database structure.
  */
@@ -313,8 +315,10 @@ static int policydb_init(struct policydb
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
 


