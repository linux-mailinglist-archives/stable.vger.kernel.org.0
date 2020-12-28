Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98EA2E3DFA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437845AbgL1OUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437843AbgL1OUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08E17207B2;
        Mon, 28 Dec 2020 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165233;
        bh=9z3QhStNbGViDW57q8obpyRWHXlccfZe9wh/heJ9Omg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5teCmd/zN3rRj1ybvoD633r3amgf+vtbVSSIS/vbcYVQWZsOsMteEy4FTYHnJp1u
         QGMtzbNI6n9ndB1bIwyN3TnUbTAAs5ucWWwUR7GVPqPcNsfABb0t6IIrSmeoqKfzRm
         M7OwHtMfbVXKE6I+hTMXhSPIBxDIzKNqdwDoG6ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 460/717] s390/test_unwind: fix CALL_ON_STACK tests
Date:   Mon, 28 Dec 2020 13:47:38 +0100
Message-Id: <20201228125043.007596265@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f22b9c219a798e1bf11110a3d2733d883e6da059 ]

The CALL_ON_STACK tests use the no_dat stack to switch to a different
stack for unwinding tests. If an interrupt or machine check happens
while using that stack, and previously being on the async stack, the
interrupt / machine check entry code (SWITCH_ASYNC) will assume that
the previous context did not use the async stack and happily use the
async stack again.

This will lead to stack corruption of the previous context.

To solve this disable both interrupts and machine checks before
switching to the no_dat stack.

Fixes: 7868249fbbc8 ("s390/test_unwind: add CALL_ON_STACK tests")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/test_unwind.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
index 7c988994931f0..6bad84c372dcb 100644
--- a/arch/s390/lib/test_unwind.c
+++ b/arch/s390/lib/test_unwind.c
@@ -205,12 +205,15 @@ static noinline int unwindme_func3(struct unwindme *u)
 /* This function must appear in the backtrace. */
 static noinline int unwindme_func2(struct unwindme *u)
 {
+	unsigned long flags;
 	int rc;
 
 	if (u->flags & UWM_SWITCH_STACK) {
-		preempt_disable();
+		local_irq_save(flags);
+		local_mcck_disable();
 		rc = CALL_ON_STACK(unwindme_func3, S390_lowcore.nodat_stack, 1, u);
-		preempt_enable();
+		local_mcck_enable();
+		local_irq_restore(flags);
 		return rc;
 	} else {
 		return unwindme_func3(u);
-- 
2.27.0



