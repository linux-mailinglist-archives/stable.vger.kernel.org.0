Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8FC917F
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfJBTJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:09:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36066 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729364AbfJBTIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:19 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-00036K-Qc; Wed, 02 Oct 2019 20:08:15 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003eZ-2W; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joseph Qi" <joseph.qi@linux.alibaba.com>,
        "Changwei Ge" <gechangwei@live.cn>,
        "Joel Becker" <jlbec@evilplan.org>,
        "Wengang Wang" <wen.gang.wang@oracle.com>,
        "Junxiao Bi" <junxiao.bi@oracle.com>,
        "Mark Fasheh" <mark@fasheh.com>, "Jun Piao" <piaojun@huawei.com>,
        "Daniel Sobe" <daniel.sobe@nxp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Gang He" <ghe@suse.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.332720807@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 59/87] fs/ocfs2: fix race in ocfs2_dentry_attach_lock()
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

commit be99ca2716972a712cde46092c54dee5e6192bf8 upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/dcache.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
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

