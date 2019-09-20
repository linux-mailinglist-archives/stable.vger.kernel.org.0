Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB15B92D7
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392286AbfITOft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35914 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388080AbfITOZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0004y6-Ow; Fri, 20 Sep 2019 15:24:58 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007s1-1W; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        "kbuild test robot" <lkp@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.132244312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 043/132] smpboot: Place the __percpu annotation correctly
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d4645d30b50d1691c26ff0f8fa4e718b08f8d3bb upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/smpboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -31,7 +31,7 @@ struct smpboot_thread_data;
  * @thread_comm:	The base name of the thread
  */
 struct smp_hotplug_thread {
-	struct task_struct __percpu	**store;
+	struct task_struct		* __percpu *store;
 	struct list_head		list;
 	int				(*thread_should_run)(unsigned int cpu);
 	void				(*thread_fn)(unsigned int cpu);

