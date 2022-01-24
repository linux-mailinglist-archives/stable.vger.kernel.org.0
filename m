Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315F049808B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbiAXNL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242951AbiAXNL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:11:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C086CC06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88AC8B80FA8
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E33C340E1;
        Mon, 24 Jan 2022 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643029885;
        bh=hnjMwk4Vs231CJrfWczkABHhnrfl7ha5BuHA67orKfA=;
        h=Subject:To:Cc:From:Date:From;
        b=scwY9FUT2L0Z+BnO+FsaC78qkLGNwI2eS1pOSOK4wPgl01dOwVs/j6Nej1lRbh7ev
         L+IjHRSo08RZtr5PkKJ72LIf4q7OEp0nLJpGlgLGk0C9Wi7fXLNV89qPpG5HblJeT0
         FQStuok4xGfYerzLzzqTZZ3laYjkRo5iK7K9qUkU=
Subject: FAILED: patch "[PATCH] taskstats: Cleanup the use of task->exit_code" failed to apply to 4.19-stable tree
To:     ebiederm@xmission.com, bsingharora@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:11:15 +0100
Message-ID: <1643029875243224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1b5a42d9c85f0e731f01c8d1129001fd8531a8a0 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 3 Jan 2022 11:32:36 -0600
Subject: [PATCH] taskstats: Cleanup the use of task->exit_code

In the function bacct_add_task the code reading task->exit_code was
introduced in commit f3cef7a99469 ("[PATCH] csa: basic accounting over
taskstats"), and it is not entirely clear what the taskstats interface
is trying to return as only returning the exit_code of the first task
in a process doesn't make a lot of sense.

As best as I can figure the intent is to return task->exit_code after
a task exits.  The field is returned with per task fields, so the
exit_code of the entire process is not wanted.  Only the value of the
first task is returned so this is not a useful way to get the per task
ptrace stop code.  The ordinary case of returning this value is
returning after a task exits, which also precludes use for getting
a ptrace value.

It is common to for the first task of a process to also be the last
task of a process so this field may have done something reasonable by
accident in testing.

Make ac_exitcode a reliable per task value by always returning it for
every exited task.

Setting ac_exitcode in a sensible mannter makes it possible to continue
to provide this value going forward.

Cc: Balbir Singh <bsingharora@gmail.com>
Fixes: f3cef7a99469 ("[PATCH] csa: basic accounting over taskstats")
Link: https://lkml.kernel.org/r/20220103213312.9144-5-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index f00de83d0246..1d261fbe367b 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -38,11 +38,10 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	stats->ac_btime = clamp_t(time64_t, btime, 0, U32_MAX);
 	stats->ac_btime64 = btime;
 
-	if (thread_group_leader(tsk)) {
+	if (tsk->flags & PF_EXITING)
 		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
+	if (thread_group_leader(tsk) && (tsk->flags & PF_FORKNOEXEC))
+		stats->ac_flag |= AFORK;
 	if (tsk->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
 	if (tsk->flags & PF_DUMPCORE)

