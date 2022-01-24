Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8190C4999C8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377334AbiAXVhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447471AbiAXVKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A59C09D30D;
        Mon, 24 Jan 2022 12:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C8B3B8122A;
        Mon, 24 Jan 2022 20:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FF8C340E5;
        Mon, 24 Jan 2022 20:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054932;
        bh=OLGhyBE3yYUeUqi46/+gVKgkTva0eh9cbOByjskd/PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFJorSzUtNIUiTxCS1mkwybUhV5w+kj6oM8eon23ji2rSd4daQOG8gVGvLeECVzZ6
         exM+YXJkhisifPUQ7Q86Y3YzpLWqniMenFQeizB3Iw4DwNUsrlfQHz8RwW19oR/SDY
         0d3VEgmNCi+bXRrg77shwUEUzDAYlsyP2BlGFxzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 533/563] taskstats: Cleanup the use of task->exit_code
Date:   Mon, 24 Jan 2022 19:44:58 +0100
Message-Id: <20220124184042.881061424@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 1b5a42d9c85f0e731f01c8d1129001fd8531a8a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tsacct.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -38,11 +38,10 @@ void bacct_add_tsk(struct user_namespace
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


