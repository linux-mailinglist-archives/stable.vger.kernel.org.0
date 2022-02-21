Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCF74BE815
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348651AbiBUJW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349335AbiBUJVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2EF17A9F;
        Mon, 21 Feb 2022 01:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17343CE0E77;
        Mon, 21 Feb 2022 09:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE57C340E9;
        Mon, 21 Feb 2022 09:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434486;
        bh=qpKXmq3SY6mhExkKTzKyH2WV4QpU0WkZoSqvrwQR5fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5YCGOQ+KxlegLxNmq42jr2uhpSynYrztMjgzjsuxxk1HnBBZ8K2cgNOpeRM4LP6M
         kcOB48M3uct5lBG0WhPXVbJU1bzKoDPMTh1O6wv1Vd4ACxU3arX6msDMQEca1HyrUW
         H6Zy83uDRjlmfLk9B9rsD3YdK/sYO52eAOdM7b38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yang xu <xuyang2018.jy@cn.fujitsu.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/196] kselftest: signal all child processes
Date:   Mon, 21 Feb 2022 09:47:37 +0100
Message-Id: <20220221084931.740963893@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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



