Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F310B76948
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfGZNoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbfGZNoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED1AD22CC2;
        Fri, 26 Jul 2019 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148659;
        bh=ReSA94CIdujhJKUsAsbmby+7RgWf/Uf3BIh9XjxoAcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeCg7SklFefwA5fasKflYJpET6R1MDL9KKPKisE6zwJwFbLaFEcV0SFhAvrw7xt7V
         QbhZ1Ap7HTUcYq98qPIIBNjeT/FMQ69A9wMCDZrBdXEC7DYhwntVM/mIF1xs4Brgfl
         1AxIVoVC6yqmREoGltPgQzCAbbX/QyW2P4MDlQn0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Andreas Christoforou <andreaschristofo@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 29/37] ipc/mqueue.c: only perform resource calculation if user valid
Date:   Fri, 26 Jul 2019 09:43:24 -0400
Message-Id: <20190726134332.12626-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a318f12ed8843cfac53198390c74a565c632f417 ]

Andreas Christoforou reported:

  UBSAN: Undefined behaviour in ipc/mqueue.c:414:49 signed integer overflow:
  9 * 2305843009213693951 cannot be represented in type 'long int'
  ...
  Call Trace:
    mqueue_evict_inode+0x8e7/0xa10 ipc/mqueue.c:414
    evict+0x472/0x8c0 fs/inode.c:558
    iput_final fs/inode.c:1547 [inline]
    iput+0x51d/0x8c0 fs/inode.c:1573
    mqueue_get_inode+0x8eb/0x1070 ipc/mqueue.c:320
    mqueue_create_attr+0x198/0x440 ipc/mqueue.c:459
    vfs_mkobj+0x39e/0x580 fs/namei.c:2892
    prepare_open ipc/mqueue.c:731 [inline]
    do_mq_open+0x6da/0x8e0 ipc/mqueue.c:771

Which could be triggered by:

        struct mq_attr attr = {
                .mq_flags = 0,
                .mq_maxmsg = 9,
                .mq_msgsize = 0x1fffffffffffffff,
                .mq_curmsgs = 0,
        };

        if (mq_open("/testing", 0x40, 3, &attr) == (mqd_t) -1)
                perror("mq_open");

mqueue_get_inode() was correctly rejecting the giant mq_msgsize, and
preparing to return -EINVAL.  During the cleanup, it calls
mqueue_evict_inode() which performed resource usage tracking math for
updating "user", before checking if there was a valid "user" at all
(which would indicate that the calculations would be sane).  Instead,
delay this check to after seeing a valid "user".

The overflow was real, but the results went unused, so while the flaw is
harmless, it's noisy for kernel fuzzers, so just fix it by moving the
calculation under the non-NULL "user" where it actually gets used.

Link: http://lkml.kernel.org/r/201906072207.ECB65450@keescook
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Andreas Christoforou <andreaschristofo@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 5c0ae912f2f2..dccd4ecb786a 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -372,7 +372,6 @@ static void mqueue_evict_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
 	struct user_struct *user;
-	unsigned long mq_bytes, mq_treesize;
 	struct ipc_namespace *ipc_ns;
 	struct msg_msg *msg, *nmsg;
 	LIST_HEAD(tmp_msg);
@@ -395,16 +394,18 @@ static void mqueue_evict_inode(struct inode *inode)
 		free_msg(msg);
 	}
 
-	/* Total amount of bytes accounted for the mqueue */
-	mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
-		min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
-		sizeof(struct posix_msg_tree_node);
-
-	mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
-				  info->attr.mq_msgsize);
-
 	user = info->user;
 	if (user) {
+		unsigned long mq_bytes, mq_treesize;
+
+		/* Total amount of bytes accounted for the mqueue */
+		mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
+			min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
+			sizeof(struct posix_msg_tree_node);
+
+		mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
+					  info->attr.mq_msgsize);
+
 		spin_lock(&mq_lock);
 		user->mq_bytes -= mq_bytes;
 		/*
-- 
2.20.1

