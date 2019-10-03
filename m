Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2DCA6BE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392968AbfJCQqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392962AbfJCQqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF9D215EA;
        Thu,  3 Oct 2019 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121213;
        bh=u0T2dyeWQ2iXGTmKLsR8pupBhDmMNegGZokKL2UQOkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uc6tZ3d3uVEPFH9QQz5qf82NcHY+8tTSYiXKTS7u4J2o4yKoNSWvfWgAmnqTXxboT
         umAdxnV4j6xP839yoGQoeZzpYl4QXb4PpzOabyZX/UQIVORQS+eVFsAkQUbApCL7D1
         KcGYVh8SHqEXyH/BwI+QF/oBPBCml34EZOJ9WQls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 197/344] x86/mm: Fix cpumask_of_node() error condition
Date:   Thu,  3 Oct 2019 17:52:42 +0200
Message-Id: <20191003154559.643594255@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit bc04a049f058a472695aa22905d57e2b1f4c77d9 ]

When CONFIG_DEBUG_PER_CPU_MAPS=y we validate that the @node argument of
cpumask_of_node() is a valid node_id. It however forgets to check for
negative numbers. Fix this by explicitly casting to unsigned int.

  (unsigned)node >= nr_node_ids

verifies: 0 <= node < nr_node_ids

Also ammend the error message to match the condition.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Link: https://lkml.kernel.org/r/20190903075352.GY2369@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e6dad600614c2..4123100e0eafe 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -861,9 +861,9 @@ void numa_remove_cpu(int cpu)
  */
 const struct cpumask *cpumask_of_node(int node)
 {
-	if (node >= nr_node_ids) {
+	if ((unsigned)node >= nr_node_ids) {
 		printk(KERN_WARNING
-			"cpumask_of_node(%d): node > nr_node_ids(%u)\n",
+			"cpumask_of_node(%d): (unsigned)node >= nr_node_ids(%u)\n",
 			node, nr_node_ids);
 		dump_stack();
 		return cpu_none_mask;
-- 
2.20.1



