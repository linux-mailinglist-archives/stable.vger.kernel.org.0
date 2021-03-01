Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91113328FE4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhCAT6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241943AbhCATrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:47:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A445B652A4;
        Mon,  1 Mar 2021 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619993;
        bh=xi5ywds6ndsXtsKWJum0i7HlDnfoIIj9ew9zl1zd5Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHInl2o7+LxbONXu89ohKFJ2/fqVU2jQ5S4/15XRpAXLDNKdw7jSZCremwuCBPaO8
         3YtvUS+g3LDuG55OufuT1X4QY0PWsIK5t0sUJD/9zRtZcK/yE1LUcEZskry6yyc5OB
         sWAwdWYGztVkBjisWI59Xt9w19RXcrFhhGSl7rMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 625/663] proc: dont allow async path resolution of /proc/thread-self components
Date:   Mon,  1 Mar 2021 17:14:33 +0100
Message-Id: <20210301161212.773203810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 0d4370cfe36b7f1719123b621a4ec4d9c7a25f89 upstream.

If this is attempted by an io-wq kthread, then return -EOPNOTSUPP as we
don't currently support that. Once we can get task_pid_ptr() doing the
right thing, then this can go away again.

Use PF_IO_WORKER for this to speciically target the io_uring workers.
Modify the /proc/self/ check to use PF_IO_WORKER as well.

Cc: stable@vger.kernel.org
Fixes: 8d4c3e76e3be ("proc: don't allow async path resolution of /proc/self components")
Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/self.c        |    2 +-
 fs/proc/thread_self.c |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -20,7 +20,7 @@ static const char *proc_self_get_link(st
 	 * Not currently supported. Once we can inherit all of struct pid,
 	 * we can allow this.
 	 */
-	if (current->flags & PF_KTHREAD)
+	if (current->flags & PF_IO_WORKER)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (!tgid)
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -17,6 +17,13 @@ static const char *proc_thread_self_get_
 	pid_t pid = task_pid_nr_ns(current, ns);
 	char *name;
 
+	/*
+	 * Not currently supported. Once we can inherit all of struct pid,
+	 * we can allow this.
+	 */
+	if (current->flags & PF_IO_WORKER)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!pid)
 		return ERR_PTR(-ENOENT);
 	name = kmalloc(10 + 6 + 10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);


