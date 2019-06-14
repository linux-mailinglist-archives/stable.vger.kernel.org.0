Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3530467B0
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 20:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfFNSl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 14:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNSl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 14:41:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B79FB2183E;
        Fri, 14 Jun 2019 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560537718;
        bh=llhU7zeecYQzudCq3xv2Zhh6izM8HMVzYDqfQ9yCTPA=;
        h=Date:From:To:Subject:From;
        b=SQTClMwF54IgqGgt5mJXW+c6oC2H+pjZGi1Efg3YLqu+lG1ob+RExjd3M8ohAEOI1
         ZQk3mjZfyXdzZxopYIQxtE4jPnMzB9Ar4hHkgJuttpA7XbLH24KFtXGqgXWUvwXJGa
         RzuXdo9152R+BDVKmVwFavWFBhyBtoDutVcTP98g=
Date:   Fri, 14 Jun 2019 11:41:57 -0700
From:   akpm@linux-foundation.org
To:     daniel.sobe@nxp.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org,
        wen.gang.wang@oracle.com
Subject:  [merged]
 fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch removed from -mm tree
Message-ID: <20190614184157.yfEQQutNy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/ocfs2: fix race in ocfs2_dentry_attach_lock()
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

ocfs2_dentry_attach_lock() can be executed in parallel threads against the
same dentry.  Make that race safe.  The race is like this:

            thread A                               thread B

(A1) enter ocfs2_dentry_attach_lock,
seeing dentry->d_fsdata is NULL,
and no alias found by
ocfs2_find_local_alias, so kmalloc
a new ocfs2_dentry_lock structure
to local variable "dl", dl1

               .....

                                    (B1) enter ocfs2_dentry_attach_lock,
                                    seeing dentry->d_fsdata is NULL,
                                    and no alias found by
                                    ocfs2_find_local_alias so kmalloc
                                    a new ocfs2_dentry_lock structure
                                    to local variable "dl", dl2.

                                                   ......

(A2) set dentry->d_fsdata with dl1,
call ocfs2_dentry_lock() and increase
dl1->dl_lockres.l_ro_holders to 1 on
success.
              ......

                                    (B2) set dentry->d_fsdata with dl2
                                    call ocfs2_dentry_lock() and increase
				    dl2->dl_lockres.l_ro_holders to 1 on
				    success.

                                                  ......

(A3) call ocfs2_dentry_unlock()
and decrease
dl2->dl_lockres.l_ro_holders to 0
on success.
             ....

                                    (B3) call ocfs2_dentry_unlock(),
                                    decreasing
				    dl2->dl_lockres.l_ro_holders, but
				    see it's zero now, panic

Link: http://lkml.kernel.org/r/20190529174636.22364-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reported-by: Daniel Sobe <daniel.sobe@nxp.com>
Tested-by: Daniel Sobe <daniel.sobe@nxp.com>
Reviewed-by: Changwei Ge <gechangwei@live.cn>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dcache.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ocfs2/dcache.c~fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock
+++ a/fs/ocfs2/dcache.c
@@ -296,6 +296,18 @@ int ocfs2_dentry_attach_lock(struct dent
 
 out_attach:
 	spin_lock(&dentry_attach_lock);
+	if (unlikely(dentry->d_fsdata && !alias)) {
+		/* d_fsdata is set by a racing thread which is doing
+		 * the same thing as this thread is doing. Leave the racing
+		 * thread going ahead and we return here.
+		 */
+		spin_unlock(&dentry_attach_lock);
+		iput(dl->dl_inode);
+		ocfs2_lock_res_free(&dl->dl_lockres);
+		kfree(dl);
+		return 0;
+	}
+
 	dentry->d_fsdata = dl;
 	dl->dl_count++;
 	spin_unlock(&dentry_attach_lock);
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are


