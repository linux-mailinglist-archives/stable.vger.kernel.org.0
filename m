Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F67D2E875
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 00:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfE2WsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 18:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfE2WsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 18:48:22 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBF90242B3;
        Wed, 29 May 2019 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559170101;
        bh=+QXUbn918D66Zh2OtpvPlRYZbV4P5ROdPkYpx8/Iekg=;
        h=Date:From:To:Subject:From;
        b=mK72iELA8fjrtqVA6NdVRzjEdBIhOUirGla3CRuxaV3GWRrwAOre+DJmzDwxedZ6J
         cnoyxZU7LZN0TU8QIHoJJn+6TGvQS/LtD/dFOhYbraNTn3PktjYHlkakqeWmtmUmqG
         Jcm4LhAwLSvgs8/vjWOIgyq+4B+u/IwvdabDHJvI=
Date:   Wed, 29 May 2019 15:48:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, jiangqi903@gmail.com, ghe@suse.com,
        gechangwei@live.cn, daniel.sobe@nxp.com, wen.gang.wang@oracle.com
Subject:  + fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch added
 to -mm tree
Message-ID: <20190529224820.ypSCF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/ocfs2: fix race in ocfs2_dentry_attach_lock()
has been added to the -mm tree.  Its filename is
     fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dcache.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ocfs2/dcache.c~fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock
+++ a/fs/ocfs2/dcache.c
@@ -310,6 +310,18 @@ int ocfs2_dentry_attach_lock(struct dent
 
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

fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch

