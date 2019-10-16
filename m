Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13397DA034
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407098AbfJPWJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406676AbfJPV5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:34 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A626F21D7E;
        Wed, 16 Oct 2019 21:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263053;
        bh=yu2b8zJoFmrxOFUFT+kolrRnQxcolcv/5ntmye+pqkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRNbicW3ceflw2Zi5a1ESzVa9ui5t0CSxSg5rmD3+tXQShFLo4kff+4nOt8xcNU+n
         kbq1MgPIKkfrQfXsVoL9a7E1donxuQEpbyrdMwr7SyuUXLhWC//rzyMcppecWTvPpB
         nKuZ7KteW3+nuOz/12rWAR/dxz45OX0v6ESFeKhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 56/81] kernel/sysctl.c: do not override max_threads provided by userspace
Date:   Wed, 16 Oct 2019 14:51:07 -0700
Message-Id: <20191016214842.621065901@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40 upstream.

Partially revert 16db3d3f1170 ("kernel/sysctl.c: threads-max observe
limits") because the patch is causing a regression to any workload which
needs to override the auto-tuning of the limit provided by kernel.

set_max_threads is implementing a boot time guesstimate to provide a
sensible limit of the concurrently running threads so that runaways will
not deplete all the memory.  This is a good thing in general but there
are workloads which might need to increase this limit for an application
to run (reportedly WebSpher MQ is affected) and that is simply not
possible after the mentioned change.  It is also very dubious to
override an admin decision by an estimation that doesn't have any direct
relation to correctness of the kernel operation.

Fix this by dropping set_max_threads from sysctl_max_threads so any
value is accepted as long as it fits into MAX_THREADS which is important
to check because allowing more threads could break internal robust futex
restriction.  While at it, do not use MIN_THREADS as the lower boundary
because it is also only a heuristic for automatic estimation and admin
might have a good reason to stop new threads to be created even when
below this limit.

This became more severe when we switched x86 from 4k to 8k kernel
stacks.  Starting since 6538b8ea886e ("x86_64: expand kernel stack to
16K") (3.16) we use THREAD_SIZE_ORDER = 2 and that halved the auto-tuned
value.

In the particular case

  3.12
  kernel.threads-max = 515561

  4.4
  kernel.threads-max = 200000

Neither of the two values is really insane on 32GB machine.

I am not sure we want/need to tune the max_thread value further.  If
anything the tuning should be removed altogether if proven not useful in
general.  But we definitely need a way to override this auto-tuning.

Link: http://lkml.kernel.org/r/20190922065801.GB18814@dhcp22.suse.cz
Fixes: 16db3d3f1170 ("kernel/sysctl.c: threads-max observe limits")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2623,7 +2623,7 @@ int sysctl_max_threads(struct ctl_table
 	struct ctl_table t;
 	int ret;
 	int threads = max_threads;
-	int min = MIN_THREADS;
+	int min = 1;
 	int max = MAX_THREADS;
 
 	t = *table;
@@ -2635,7 +2635,7 @@ int sysctl_max_threads(struct ctl_table
 	if (ret || !write)
 		return ret;
 
-	set_max_threads(threads);
+	max_threads = threads;
 
 	return 0;
 }


