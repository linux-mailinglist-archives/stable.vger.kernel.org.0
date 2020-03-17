Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D91218812D
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgCQLKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbgCQLKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D33A6205ED;
        Tue, 17 Mar 2020 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443405;
        bh=vbM1ab9MOzUQ7RvdFb1lG1mzaZA/Gi5HLNjFhLPiMrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtfMoOMJMizxU/p/WQI20Z7eX/a8sc+4udYFBGYdLX8tfOwJ5UXLCRLUaDIfUoHJK
         mC56e0ZR1+xICMk4VSqJLTLJyINSV4bRMmq6QhBKafk1MDumk3W6vWnimFt1vQ4iGu
         wZVj1hqi6RW8ifmS2TWyl7rA2l/Vf7pNf+/VIo+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.5 073/151] cgroup: cgroup_procs_next should increase position index
Date:   Tue, 17 Mar 2020 11:54:43 +0100
Message-Id: <20200317103331.670890249@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 2d4ecb030dcc90fb725ecbfc82ce5d6c37906e0e upstream.

If seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output:

1) dd bs=1 skip output of each 2nd elements
$ dd if=/sys/fs/cgroup/cgroup.procs bs=8 count=1
2
3
4
5
1+0 records in
1+0 records out
8 bytes copied, 0,000267297 s, 29,9 kB/s
[test@localhost ~]$ dd if=/sys/fs/cgroup/cgroup.procs bs=1 count=8
2
4 <<< NB! 3 was skipped
6 <<<    ... and 5 too
8 <<<    ... and 7
8+0 records in
8+0 records out
8 bytes copied, 5,2123e-05 s, 153 kB/s

 This happen because __cgroup_procs_start() makes an extra
 extra cgroup_procs_next() call

2) read after lseek beyond end of file generates whole last line.
3) read after lseek into middle of last line generates
expected rest of last line and unexpected whole line once again.

Additionally patch removes an extra position index changes in
__cgroup_procs_start()

Cc: stable@vger.kernel.org
https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4600,6 +4600,9 @@ static void *cgroup_procs_next(struct se
 	struct kernfs_open_file *of = s->private;
 	struct css_task_iter *it = of->priv;
 
+	if (pos)
+		(*pos)++;
+
 	return css_task_iter_next(it);
 }
 
@@ -4615,7 +4618,7 @@ static void *__cgroup_procs_start(struct
 	 * from position 0, so we can simply keep iterating on !0 *pos.
 	 */
 	if (!it) {
-		if (WARN_ON_ONCE((*pos)++))
+		if (WARN_ON_ONCE((*pos)))
 			return ERR_PTR(-EINVAL);
 
 		it = kzalloc(sizeof(*it), GFP_KERNEL);
@@ -4623,10 +4626,11 @@ static void *__cgroup_procs_start(struct
 			return ERR_PTR(-ENOMEM);
 		of->priv = it;
 		css_task_iter_start(&cgrp->self, iter_flags, it);
-	} else if (!(*pos)++) {
+	} else if (!(*pos)) {
 		css_task_iter_end(it);
 		css_task_iter_start(&cgrp->self, iter_flags, it);
-	}
+	} else
+		return it->cur_task;
 
 	return cgroup_procs_next(s, NULL, NULL);
 }


