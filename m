Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65E1167153
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgBUHxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgBUHxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:53:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E54124650;
        Fri, 21 Feb 2020 07:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271591;
        bh=vKHcwCVRb23yZv/rdCpLWOTPd8K+2jbWZg/bXfSw6CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQIkuYOnTbzkqsP30KznFbtYiWe4Zx1ALxDzQozXzBL+hTuC1SG7/vUBbFrJ+NXW/
         mygUvdWoBLGkxJsLzpkWu3eRI6g8dKhOBBZM/55DGNulqMf0WKo3qDA7OBhushkOU1
         bhDR5HIaeAbnkMhuiExoyD6TelzyOkNjR+a1Tnn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Knut Omang <knut.omang@oracle.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 223/399] kunit: remove timeout dependence on sysctl_hung_task_timeout_seconds
Date:   Fri, 21 Feb 2020 08:39:08 +0100
Message-Id: <20200221072424.639367517@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



