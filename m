Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33D24BA22
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgHTJ7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgHTJ7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:59:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60ED42067C;
        Thu, 20 Aug 2020 09:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917570;
        bh=n+n8NkrHJ2HWvE4B677OiYeKujjie+S6BlRnqfhaS0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxSkafZEr4a7m1+jn/DO0OtcFWA8qvw5rfC5b5MSSrbMcDGO4+piUsQLmmGJlIzB+
         5ehoz9OEnYRleg2ON1eYuG6saReUj1EEoQws9onyxJO4vLKmLac12k+AX1rWcA62HV
         3IjyGiMlYpZckyfTNxhI/cG5yrFclOOzz5Y3lW0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.9 078/212] Smack: fix use-after-free in smk_write_relabel_self()
Date:   Thu, 20 Aug 2020 11:20:51 +0200
Message-Id: <20200820091606.305515947@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/smack/smackfs.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2741,7 +2741,6 @@ static int smk_open_relabel_self(struct
 static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
 	char *data;
 	int rc;
 	LIST_HEAD(list_tmp);
@@ -2766,11 +2765,21 @@ static ssize_t smk_write_relabel_self(st
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


