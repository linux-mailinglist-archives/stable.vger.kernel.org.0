Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E15FF488F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbfKHL5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390982AbfKHLpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D872246A;
        Fri,  8 Nov 2019 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213499;
        bh=4BlJTgCIHYa86nRJU6GQNdjkNoCpN8bYhMvm2xuHntA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IswJPLsOOM0ngF8YLUyW6zkJXBtjj1AEmm8cek5shdQ+9tSXDTA11fELmVxpKeTlf
         20fbSWFRAzPmEVm0QZCCS2dwg+kIB2hjL8nJmt3EmpPIsYMZuR0MiDAwt+s66VX3kw
         gaX11euX+x61fje+H1MavmchS64jNWqyK48yy2v4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 076/103] kprobes: Don't call BUG_ON() if there is a kprobe in use on free list
Date:   Fri,  8 Nov 2019 06:42:41 -0500
Message-Id: <20191108114310.14363-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit cbdd96f5586151e48317d90a403941ec23f12660 ]

Instead of calling BUG_ON(), if we find a kprobe in use on free kprobe
list, just remove it from the list and keep it on kprobe hash list
as same as other in-use kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S . Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naveen N . Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/153666126882.21306.10738207224288507996.stgit@devbox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f7a4602a76f98..d0fe20a5475f7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -544,8 +544,14 @@ static void do_free_cleaned_kprobes(void)
 	struct optimized_kprobe *op, *tmp;
 
 	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
-		BUG_ON(!kprobe_unused(&op->kp));
 		list_del_init(&op->list);
+		if (WARN_ON_ONCE(!kprobe_unused(&op->kp))) {
+			/*
+			 * This must not happen, but if there is a kprobe
+			 * still in use, keep it on kprobes hash list.
+			 */
+			continue;
+		}
 		free_aggr_kprobe(&op->kp);
 	}
 }
-- 
2.20.1

