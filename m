Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33480493EE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfFQVYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbfFQVYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3062720657;
        Mon, 17 Jun 2019 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806663;
        bh=z5SKF9DOlqPNls6ia41cYM6baailNmIznIbwfYklA1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dz7m3Mq1JAHhcharkasbeM3WVJ5OeBjRj+pCem74oaSeXouXszevFa1lSfSo79TZf
         EnX5GpgREdz+mVPivD1mOVWNEaqXy+4F/B+RFgWq8VnYKJWWtfm9bpxLKrJSCrGJ2b
         Xz6OKD4NVzowXLpt/VfFt6BUh7BCVluSEP1vFiNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>,
        Daniel Sobe <daniel.sobe@nxp.com>,
        Changwei Ge <gechangwei@live.cn>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 15/75] fs/ocfs2: fix race in ocfs2_dentry_attach_lock()
Date:   Mon, 17 Jun 2019 23:09:26 +0200
Message-Id: <20190617210753.468996710@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/dcache.c |   12 ++++++++++++
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


