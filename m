Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39A883C95
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfHFVeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbfHFVee (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00472186A;
        Tue,  6 Aug 2019 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127273;
        bh=BA+UGscKPxuHl3GcdkS7m3JOxOxCmTFTvrCrso1YyF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOH2o4JDkeT5aoSs9KFR8S9XHuUmM3HGCoHFjFeTGf1f8GD8ehcu6/7qxEZN8LcL8
         IKXF9VdGmhZCFzGcY4/wNiCATSTIQXflaCji6G0TPhAGXWrhuBiV0TdyV9VQbEkEgL
         RDrC3fXcqTAzU+l8Ai6p48opgkk2bTEUkTlaxuU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Han <han_mao@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 38/59] riscv: Fix perf record without libelf support
Date:   Tue,  6 Aug 2019 17:32:58 -0400
Message-Id: <20190806213319.19203-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Han <han_mao@c-sky.com>

[ Upstream commit b399abe7c21e248dc6224cadc9a378a2beb10cfd ]

This patch fix following perf record error by linking vdso.so with
build id.

perf.data      perf.data.old
[ perf record: Woken up 1 times to write data ]
free(): double free detected in tcache 2
Aborted

perf record use filename__read_build_id(util/symbol-minimal.c) to get
build id when libelf is not supported. When vdso.so is linked without
build id, the section size of PT_NOTE will be zero, buf size will
realloc to zero and cause memory corruption.

Signed-off-by: Mao Han <han_mao@c-sky.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index f1d6ffe43e428..49a5852fd07dd 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -37,7 +37,7 @@ $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
 # these symbols in the kernel code rather than hand-coded addresses.
 
 SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
-	-Wl,--hash-style=both
+	-Wl,--build-id -Wl,--hash-style=both
 $(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
 	$(call if_changed,vdsold)
 
-- 
2.20.1

