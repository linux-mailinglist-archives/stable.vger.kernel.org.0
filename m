Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9759C4BDB86
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345048AbiBUIvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:51:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345043AbiBUIvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:51:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E741B2BC6;
        Mon, 21 Feb 2022 00:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3B70B80E9E;
        Mon, 21 Feb 2022 08:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE69C340E9;
        Mon, 21 Feb 2022 08:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433485;
        bh=DgGhbdF+BspVtuOiuXe2z6rWWo4QemT+E1nKDThYGIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msxBgVuKIHKZznQGYT2ZpiOvqi+8FnjDMknJTB/OeRPWHBm6K434dP80tjDcaE7Cj
         T3/UWQjKNYwgV7/PZUfeyLu3oLv4fqVaW6o2nZdWfv12BHzXHpXlFfyVhPAl8OQCs1
         Pe39D0o3+/uqK1iFXOePbY0oow46bVFZs409B60I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 16/33] taskstats: Cleanup the use of task->exit_code
Date:   Mon, 21 Feb 2022 09:49:09 +0100
Message-Id: <20220221084909.304357266@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tsacct.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -44,11 +44,10 @@ void bacct_add_tsk(struct user_namespace
 	/* Convert to seconds for btime */
 	do_div(delta, USEC_PER_SEC);
 	stats->ac_btime = get_seconds() - delta;
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


