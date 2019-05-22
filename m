Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1335E26EB5
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731074AbfEVT0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731897AbfEVT0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:26:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8005021473;
        Wed, 22 May 2019 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553171;
        bh=zbMQSssgxEcMncoTrO0Isv+fTsVyLkzY3aAYQXjwqlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beZAfe2UUxxcDHK9njq8a0YzRFMSwtVdBEZuzjtlyUHyTED90jIjD0WODS+kr0izY
         S0EE3f7V5BbCOHMZqRzImnuuI9M+Y2AKu5h7syVlsp3Mwu6Ek8LpUBUjziCPcB1DV7
         bHNDrg+Kkpr9HuiB1TZJe6TcfDy81obD20JhzmKU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kbuild test robot <lkp@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 092/317] smpboot: Place the __percpu annotation correctly
Date:   Wed, 22 May 2019 15:19:53 -0400
Message-Id: <20190522192338.23715-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit d4645d30b50d1691c26ff0f8fa4e718b08f8d3bb ]

The test robot reported a wrong assignment of a per-CPU variable which
it detected by using sparse and sent a report. The assignment itself is
correct. The annotation for sparse was wrong and hence the report.
The first pointer is a "normal" pointer and points to the per-CPU memory
area. That means that the __percpu annotation has to be moved.

Move the __percpu annotation to pointer which points to the per-CPU
area. This change affects only the sparse tool (and is ignored by the
compiler).

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: f97f8f06a49fe ("smpboot: Provide infrastructure for percpu hotplug threads")
Link: http://lkml.kernel.org/r/20190424085253.12178-1-bigeasy@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/smpboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index d0884b5250010..9d1bc65d226cc 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -29,7 +29,7 @@ struct smpboot_thread_data;
  * @thread_comm:	The base name of the thread
  */
 struct smp_hotplug_thread {
-	struct task_struct __percpu	**store;
+	struct task_struct		* __percpu *store;
 	struct list_head		list;
 	int				(*thread_should_run)(unsigned int cpu);
 	void				(*thread_fn)(unsigned int cpu);
-- 
2.20.1

