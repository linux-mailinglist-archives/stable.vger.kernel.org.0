Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BF3196A78
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 01:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgC2Aza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 20:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgC2Aza (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 20:55:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BDBD206E6;
        Sun, 29 Mar 2020 00:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585443328;
        bh=CxCnIIEiCw+E1m7Omkr2sU6eLf1MeZPt+O/k7sK3kao=;
        h=Date:From:To:Subject:From;
        b=O1KHd3+/bqgatBs6AK0TBfm4uJjcu9eAd336vwbHDAvQJZHfarUk1cerlRE4TyCXo
         429RgYT0fdlnBbbBmy3hIS0yQnpsJqacVKe3p530hAuCWi1FTvLbV6sAjka6iWmTVd
         YXDYb+fBmNRR3sDAXbpYZpuq3SVCmhaM9v1qW1sM=
Date:   Sat, 28 Mar 2020 17:55:28 -0700
From:   akpm@linux-foundation.org
To:     ast@kernel.org, davem@davemloft.net, mm-commits@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + umh-fix-refcount-underflow-in-fork_usermode_blob.patch
 added to -mm tree
Message-ID: <20200329005528.xeKtdz2A0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: umh: fix refcount underflow in fork_usermode_blob().
has been added to the -mm tree.  Its filename is
     umh-fix-refcount-underflow-in-fork_usermode_blob.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/umh-fix-refcount-underflow-in-fork_usermode_blob.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/umh-fix-refcount-underflow-in-fork_usermode_blob.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: umh: fix refcount underflow in fork_usermode_blob().

Since free_bprm(bprm) always calls allow_write_access(bprm->file) and
fput(bprm->file) if bprm->file is set to non-NULL, __do_execve_file()
must call deny_write_access(file) and get_file(file) if called from
do_execve_file() path. Otherwise, use-after-free access can happen at
fput(file) in fork_usermode_blob().

  general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] SMP DEBUG_PAGEALLOC
  CPU: 3 PID: 4131 Comm: insmod Tainted: G           O      5.6.0-rc5+ #978
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/29/2019
  RIP: 0010:fork_usermode_blob+0xaa/0x190

Link: http://lkml.kernel.org/r/9b846b1f-a231-4f09-8c37-6bfb0d1e7b05@i-love.sakura.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 449325b52b7a6208 ("umh: introduce fork_usermode_blob() helper")
Cc: <stable@vger.kernel.org> [4.18+]
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/exec.c~umh-fix-refcount-underflow-in-fork_usermode_blob
+++ a/fs/exec.c
@@ -1761,11 +1761,17 @@ static int __do_execve_file(int fd, stru
 	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
-	if (!file)
+	if (!file) {
 		file = do_open_execat(fd, filename, flags);
-	retval = PTR_ERR(file);
-	if (IS_ERR(file))
-		goto out_unmark;
+		retval = PTR_ERR(file);
+		if (IS_ERR(file))
+			goto out_unmark;
+	} else {
+		retval = deny_write_access(file);
+		if (retval)
+			goto out_unmark;
+		get_file(file);
+	}
 
 	sched_exec();
 
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

kernel-hung_taskc-monitor-killed-tasks.patch
umh-fix-refcount-underflow-in-fork_usermode_blob.patch

