Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28CA594DBF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbiHPAgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350568AbiHPAgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B174E84D;
        Mon, 15 Aug 2022 13:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76D2EB80EA9;
        Mon, 15 Aug 2022 20:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC8C433C1;
        Mon, 15 Aug 2022 20:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595843;
        bh=J7tXZQAKQ1Enn9d8Kao/WXR5L8k8qxeZb02P9k8WmdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDLQR2Ee4BWI71QtCKMh9IZyclVJgQjUpg6D/s+T+jmQuinyTq5EG7Q8pLx5K/x6d
         BSpLbJQI/9TW0jB/7nmrQkXJcmi4tFmpdfft25Zp7FwIPsIGBz/063ZQDOY4MhZyvR
         H/K9jpIUM2zI866muamL40PXDebzkjavK8AMdPME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Sindelar <adam@wowsignal.io>,
        David Vernet <void@manifault.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0865/1157] selftests/vm: fix errno handling in mrelease_test
Date:   Mon, 15 Aug 2022 20:03:41 +0200
Message-Id: <20220815180514.070470167@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Adam Sindelar <adam@wowsignal.io>

[ Upstream commit 3b8e7f5c42d1aa44f71fd219717c80e34101361e ]

mrelease_test should return KSFT_SKIP when process_mrelease is not
defined, but due to a perror call consuming the errno, it returns
KSFT_FAIL.

This patch decides the exit code before calling perror.

[adam@wowsignal.io: fix remaining instances of errno mishandling]
  Link: https://lkml.kernel.org/r/20220706141602.10159-1-adam@wowsignal.io
Link: https://lkml.kernel.org/r/20220704173351.19595-1-adam@wowsignal.io
Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Reviewed-by: David Vernet <void@manifault.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/mrelease_test.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vm/mrelease_test.c b/tools/testing/selftests/vm/mrelease_test.c
index 96671c2f7d48..6c62966ab5db 100644
--- a/tools/testing/selftests/vm/mrelease_test.c
+++ b/tools/testing/selftests/vm/mrelease_test.c
@@ -62,19 +62,22 @@ static int alloc_noexit(unsigned long nr_pages, int pipefd)
 /* The process_mrelease calls in this test are expected to fail */
 static void run_negative_tests(int pidfd)
 {
+	int res;
 	/* Test invalid flags. Expect to fail with EINVAL error code. */
 	if (!syscall(__NR_process_mrelease, pidfd, (unsigned int)-1) ||
 			errno != EINVAL) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease with wrong flags");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 	/*
 	 * Test reaping while process is alive with no pending SIGKILL.
 	 * Expect to fail with EINVAL error code.
 	 */
 	if (!syscall(__NR_process_mrelease, pidfd, 0) || errno != EINVAL) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease on a live process");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 }
 
@@ -100,8 +103,9 @@ int main(void)
 
 	/* Test a wrong pidfd */
 	if (!syscall(__NR_process_mrelease, -1, 0) || errno != EBADF) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease with wrong pidfd");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 
 	/* Start the test with 1MB child memory allocation */
@@ -156,8 +160,9 @@ int main(void)
 	run_negative_tests(pidfd);
 
 	if (kill(pid, SIGKILL)) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("kill");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 
 	success = (syscall(__NR_process_mrelease, pidfd, 0) == 0);
@@ -172,9 +177,10 @@ int main(void)
 		if (errno == ESRCH) {
 			retry = (size <= MAX_SIZE_MB);
 		} else {
+			res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 			perror("process_mrelease");
 			waitpid(pid, NULL, 0);
-			exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+			exit(res);
 		}
 	}
 
-- 
2.35.1



