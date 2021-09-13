Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAA9409FE8
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbhIMWf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348390AbhIMWfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3406D61163;
        Mon, 13 Sep 2021 22:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572446;
        bh=zGBAYFJpWCBJwShup3H4U2EPZYTc5BvLr0AMTxsTDmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ti97m0ccDAABfOkG8pejUjVk0U8yfFmUKGS7ZJ/Sm+dVwfR6830N7E0MBheBaB3fI
         t1NUgcrpaBfrJXs8/uYfTG5Ew7420ZHGyyqJuA57LsuHZNm4u2sWNbIlGpqSbbvJrd
         Zb8maQA/RWBToZxJfmLT2HFm3QNuaov1XHV9dmIKc8TfLwlWKWY0AagzWu3FViEqlL
         v21bHxs2/T1ZrpK70ipiQGTGm2YRs2alcxe7iz+ieUYWp46ZQqh0h82/sDD01MCqo+
         ITU/o3JK4qkjlH1WOYLBDnhePkCXFtkwM3Yh9F1MySrN9RzUg3zrgEf+wsswgEO4xg
         QGWFhGinM6dlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ohhoon Kwon <ohoono.kwon@samsung.com>,
        Ingo Molnar <mingo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 19/25] connector: send event on write to /proc/[pid]/comm
Date:   Mon, 13 Sep 2021 18:33:33 -0400
Message-Id: <20210913223339.435347-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ohhoon Kwon <ohoono.kwon@samsung.com>

[ Upstream commit c2f273ebd89a79ed87ef1025753343e327b99ac9 ]

While comm change event via prctl has been reported to proc connector by
'commit f786ecba4158 ("connector: add comm change event report to proc
connector")', connector listeners were missing comm changes by explicit
writes on /proc/[pid]/comm.

Let explicit writes on /proc/[pid]/comm report to proc connector.

Link: https://lkml.kernel.org/r/20210701133458epcms1p68e9eb9bd0eee8903ba26679a37d9d960@epcms1p6
Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e5b5f7709d48..533d5836eb9a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -95,6 +95,7 @@
 #include <linux/posix-timers.h>
 #include <linux/time_namespace.h>
 #include <linux/resctrl.h>
+#include <linux/cn_proc.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -1674,8 +1675,10 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
 	if (!p)
 		return -ESRCH;
 
-	if (same_thread_group(current, p))
+	if (same_thread_group(current, p)) {
 		set_task_comm(p, buffer);
+		proc_comm_connector(p);
+	}
 	else
 		count = -EINVAL;
 
-- 
2.30.2

