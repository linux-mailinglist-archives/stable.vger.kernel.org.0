Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982361CB02C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgEHMhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgEHMhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21E7207DD;
        Fri,  8 May 2020 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941427;
        bh=pfASahavKa16Lvl68B6Op42wIy+UUATPo81BC8/T67M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSxgoUjUxwxxXY4jPcgK+wkjssOnMPyXckgnLsqpFMWj2N6peXL3ccgk6IFSs0yww
         2P10El7tXp37GVPsYiCieGkoPw4Z2AtjjI7nSMcvrHIlFIp0CshDBBu63UX4VeQ+d8
         zvhT3ZPb9DtlRZZwn8CE8nmZZB4ylbMrazYHN7S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Leonid Yegoshin <leonid.yegoshin@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 028/312] MIPS: c-r4k: Fix protected_writeback_scache_line for EVA
Date:   Fri,  8 May 2020 14:30:19 +0200
Message-Id: <20200508123126.462083642@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit 0758b116b4080d9a2a2a715bec6eee2cbd828215 upstream.

The protected_writeback_scache_line() function is used by
local_r4k_flush_cache_sigtramp() to flush an FPU delay slot emulation
trampoline on the userland stack from the caches so it is visible to
subsequent instruction fetches.

Commit de8974e3f76c ("MIPS: asm: r4kcache: Add EVA cache flushing
functions") updated some protected_ cache flush functions to use EVA
CACHEE instructions via protected_cachee_op(), and commit 83fd43449baa
("MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line") did
the same thing for protected_writeback_dcache_line(), but
protected_writeback_scache_line() never got updated. Lets fix that now
to flush the right user address from the secondary cache rather than
some arbitrary kernel unmapped address.

This issue was spotted through code inspection, and it seems unlikely to
be possible to hit this in practice. It theoretically affect EVA kernels
on EVA capable cores with an L2 cache, where the icache fetches straight
from RAM (cpu_icache_snoops_remote_store == 0), running a hard float
userland with FPU disabled (nofpu). That both Malta and Boston platforms
override cpu_icache_snoops_remote_store to 1 suggests that all MIPS
cores fetch instructions into icache straight from L2 rather than RAM.

Fixes: de8974e3f76c ("MIPS: asm: r4kcache: Add EVA cache flushing functions")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Leonid Yegoshin <leonid.yegoshin@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13800/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/r4kcache.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -210,7 +210,11 @@ static inline void protected_writeback_d
 
 static inline void protected_writeback_scache_line(unsigned long addr)
 {
+#ifdef CONFIG_EVA
+	protected_cachee_op(Hit_Writeback_Inv_SD, addr);
+#else
 	protected_cache_op(Hit_Writeback_Inv_SD, addr);
+#endif
 }
 
 /*


