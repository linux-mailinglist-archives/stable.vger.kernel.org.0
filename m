Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3574AFAA9
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbiBISig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbiBISiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:38:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F22C050CE8;
        Wed,  9 Feb 2022 10:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 493FF61C44;
        Wed,  9 Feb 2022 18:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59DFC340E9;
        Wed,  9 Feb 2022 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431889;
        bh=qpKXmq3SY6mhExkKTzKyH2WV4QpU0WkZoSqvrwQR5fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQs2z+4+FKLtCsygbZv1IlDz/k5Ww4T9ERLRdZ0o823RzgmvTbda1yzPCmnDzEPjW
         wObi+7ju/l7MA2HboslaDTViM2GzXjRK2ezDIHxktbdu+UN/ZW9YV9J0BCTlvVRH2o
         FJQrxPlr3Mkz7XywCGrCyyeHm3uVdUxFBDHLrO/So5q+fSLmaiFAH5e3DPqdSJPZ2j
         5cP+sz8W9ag3lEZLOIbw7s3qQ6qPuOZIk2Loicxjhsq/oTF8lLQ+cEbQBUP1/22KYY
         hSCbEd8u/NVaW7c8byAmIjZSgUyuzfEZvahFy8W5cztrhciEhJS8v4gb/uxRd4C0C2
         WRezOY8uyZBNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        yang xu <xuyang2018.jy@cn.fujitsu.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, keescook@chromium.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/36] kselftest: signal all child processes
Date:   Wed,  9 Feb 2022 13:37:28 -0500
Message-Id: <20220209183759.47134-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Li Zhijian <lizhijian@cn.fujitsu.com>

[ Upstream commit 92d25637a3a45904292c93f1863c6bbda4e3e38f ]

We have some many cases that will create child process as well, such as
pidfd_wait. Previously, we will signal/kill the parent process when it
is time out, but this signal will not be sent to its child process. In
such case, if child process doesn't terminate itself, ksefltest framework
will hang forever.

Here we group all its child processes so that kill() can signal all of
them in timeout.

Fixed change log: Shuah Khan <skhan@linuxfoundation.org>

Suggested-by: yang xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 79a182cfa43ad..78e59620d28de 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -875,7 +875,8 @@ static void __timeout_handler(int sig, siginfo_t *info, void *ucontext)
 	}
 
 	t->timed_out = true;
-	kill(t->pid, SIGKILL);
+	// signal process group
+	kill(-(t->pid), SIGKILL);
 }
 
 void __wait_for_test(struct __test_metadata *t)
@@ -985,6 +986,7 @@ void __run_test(struct __fixture_metadata *f,
 		ksft_print_msg("ERROR SPAWNING TEST CHILD\n");
 		t->passed = 0;
 	} else if (t->pid == 0) {
+		setpgrp();
 		t->fn(t, variant);
 		if (t->skip)
 			_exit(255);
-- 
2.34.1

