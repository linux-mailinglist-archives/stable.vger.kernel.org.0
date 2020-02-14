Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FD815F1E8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391324AbgBNSEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbgBNPzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8FBB24681;
        Fri, 14 Feb 2020 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695737;
        bh=vKHcwCVRb23yZv/rdCpLWOTPd8K+2jbWZg/bXfSw6CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+zfFwINBo9jBCXjF4DBZoV9TmJZzQqjNCETknmZnkFjpAH2tk37ZJ5if6JEuFsKO
         ZbSmqvQmNvNN6FYOb3IczMmnUIVPR7zKVsjIHWSFxZrMhnHUq3g7Durl1MciVDRL6b
         +oAbEWcfmruYhsrEOW1kWtv9unZohxCqJ0Ut+3P4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Knut Omang <knut.omang@oracle.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.5 310/542] kunit: remove timeout dependence on sysctl_hung_task_timeout_seconds
Date:   Fri, 14 Feb 2020 10:45:02 -0500
Message-Id: <20200214154854.6746-310-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 1c024d45151b51c8f8d4749e65958b0bcf3e7c52 ]

In discussion of how to handle timeouts, it was noted that if
sysctl_hung_task_timeout_seconds is exceeded for a kunit test,
the test task will be killed and an oops generated.  This should
suffice as a means of debugging such timeout issues for now.

Hence remove use of sysctl_hung_task_timeout_secs, which has the
added benefit of avoiding the need to export that symbol from
the core kernel.

Co-developed-by: Knut Omang <knut.omang@oracle.com>
Signed-off-by: Knut Omang <knut.omang@oracle.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/try-catch.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index 55686839eb619..6b9c5242017f6 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -12,7 +12,6 @@
 #include <linux/completion.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
-#include <linux/sched/sysctl.h>
 
 void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
 {
@@ -31,8 +30,6 @@ static int kunit_generic_run_threadfn_adapter(void *data)
 
 static unsigned long kunit_test_timeout(void)
 {
-	unsigned long timeout_msecs;
-
 	/*
 	 * TODO(brendanhiggins@google.com): We should probably have some type of
 	 * variable timeout here. The only question is what that timeout value
@@ -49,22 +46,11 @@ static unsigned long kunit_test_timeout(void)
 	 *
 	 * For more background on this topic, see:
 	 * https://mike-bland.com/2011/11/01/small-medium-large.html
+	 *
+	 * If tests timeout due to exceeding sysctl_hung_task_timeout_secs,
+	 * the task will be killed and an oops generated.
 	 */
-	if (sysctl_hung_task_timeout_secs) {
-		/*
-		 * If sysctl_hung_task is active, just set the timeout to some
-		 * value less than that.
-		 *
-		 * In regards to the above TODO, if we decide on variable
-		 * timeouts, this logic will likely need to change.
-		 */
-		timeout_msecs = (sysctl_hung_task_timeout_secs - 1) *
-				MSEC_PER_SEC;
-	} else {
-		timeout_msecs = 300 * MSEC_PER_SEC; /* 5 min */
-	}
-
-	return timeout_msecs;
+	return 300 * MSEC_PER_SEC; /* 5 min */
 }
 
 void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
-- 
2.20.1

