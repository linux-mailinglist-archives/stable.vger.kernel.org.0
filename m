Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542312C9BF9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390153AbgLAJNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390150AbgLAJNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C026E20656;
        Tue,  1 Dec 2020 09:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813978;
        bh=1y1EnHCggBSrN+kP9QH7fU+iKszKeC/wn4B5PpRxN58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zk2b4VEa6nuB8IhvoxCaAlfds/HFYMMKPN15vP9ubnlNeVTaABI6JjyABDF+HK5Qk
         FyJYhdR7LUjS8cB0pLwraFXnEZJaGMthfjhc07D11Hq5hsB+KCW2pSX3vq02eMEGDw
         PbO3QBCH2Uilq/24UzV/S0m3fau11nZeTQExsiJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 125/152] RISC-V: fix barrier() use in <vdso/processor.h>
Date:   Tue,  1 Dec 2020 09:54:00 +0100
Message-Id: <20201201084728.182880570@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 30aca1bacb398dec6c1ed5eeca33f355bd7b6203 ]

riscv's <vdso/processor.h> uses barrier() so it should include
<asm/barrier.h>

Fixes this build error:
  CC [M]  drivers/net/ethernet/emulex/benet/be_main.o
In file included from ./include/vdso/processor.h:10,
                 from ./arch/riscv/include/asm/processor.h:11,
                 from ./include/linux/prefetch.h:15,
                 from drivers/net/ethernet/emulex/benet/be_main.c:14:
./arch/riscv/include/asm/vdso/processor.h: In function 'cpu_relax':
./arch/riscv/include/asm/vdso/processor.h:14:2: error: implicit declaration of function 'barrier' [-Werror=implicit-function-declaration]
   14 |  barrier();

This happens with a total of 5 networking drivers -- they all use
<linux/prefetch.h>.

rv64 allmodconfig now builds cleanly after this patch.

Fixes fallout from:
815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")

Fixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce the latency of the time-related functions")
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vdso/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include/asm/vdso/processor.h
index 82a5693b18614..134388cbaaa1d 100644
--- a/arch/riscv/include/asm/vdso/processor.h
+++ b/arch/riscv/include/asm/vdso/processor.h
@@ -4,6 +4,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/barrier.h>
+
 static inline void cpu_relax(void)
 {
 #ifdef __riscv_muldiv
-- 
2.27.0



