Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E213F625045
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiKKCeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiKKCeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C6860EA6;
        Thu, 10 Nov 2022 18:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE17F61E8D;
        Fri, 11 Nov 2022 02:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263ECC433D6;
        Fri, 11 Nov 2022 02:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134039;
        bh=GHgdIoT4lw5MoP246IlcpsNkvxqjnGhY9F5ONqN4YCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7SXWqaCMVQWPCrfoebeyaCbQCVNKP4zOeM4LRAl7xcvIp5VNRpTguSkEw8Bj9XSv
         9ZgA9Abeq34Ji02YJDj6OHfRn97WpcF0by1tv31fXxCGivMeRESzWyXJnM3LGgm7WG
         47k0NQA99x6TAGyAcNLyoMKIWirPD8Yl6Dczch3o4SD2JkrHF9womtP5B1+0G5TVgL
         x+Vpx4+Ez8LO92p4fMFI5V/GU5MIUp0gjpaai9bCymrDLnznhTYhsewg1MBpIh++1f
         +JEzyqoZYSNBDkwKgogwy6aVMG6Y44pUmLWNiULOiUOxQD1FyC31K2EemBT7q72PoG
         Cl2Q/ACyIFKIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@fujitsu.com>,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 09/30] ksefltests: pidfd: Fix wait_states: Test terminated by timeout
Date:   Thu, 10 Nov 2022 21:33:17 -0500
Message-Id: <20221111023340.227279-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 88e1f16ba58665e9edfce437ea487da2fa759af9 ]

0Day/LKP observed that the kselftest blocks forever since one of the
pidfd_wait doesn't terminate in 1 of 30 runs. After digging into
the source, we found that it blocks at:
ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WCONTINUED, NULL), 0);

wait_states has below testing flow:
  CHILD                 PARENT
  ---------------+--------------
1 STOP itself
2                   WAIT for CHILD STOPPED
3                   SIGNAL CHILD to CONT
4 CONT
5 STOP itself
5'                  WAIT for CHILD CONT
6                   WAIT for CHILD STOPPED

The problem is that the kernel cannot ensure the order of 5 and 5', once
5 goes first, the test will fail.

we can reproduce it by:
$ while true; do make run_tests -C pidfd; done

Introduce a blocking read in child process to make sure the parent can
check its WCONTINUED.

CC: Philip Li <philip.li@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pidfd/pidfd_wait.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/pidfd/pidfd_wait.c b/tools/testing/selftests/pidfd/pidfd_wait.c
index 070c1c876df1..c3e2a3041f55 100644
--- a/tools/testing/selftests/pidfd/pidfd_wait.c
+++ b/tools/testing/selftests/pidfd/pidfd_wait.c
@@ -95,20 +95,28 @@ TEST(wait_states)
 		.flags = CLONE_PIDFD | CLONE_PARENT_SETTID,
 		.exit_signal = SIGCHLD,
 	};
+	int pfd[2];
 	pid_t pid;
 	siginfo_t info = {
 		.si_signo = 0,
 	};
 
+	ASSERT_EQ(pipe(pfd), 0);
 	pid = sys_clone3(&args);
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
+		char buf[2];
+
+		close(pfd[1]);
 		kill(getpid(), SIGSTOP);
+		ASSERT_EQ(read(pfd[0], buf, 1), 1);
+		close(pfd[0]);
 		kill(getpid(), SIGSTOP);
 		exit(EXIT_SUCCESS);
 	}
 
+	close(pfd[0]);
 	ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WSTOPPED, NULL), 0);
 	ASSERT_EQ(info.si_signo, SIGCHLD);
 	ASSERT_EQ(info.si_code, CLD_STOPPED);
@@ -117,6 +125,8 @@ TEST(wait_states)
 	ASSERT_EQ(sys_pidfd_send_signal(pidfd, SIGCONT, NULL, 0), 0);
 
 	ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WCONTINUED, NULL), 0);
+	ASSERT_EQ(write(pfd[1], "C", 1), 1);
+	close(pfd[1]);
 	ASSERT_EQ(info.si_signo, SIGCHLD);
 	ASSERT_EQ(info.si_code, CLD_CONTINUED);
 	ASSERT_EQ(info.si_pid, parent_tid);
-- 
2.35.1

