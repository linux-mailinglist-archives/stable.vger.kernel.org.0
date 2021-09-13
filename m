Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83FF40A013
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348507AbhIMWgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348618AbhIMWft (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8319D6113B;
        Mon, 13 Sep 2021 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572473;
        bh=+1iKuTUyQl2pN5pddZaORmIg6w62UR4xUc71rEgJotc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ot0mtBx2AwyrYwZUhJiaB9mF/zFQxuFqhq3+lL74VKCj33Nk45HCdCPy1Ss18sodv
         QW20zSMGqsqUtMYFT2rxNsCdXA52mWmnYqXYmCxIabWDdb5mkXt511LpAknPUunkix
         F8dYQ+IxueSiArFZbiVSsZc7eodGzo1q4VE1M04MbDW/gpdCHK77T8priub0bI3oLz
         wDhWk/PyYY+bFtY20vhEWq6mc0ZmODsQ4YhNMWPpJIF0ssQZblKJSHFRfLKZU5UjVH
         YuY3HjdpowSkaFvSEj3cAzZbb1jsHtiUvet8Y1smswxpIzvBTfdQYaWQiXcKe4ARZF
         xMC4AkWer7M4g==
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
Subject: [PATCH AUTOSEL 5.13 13/19] connector: send event on write to /proc/[pid]/comm
Date:   Mon, 13 Sep 2021 18:34:09 -0400
Message-Id: <20210913223415.435654-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
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
index a0a2fc1c9da2..641389868deb 100644
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

