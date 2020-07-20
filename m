Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C473227096
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGTViC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgGTViB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E25022D04;
        Mon, 20 Jul 2020 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281080;
        bh=dVQ0hwlWWpDvG5Xm+0dZcSPdLlPaxjOtR+QNtoShlzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2zLYRU593nx12iFElgAmBndEGNWW81NANOK3NCUOTpiHnYxh42agFjTaBFAqgUm1
         +diutGeLibd2Jl3Q+7vQ1MyMLqJBaAV5ICquTC4iOeYB5yNbgx8EmYc/bZc1LwNm6/
         qXoar2cKTHQ6nbo140ElTYwj4Gm2ijajVfcVxwgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 36/40] asm-generic/mmiowb: Allow mmiowb_set_pending() when preemptible()
Date:   Mon, 20 Jul 2020 17:37:11 -0400
Message-Id: <20200720213715.406997-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit bd024e82e4cd95c7f1a475a55f99871936c2b2db ]

Although mmiowb() is concerned only with serialising MMIO writes occuring
in contexts where a spinlock is held, the call to mmiowb_set_pending()
from the MMIO write accessors can occur in preemptible contexts, such
as during driver probe() functions where ordering between CPUs is not
usually a concern, assuming that the task migration path provides the
necessary ordering guarantees.

Unfortunately, the default implementation of mmiowb_set_pending() is not
preempt-safe, as it makes use of a a per-cpu variable to track its
internal state. This has been reported to generate the following splat
on riscv:

 | BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0/1
 | caller is regmap_mmio_write32le+0x1c/0x46
 | CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.8.0-rc3-hfu+ #1
 | Call Trace:
 |  walk_stackframe+0x0/0x7a
 |  dump_stack+0x6e/0x88
 |  regmap_mmio_write32le+0x18/0x46
 |  check_preemption_disabled+0xa4/0xaa
 |  regmap_mmio_write32le+0x18/0x46
 |  regmap_mmio_write+0x26/0x44
 |  regmap_write+0x28/0x48
 |  sifive_gpio_probe+0xc0/0x1da

Although it's possible to fix the driver in this case, other splats have
been seen from other drivers, including the infamous 8250 UART, and so
it's better to address this problem in the mmiowb core itself.

Fix mmiowb_set_pending() by using the raw_cpu_ptr() to get at the mmiowb
state and then only updating the 'mmiowb_pending' field if we are not
preemptible (i.e. we have a non-zero nesting count).

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reported-by: Palmer Dabbelt <palmer@dabbelt.com>
Reported-by: Emil Renner Berthing <kernel@esmil.dk>
Tested-by: Emil Renner Berthing <kernel@esmil.dk>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Link: https://lore.kernel.org/r/20200716112816.7356-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/mmiowb.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/mmiowb.h b/include/asm-generic/mmiowb.h
index 9439ff037b2d1..5698fca3bf560 100644
--- a/include/asm-generic/mmiowb.h
+++ b/include/asm-generic/mmiowb.h
@@ -27,7 +27,7 @@
 #include <asm/smp.h>
 
 DECLARE_PER_CPU(struct mmiowb_state, __mmiowb_state);
-#define __mmiowb_state()	this_cpu_ptr(&__mmiowb_state)
+#define __mmiowb_state()	raw_cpu_ptr(&__mmiowb_state)
 #else
 #define __mmiowb_state()	arch_mmiowb_state()
 #endif	/* arch_mmiowb_state */
@@ -35,7 +35,9 @@ DECLARE_PER_CPU(struct mmiowb_state, __mmiowb_state);
 static inline void mmiowb_set_pending(void)
 {
 	struct mmiowb_state *ms = __mmiowb_state();
-	ms->mmiowb_pending = ms->nesting_count;
+
+	if (likely(ms->nesting_count))
+		ms->mmiowb_pending = ms->nesting_count;
 }
 
 static inline void mmiowb_spin_lock(void)
-- 
2.25.1

