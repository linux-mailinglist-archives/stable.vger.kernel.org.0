Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89B18B732
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgCSNRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgCSNQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C952098B;
        Thu, 19 Mar 2020 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623819;
        bh=QxtaDxcfQEQ1UKz0PJyRYKh2BCVbPnsBm3vuLhOG/lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AL0twPKEWbf454bozPApl9kC4TKPTJlI03qfrZSRCvrKvGJ+rz8OoB4wKoVT5+bWP
         a6lEa/iNrKDX6shrxnhE2vqcLg3p1PY3IODCOSsTV1ezgOuMqrLZegdz0Q4IGSEf9u
         ToXW1VAF1EXAAtw9g3T0mRA9k1X9v7J5acu+zUu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.14 37/99] cgroup: cgroup_procs_next should increase position index
Date:   Thu, 19 Mar 2020 14:03:15 +0100
Message-Id: <20200319123953.062335196@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
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
@@ -4249,6 +4249,9 @@ static void *cgroup_procs_next(struct se
 	struct kernfs_open_file *of = s->private;
 	struct css_task_iter *it = of->priv;
 
+	if (pos)
+		(*pos)++;
+
 	return css_task_iter_next(it);
 }
 
@@ -4264,7 +4267,7 @@ static void *__cgroup_procs_start(struct
 	 * from position 0, so we can simply keep iterating on !0 *pos.
 	 */
 	if (!it) {
-		if (WARN_ON_ONCE((*pos)++))
+		if (WARN_ON_ONCE((*pos)))
 			return ERR_PTR(-EINVAL);
 
 		it = kzalloc(sizeof(*it), GFP_KERNEL);
@@ -4272,10 +4275,11 @@ static void *__cgroup_procs_start(struct
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


