Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A913122F0E0
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgG0OYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732202AbgG0OYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:24:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2272083E;
        Mon, 27 Jul 2020 14:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859871;
        bh=MutjSMAafDXjPRebpjYD2MZe+oGnDIbyaCZJHeddI8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfogZUZ6rH7QemqeXIObsCuNoiYLja7sZWf3kOf8ZEpsIlwyyH8UGJX0CMmzvo5+b
         yQ/blLhReJHNLrHvqJnBQcbNA0oj1LH8wD05HqxgrNg1obSCD+hpTFecETFEivBwH2
         XOalHOr965RBaxE/e44qqkt87enTah0PBu8ochzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 137/179] RISC-V: Upgrade smp_mb__after_spinlock() to iorw,iorw
Date:   Mon, 27 Jul 2020 16:05:12 +0200
Message-Id: <20200727134939.307666976@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

[ Upstream commit 38b7c2a3ffb1fce8358ddc6006cfe5c038ff9963 ]

While digging through the recent mmiowb preemption issue it came up that
we aren't actually preventing IO from crossing a scheduling boundary.
While it's a bit ugly to overload smp_mb__after_spinlock() with this
behavior, it's what PowerPC is doing so there's some precedent.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/barrier.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/barrier.h b/arch/riscv/include/asm/barrier.h
index 3f1737f301ccb..d0e24aaa2aa06 100644
--- a/arch/riscv/include/asm/barrier.h
+++ b/arch/riscv/include/asm/barrier.h
@@ -58,8 +58,16 @@ do {									\
  * The AQ/RL pair provides a RCpc critical section, but there's not really any
  * way we can take advantage of that here because the ordering is only enforced
  * on that one lock.  Thus, we're just doing a full fence.
+ *
+ * Since we allow writeX to be called from preemptive regions we need at least
+ * an "o" in the predecessor set to ensure device writes are visible before the
+ * task is marked as available for scheduling on a new hart.  While I don't see
+ * any concrete reason we need a full IO fence, it seems safer to just upgrade
+ * this in order to avoid any IO crossing a scheduling boundary.  In both
+ * instances the scheduler pairs this with an mb(), so nothing is necessary on
+ * the new hart.
  */
-#define smp_mb__after_spinlock()	RISCV_FENCE(rw,rw)
+#define smp_mb__after_spinlock()	RISCV_FENCE(iorw,iorw)
 
 #include <asm-generic/barrier.h>
 
-- 
2.25.1



