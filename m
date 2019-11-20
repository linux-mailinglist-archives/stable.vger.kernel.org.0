Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879D31030C5
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 01:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfKTAd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 19:33:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33867 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfKTAd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 19:33:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so26112090wrw.1;
        Tue, 19 Nov 2019 16:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E76BfeULL9Cj6fUQJlzoEE7JObAbPKX1tHKrIvwvWtc=;
        b=Kai3gI91KW3k6mk/gVuFEww7JRPmlzJx9VDlRh96Kaqt5GDq9QcGBAegy9tNpvRgWd
         ihR1QBR1/UJ2MCSfrFqmX82N0dUMiNGuEVs6YGBFhrJhpq8LzgnLbx2MxrrRM5jJqCjS
         Dn3nXjagcSoBnZBzbjN1gb5Y74KKSYVXxtYV0xexRM/5sdnpr6ta7Ub4ME83E/lvPniZ
         8btvSgFUOC3waF9vt2wNt+kiykYTImEsyHK0t5bWhZkS/sRdEwUP9cQ7b+cM8Ji0dfJ6
         gUJxfYkEli/fW57aWMABFbHdUjGMChYRBtX0gr5kKUspKCU1t3ebAruL+o1Z7Deue5Lu
         0bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E76BfeULL9Cj6fUQJlzoEE7JObAbPKX1tHKrIvwvWtc=;
        b=KllBL1PRY/bPwMa3T4N7KwQboazget3d2ZbYLBwCNA7FbC9CIVuBdXoQASTLYwnNb2
         g48XrLDEIPE2QurZ1/5LeYOFtLqcIPi+J+d9J/rCVSxG8rq1UsGQYJOddo4p8fF2epyt
         E2WWGZkNxO6SUUUGRiQiKULD0IZmtxNrc1JdHPHmug7G80m5NXj/pFCzzqPhJhp4nZtc
         a8DmAvBYILSf+ANzR8M1L4q4Mv+4jFGIysArsRswNDx+jgeiGk2R7pSOpYvwtfhgcRvo
         hbKNAwkHTlhy2v7991DUfWPrVCl0LADyzZVk4QFHUwxs/wgl0J6w03kzdJ5ETHd3Bymq
         S8yg==
X-Gm-Message-State: APjAAAVSDOQvKpvUHiYUM6G6vrp7qvp2OFsoSkwWW93SNmnOiJwhNVP2
        Yqx+ePAnkuDPhmB+PzHxngZEbcDK
X-Google-Smtp-Source: APXvYqyRSONgrEN42EpumNWGQlOSyJJv4udxeQzhkD0028iQdWusI7o01LNPMB8SLaXWz6XnGgyVog==
X-Received: by 2002:adf:f743:: with SMTP id z3mr200071wrp.200.1574210004048;
        Tue, 19 Nov 2019 16:33:24 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:40e1:9900:5dce:1599:e3b5:7d61])
        by smtp.gmail.com with ESMTPSA id r25sm4828947wmh.6.2019.11.19.16.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 16:33:23 -0800 (PST)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v2] fork: fix pidfd_poll()'s return type
Date:   Wed, 20 Nov 2019 01:33:20 +0100
Message-Id: <20191120003320.31138-1-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120002145.skgtkx2f5dxagx4f@wittgenstein>
References: <20191120002145.skgtkx2f5dxagx4f@wittgenstein>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pidfd_poll() is defined as returning 'unsigned int' but the
.poll method is declared as returning '__poll_t', a bitwise type.

Fix this by using the proper return type and using the EPOLL
constants instead of the POLL ones, as required for __poll_t.

Fixes: b53b0b9d9a61 ("pidfd: add polling support")
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: stable@vger.kernel.org # 5.3
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/fork.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 55af6931c6ec..13b38794efb5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1708,11 +1708,11 @@ static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
 /*
  * Poll support for process exit notification.
  */
-static unsigned int pidfd_poll(struct file *file, struct poll_table_struct *pts)
+static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 {
 	struct task_struct *task;
 	struct pid *pid = file->private_data;
-	int poll_flags = 0;
+	__poll_t poll_flags = 0;
 
 	poll_wait(file, &pid->wait_pidfd, pts);
 
@@ -1724,7 +1724,7 @@ static unsigned int pidfd_poll(struct file *file, struct poll_table_struct *pts)
 	 * group, then poll(2) should block, similar to the wait(2) family.
 	 */
 	if (!task || (task->exit_state && thread_group_empty(task)))
-		poll_flags = POLLIN | POLLRDNORM;
+		poll_flags = EPOLLIN | EPOLLRDNORM;
 	rcu_read_unlock();
 
 	return poll_flags;
-- 
2.24.0

