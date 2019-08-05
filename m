Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D581BEA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfHENEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbfHENEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:04:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A02721738;
        Mon,  5 Aug 2019 13:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010253;
        bh=cG/ZORV+OBhPM708YGZYRmOv6WZOqnnMe2VpjU4BnM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBQK6sFfWSRQFiUpdpsD4vRqzLKATIm8Tnjnu1nl9cmHKG7ZquY81+nnc7MbI+tTY
         sZ9U4dopPHzzEagJvqXyieOV+US4p8mthmOPsBpZ6isN+b8itE5IDxJQqLQIW+k7hN
         sLG7gaBZ72x8SkSi+qvfTvHWuqSlYmLbZ4uhWD/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Andreas Christoforou <andreaschristofo@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/22] ipc/mqueue.c: only perform resource calculation if user valid
Date:   Mon,  5 Aug 2019 15:02:55 +0200
Message-Id: <20190805124922.685455343@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
References: <20190805124918.070468681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 6ed74825ab542..2a39784d57044 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -371,7 +371,6 @@ static void mqueue_evict_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
 	struct user_struct *user;
-	unsigned long mq_bytes, mq_treesize;
 	struct ipc_namespace *ipc_ns;
 	struct msg_msg *msg, *nmsg;
 	LIST_HEAD(tmp_msg);
@@ -394,16 +393,18 @@ static void mqueue_evict_inode(struct inode *inode)
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



