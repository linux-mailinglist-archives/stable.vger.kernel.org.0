Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795672CE747
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 06:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgLDFHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 00:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgLDFHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 00:07:51 -0500
From:   Andy Lutomirski <luto@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 2/4] membarrier: Add an actual barrier before rseq_preempt()
Date:   Thu,  3 Dec 2020 21:07:04 -0800
Message-Id: <d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607058304.git.luto@kernel.org>
References: <cover.1607058304.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It seems to me that most RSEQ membarrier users will expect any
stores done before the membarrier() syscall to be visible to the
target task(s).  While this is extremely likely to be true in
practice, nothing actually guarantees it by a strict reading of the
x86 manuals.  Rather than providing this guarantee by accident and
potentially causing a problem down the road, just add an explicit
barrier.

Cc: stable@vger.kernel.org
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/sched/membarrier.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 5a40b3828ff2..6251d3d12abe 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -168,6 +168,14 @@ static void ipi_mb(void *info)
 
 static void ipi_rseq(void *info)
 {
+	/*
+	 * Ensure that all stores done by the calling thread are visible
+	 * to the current task before the current task resumes.  We could
+	 * probably optimize this away on most architectures, but by the
+	 * time we've already sent an IPI, the cost of the extra smp_mb()
+	 * is negligible.
+	 */
+	smp_mb();
 	rseq_preempt(current);
 }
 
-- 
2.28.0

