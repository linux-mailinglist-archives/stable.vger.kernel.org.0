Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594BF16954D
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgBWCVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbgBWCVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:21:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D404A2067D;
        Sun, 23 Feb 2020 02:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424498;
        bh=4BypovxFTpsOw6CslQIrS8l2iIcg0DbMZ7zyR66ltGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv3kiQmtt6761JCgZYY03CFN+QlNwSo1CwJvsCanXJ+2I72bKs/32RzgYM4fJElqu
         eEciJP/o9KWz7aHkvy+aYyuSr1Yi9k7PgwDQsAtb8Xq54Wh3+M/rIFnLWlVaPLmefG
         iKk19ODzQnSWXp0CcQs6rO3vnmeRI+uVSjRS1/cg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 15/58] arm/ftrace: Fix BE text poking
Date:   Sat, 22 Feb 2020 21:20:36 -0500
Message-Id: <20200223022119.707-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit be993e44badc448add6a18d6f12b20615692c4c3 ]

The __patch_text() function already applies __opcode_to_mem_*(), so
when __opcode_to_mem_*() is not the identity (BE*), it is applied
twice, wrecking the instruction.

Fixes: 42e51f187f86 ("arm/ftrace: Use __patch_text()")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/ftrace.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index bda949fd84e8b..93caf757f1d5d 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -81,13 +81,10 @@ static int ftrace_modify_code(unsigned long pc, unsigned long old,
 {
 	unsigned long replaced;
 
-	if (IS_ENABLED(CONFIG_THUMB2_KERNEL)) {
+	if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
 		old = __opcode_to_mem_thumb32(old);
-		new = __opcode_to_mem_thumb32(new);
-	} else {
+	else
 		old = __opcode_to_mem_arm(old);
-		new = __opcode_to_mem_arm(new);
-	}
 
 	if (validate) {
 		if (probe_kernel_read(&replaced, (void *)pc, MCOUNT_INSN_SIZE))
-- 
2.20.1

