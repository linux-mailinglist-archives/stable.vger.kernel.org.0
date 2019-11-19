Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCB010181E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfKSFfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbfKSFfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9B220672;
        Tue, 19 Nov 2019 05:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141733;
        bh=SXNKvy0fhdk/59LQap0bFKFWEbNXfleA9TbgtbVruJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZXifavFfAZQOMNoJKInriPxUHT6vT56p43FJndskOIUSm9UvOTxTut4yvPQ3PC1r
         ULP7Zytyfq+FiFEx2OUkRXy8ShgD3HSqUH9o09BXh7taFeZR4bZ4tBrudLrE/Ss3K1
         JbYRWdYVZoTdNv6i37xQ30V5pjSsZZaSnf/7agzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 261/422] selftests/powerpc: Do not fail with reschedule
Date:   Tue, 19 Nov 2019 06:17:38 +0100
Message-Id: <20191119051415.905614318@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



