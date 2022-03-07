Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BF54CF720
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiCGJom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240442AbiCGJlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140C041327;
        Mon,  7 Mar 2022 01:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75539B810CB;
        Mon,  7 Mar 2022 09:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC81EC340E9;
        Mon,  7 Mar 2022 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645830;
        bh=Pbxjfsz5h7lA5AO4pfCoeS41QbTB3ix6m1vRTueHYLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNtaSpiUMzEGz569F3/kSyBvOfRmw3YN+9iBT8coP49S9pVOcm+f47AYz2f+ievCy
         7f2vBkoFhlOJ1p28NZqJQCFJtEMfiw0UxTKwgOtI9MXu6gjhOk5zgzpRTvlF16j+N4
         EzGH1Mjef4yC39JqkF/DgQlIE3r2sLbXBV+g7SNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/262] signal: In get_signal test for signal_group_exit every time through the loop
Date:   Mon,  7 Mar 2022 10:16:34 +0100
Message-Id: <20220307091703.932029160@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit e7f7c99ba911f56bc338845c1cd72954ba591707 ]

Recently while investigating a problem with rr and signals I noticed
that siglock is dropped in ptrace_signal and get_signal does not jump
to relock.

Looking farther to see if the problem is anywhere else I see that
do_signal_stop also returns if signal_group_exit is true.  I believe
that test can now never be true, but it is a bit hard to trace
through and be certain.

Testing signal_group_exit is not expensive, so move the test for
signal_group_exit into the for loop inside of get_signal to ensure
the test is never skipped improperly.

This has been a potential problem since I added the test for
signal_group_exit was added.

Fixes: 35634ffa1751 ("signal: Always notice exiting tasks")
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/875yssekcd.fsf_-_@email.froward.int.ebiederm.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index aea93d6a5520a..6e3dbb3d12170 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2710,19 +2710,19 @@ bool get_signal(struct ksignal *ksig)
 		goto relock;
 	}
 
-	/* Has this task already been marked for death? */
-	if (signal_group_exit(signal)) {
-		ksig->info.si_signo = signr = SIGKILL;
-		sigdelset(&current->pending.signal, SIGKILL);
-		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
-				&sighand->action[SIGKILL - 1]);
-		recalc_sigpending();
-		goto fatal;
-	}
-
 	for (;;) {
 		struct k_sigaction *ka;
 
+		/* Has this task already been marked for death? */
+		if (signal_group_exit(signal)) {
+			ksig->info.si_signo = signr = SIGKILL;
+			sigdelset(&current->pending.signal, SIGKILL);
+			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
+			recalc_sigpending();
+			goto fatal;
+		}
+
 		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
 		    do_signal_stop(0))
 			goto relock;
-- 
2.34.1



