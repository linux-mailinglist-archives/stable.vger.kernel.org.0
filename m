Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565464A4325
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376542AbiAaLR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:17:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48316 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359611AbiAaLOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B24660ED0;
        Mon, 31 Jan 2022 11:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A13C340E8;
        Mon, 31 Jan 2022 11:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627694;
        bh=UBEHWdnK0I2caz9S+JQIViCsogd5ROcJ4lKF/VGobX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/AgDqrH6rtjaEJRAg4O544+gP+rMRZPvsGoQrOzJLhwt4V3UsOLtcnQpBQELI9E5
         /X4fhbksYVxm8d231ZGEp+NAwikDrQ4hbNyZ9JVLhRas8aCEMb8zUdS/7a1WCj3fNm
         xjn3yJbinJoXa8wdziNJ3EsJtp+upF5DFMA/LjUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        kernel test robot <lkp@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 166/171] psi: fix "no previous prototype" warnings when CONFIG_CGROUPS=n
Date:   Mon, 31 Jan 2022 11:57:11 +0100
Message-Id: <20220131105235.628811698@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

commit 51e50fbd3efc6064c30ed73a5e009018b36e290a upstream.

When CONFIG_CGROUPS is disabled psi code generates the following
warnings:

  kernel/sched/psi.c:1112:21: warning: no previous prototype for 'psi_trigger_create' [-Wmissing-prototypes]
      1112 | struct psi_trigger *psi_trigger_create(struct psi_group *group,
           |                     ^~~~~~~~~~~~~~~~~~
  kernel/sched/psi.c:1182:6: warning: no previous prototype for 'psi_trigger_destroy' [-Wmissing-prototypes]
      1182 | void psi_trigger_destroy(struct psi_trigger *t)
           |      ^~~~~~~~~~~~~~~~~~~
  kernel/sched/psi.c:1249:10: warning: no previous prototype for 'psi_trigger_poll' [-Wmissing-prototypes]
      1249 | __poll_t psi_trigger_poll(void **trigger_ptr,
           |          ^~~~~~~~~~~~~~~~

Change the declarations of these functions in the header to provide the
prototypes even when they are unused.

Link: https://lkml.kernel.org/r/20220119223940.787748-2-surenb@google.com
Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/psi.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -24,18 +24,17 @@ void psi_memstall_enter(unsigned long *f
 void psi_memstall_leave(unsigned long *flags);
 
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
-
-#ifdef CONFIG_CGROUPS
-int psi_cgroup_alloc(struct cgroup *cgrp);
-void psi_cgroup_free(struct cgroup *cgrp);
-void cgroup_move_task(struct task_struct *p, struct css_set *to);
-
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
 void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
+
+#ifdef CONFIG_CGROUPS
+int psi_cgroup_alloc(struct cgroup *cgrp);
+void psi_cgroup_free(struct cgroup *cgrp);
+void cgroup_move_task(struct task_struct *p, struct css_set *to);
 #endif
 
 #else /* CONFIG_PSI */


