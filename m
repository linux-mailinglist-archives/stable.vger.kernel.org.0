Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314D923F0C7
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGQOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 12:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgHGQOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 12:14:37 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2407D2065E;
        Fri,  7 Aug 2020 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596816877;
        bh=EZ95wbeqbSW+QwR189FPk2U69kerKfYvd/9xSyu+Sno=;
        h=From:To:Cc:Subject:Date:From;
        b=Ga++VxnuNCskNN1HQQSS4pc61zB7Vj/mM5/VmS3eULFKjXXQ6O72cPImAFw2iMeyp
         cKXL9lc+bsNdRhI1V/NMwAqwEwRJ0kJ0r54K3m7kg4TUv3u6zjuYV6NDLYvNgTd2dk
         L+ool0q9jfGxrYQbUtkxdWpRJ/9DBALtx/xhqwts=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org,
        syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.19/4.14/4.9/4.4] Smack: fix use-after-free in smk_write_relabel_self()
Date:   Fri,  7 Aug 2020 09:13:24 -0700
Message-Id: <20200807161324.1690303-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit beb4ee6770a89646659e6a2178538d2b13e2654e upstream.

smk_write_relabel_self() frees memory from the task's credentials with
no locking, which can easily cause a use-after-free because multiple
tasks can share the same credentials structure.

Fix this by using prepare_creds() and commit_creds() to correctly modify
the task's credentials.

Reproducer for "BUG: KASAN: use-after-free in smk_write_relabel_self":

	#include <fcntl.h>
	#include <pthread.h>
	#include <unistd.h>

	static void *thrproc(void *arg)
	{
		int fd = open("/sys/fs/smackfs/relabel-self", O_WRONLY);
		for (;;) write(fd, "foo", 3);
	}

	int main()
	{
		pthread_t t;
		pthread_create(&t, NULL, thrproc, NULL);
		thrproc(NULL);
	}

Reported-by: syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com
Fixes: 38416e53936e ("Smack: limited capability for changing process label")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/smack/smackfs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 371ae368da35..10ee51d04492 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2746,7 +2746,6 @@ static int smk_open_relabel_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
 	char *data;
 	int rc;
 	LIST_HEAD(list_tmp);
@@ -2771,11 +2770,21 @@ static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 	kfree(data);
 
 	if (!rc || (rc == -EINVAL && list_empty(&list_tmp))) {
+		struct cred *new;
+		struct task_smack *tsp;
+
+		new = prepare_creds();
+		if (!new) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		tsp = new->security;
 		smk_destroy_label_list(&tsp->smk_relabel);
 		list_splice(&list_tmp, &tsp->smk_relabel);
+		commit_creds(new);
 		return count;
 	}
-
+out:
 	smk_destroy_label_list(&list_tmp);
 	return rc;
 }
-- 
2.28.0.236.gb10cc79966-goog

