Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3854F81BBF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfHENFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfHENFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18996206C1;
        Mon,  5 Aug 2019 13:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010343;
        bh=j8uzukzOaljmQbwdKf6UHODmpG6duIbaQra2BZu+GU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvASxYQZpjy6woPz6y9Kt6E0OSA3eopBeIKYpRF5E+ciQaE3hNKXLutORcJ/+PQMy
         7MJD/zD6T7K6nENqeP+JPcc+m4fuCBb6fIXq/z4zJsefIU8oF+Q2CXFXtfB//5XTr0
         bNavNet8G9pD69SPovAJT8C0jkibygODMR8Tn+E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fee3a14d4cdf92646287@syzkaller.appspotmail.com,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.9 30/42] selinux: fix memory leak in policydb_init()
Date:   Mon,  5 Aug 2019 15:02:56 +0200
Message-Id: <20190805124928.551046734@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
References: <20190805124924.788666484@linuxfoundation.org>
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
 


