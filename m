Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF51F66C9
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKJCkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfKJCkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2409321019;
        Sun, 10 Nov 2019 02:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353650;
        bh=SXNKvy0fhdk/59LQap0bFKFWEbNXfleA9TbgtbVruJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUgvQYh+fuRLDOri81VJlLlITr8Ko/e1d5ZKURvdnBHMuXmOn7RvmNbj0Hu8+6z98
         uw7EmyknBukMbHmZdJuqng9pMphRqAXplgUOLnaaLZPnZ/RCIu66vKU6/td88FDv2S
         2/tSRyoW14r3C6+4xh7yT7cYUD0ZziPviZ8rjhqg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Breno Leitao <leitao@debian.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/191] selftests/powerpc: Do not fail with reschedule
Date:   Sat,  9 Nov 2019 21:37:29 -0500
Message-Id: <20191110024013.29782-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 44d947eff19d64384efc06069509db7a0a1103b0 ]

There are cases where the test is not expecting to have the transaction
aborted, but, the test process might have been rescheduled, either in the
OS level or by KVM (if it is running on a KVM guest machine). The process
reschedule will cause a treclaim/recheckpoint which will cause the
transaction to doom, aborting the transaction as soon as the process is
rescheduled back to the CPU. This might cause the test to fail, but this is
not a failure in essence.

If that is the case, TEXASR[FC] is indicated with either
TM_CAUSE_RESCHEDULE or TM_CAUSE_KVM_RESCHEDULE for KVM interruptions.

In this scenario, ignore these two failures and avoid the whole test to
return failure.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Gustavo Romero <gromero@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/tm/tm-unavailable.c | 9 ++++++---
 tools/testing/selftests/powerpc/tm/tm.h             | 9 +++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/tm/tm-unavailable.c b/tools/testing/selftests/powerpc/tm/tm-unavailable.c
index 156c8e750259b..09894f4ff62e6 100644
--- a/tools/testing/selftests/powerpc/tm/tm-unavailable.c
+++ b/tools/testing/selftests/powerpc/tm/tm-unavailable.c
@@ -236,7 +236,8 @@ void *tm_una_ping(void *input)
 	}
 
 	/* Check if we were not expecting a failure and a it occurred. */
-	if (!expecting_failure() && is_failure(cr_)) {
+	if (!expecting_failure() && is_failure(cr_) &&
+	    !failure_is_reschedule()) {
 		printf("\n\tUnexpected transaction failure 0x%02lx\n\t",
 			failure_code());
 		return (void *) -1;
@@ -244,9 +245,11 @@ void *tm_una_ping(void *input)
 
 	/*
 	 * Check if TM failed due to the cause we were expecting. 0xda is a
-	 * TM_CAUSE_FAC_UNAV cause, otherwise it's an unexpected cause.
+	 * TM_CAUSE_FAC_UNAV cause, otherwise it's an unexpected cause, unless
+	 * it was caused by a reschedule.
 	 */
-	if (is_failure(cr_) && !failure_is_unavailable()) {
+	if (is_failure(cr_) && !failure_is_unavailable() &&
+	    !failure_is_reschedule()) {
 		printf("\n\tUnexpected failure cause 0x%02lx\n\t",
 			failure_code());
 		return (void *) -1;
diff --git a/tools/testing/selftests/powerpc/tm/tm.h b/tools/testing/selftests/powerpc/tm/tm.h
index df4204247d45c..5518b1d4ef8b2 100644
--- a/tools/testing/selftests/powerpc/tm/tm.h
+++ b/tools/testing/selftests/powerpc/tm/tm.h
@@ -52,6 +52,15 @@ static inline bool failure_is_unavailable(void)
 	return (failure_code() & TM_CAUSE_FAC_UNAV) == TM_CAUSE_FAC_UNAV;
 }
 
+static inline bool failure_is_reschedule(void)
+{
+	if ((failure_code() & TM_CAUSE_RESCHED) == TM_CAUSE_RESCHED ||
+	    (failure_code() & TM_CAUSE_KVM_RESCHED) == TM_CAUSE_KVM_RESCHED)
+		return true;
+
+	return false;
+}
+
 static inline bool failure_is_nesting(void)
 {
 	return (__builtin_get_texasru() & 0x400000);
-- 
2.20.1

