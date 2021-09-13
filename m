Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F4740A041
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349101AbhIMWhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348738AbhIMWgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF4E6112D;
        Mon, 13 Sep 2021 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572495;
        bh=QHFllW7CFGddW8XMvs5sYrCWEIpkqgM7DbyQgAy0lRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zk1XE2IpsGmdHLk1v97MbVMkVNKMcs1OMcq8aKqqjhGAl1ip0bO38bNAjd/rvnDq1
         Y8fC3tJmF+dkFlDon6dAdRTwpXEg9DsN6o1y2AiS0l9iqE17SQI1xIsuSsKG2y/r87
         7kv/gAaMzPqBOQLC5QTMWobUtIHtMGZb1UWlA2mMIVPZBZxLgKt9EHpMUZ8zSd5O2F
         2l3ORcHvecusPVAqwaW+cvaeJjZOxm9/hAVbC+N7lnBP1OLBYcH6bMVXlqUtrPXAay
         bjA82L0lQfgbhz4pyTIoCgD1gC/O1AV9Vm1ZecT1WobnlfGY2uaK28nZuSF154iuyG
         ZNpDkOcgw1WCw==
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
Subject: [PATCH AUTOSEL 5.10 10/16] connector: send event on write to /proc/[pid]/comm
Date:   Mon, 13 Sep 2021 18:34:36 -0400
Message-Id: <20210913223442.435885-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223442.435885-1-sashal@kernel.org>
References: <20210913223442.435885-1-sashal@kernel.org>
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
index 5d52aea8d7e7..d01e09758354 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -96,6 +96,7 @@
 #include <linux/posix-timers.h>
 #include <linux/time_namespace.h>
 #include <linux/resctrl.h>
+#include <linux/cn_proc.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -1675,8 +1676,10 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
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

