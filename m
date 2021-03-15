Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B9933BC84
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhCOO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234261AbhCOOZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 976726504F;
        Mon, 15 Mar 2021 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818299;
        bh=rr4lSrxY/dMRqo9Y3H08C7ZxlRRGlG7iXPvUKuBtou0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZxiPImQTasfLxdQpYyQmgqpSoOMdCyNVTpaIsC5TSgZlQpwtiDD9fh2B/HWhkz+W
         rbpqCneQSsGHyh3q+TxMJ5+UPWjQQN349N2ZPFX9QDqoodOvbaKnMup5V4hKkhAML9
         Gm8J26Wi2rXO5UtcsRuBy/tbDBg33Gq2epeddv94=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Kees Cook <keescook@chromium.org>,
        Minchan Kim <minchan@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Jann Horn <jannh@google.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeelb@google.com>,
        Tim Murray <timmurray@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 302/306] mm/madvise: replace ptrace attach requirement for process_madvise
Date:   Mon, 15 Mar 2021 15:24:27 +0100
Message-Id: <20210315135517.912660908@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135517.556638562@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210315135517.556638562@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Suren Baghdasaryan <surenb@google.com>

commit 96cfe2c0fd23ea7c2368d14f769d287e7ae1082e upstream.

process_madvise currently requires ptrace attach capability.
PTRACE_MODE_ATTACH gives one process complete control over another
process.  It effectively removes the security boundary between the two
processes (in one direction).  Granting ptrace attach capability even to a
system process is considered dangerous since it creates an attack surface.
This severely limits the usage of this API.

The operations process_madvise can perform do not affect the correctness
of the operation of the target process; they only affect where the data is
physically located (and therefore, how fast it can be accessed).  What we
want is the ability for one process to influence another process in order
to optimize performance across the entire system while leaving the
security boundary intact.

Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ and
CAP_SYS_NICE.  PTRACE_MODE_READ to prevent leaking ASLR metadata and
CAP_SYS_NICE for influencing process performance.

Link: https://lkml.kernel.org/r/20210303185807.2160264-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1197,12 +1197,22 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto release_task;
 	}
 
-	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
+	/* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
+	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (IS_ERR_OR_NULL(mm)) {
 		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		goto release_task;
 	}
 
+	/*
+	 * Require CAP_SYS_NICE for influencing process performance. Note that
+	 * only non-destructive hints are currently supported.
+	 */
+	if (!capable(CAP_SYS_NICE)) {
+		ret = -EPERM;
+		goto release_mm;
+	}
+
 	total_len = iov_iter_count(&iter);
 
 	while (iov_iter_count(&iter)) {
@@ -1217,6 +1227,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	if (ret == 0)
 		ret = total_len - iov_iter_count(&iter);
 
+release_mm:
 	mmput(mm);
 release_task:
 	put_task_struct(task);


