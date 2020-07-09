Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2573B21A91A
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 22:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGIUgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 16:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIUgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 16:36:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE70A20774;
        Thu,  9 Jul 2020 20:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594326961;
        bh=xgy89kf26xO0CJkbxtFmcT59UkKXiWZR+RXozq/hOFI=;
        h=Date:From:To:Subject:From;
        b=QT+sTob6IdMQPh6Rt+XWu6VIeCXThuOYZQJlCiV6b3qLEGi5K+gZwrQZ8MvKQ/2CK
         gpxP9lfw6A1oT1yTgj5j1udY2kdwKRSIivrBnpA/SJ5J6CAKaKDUOqhe2XiI5G6CVs
         3m8lD1CpWWphGBVoxhitYmAl8raJXE1Ra3yJiVWI=
Date:   Thu, 09 Jul 2020 13:36:00 -0700
From:   akpm@linux-foundation.org
To:     ast@kernel.org, davem@davemloft.net, ebiederm@xmission.com,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [alternative-merged]
 umh-fix-refcount-underflow-in-fork_usermode_blob.patch removed from -mm
 tree
Message-ID: <20200709203600.hOUPOrGbN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: umh: fix refcount underflow in fork_usermode_blob().
has been removed from the -mm tree.  Its filename was
     umh-fix-refcount-underflow-in-fork_usermode_blob.patch

This patch was dropped because an alternative patch was merged

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
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org> [4.18+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/exec.c~umh-fix-refcount-underflow-in-fork_usermode_blob
+++ a/fs/exec.c
@@ -1868,11 +1868,17 @@ static int __do_execve_file(int fd, stru
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

