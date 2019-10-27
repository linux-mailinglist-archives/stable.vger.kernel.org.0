Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBB5E676F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731817AbfJ0VU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731813AbfJ0VU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:57 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925B3205C9;
        Sun, 27 Oct 2019 21:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211257;
        bh=aYvmwZ8K19xAuz/J4n8ZHtP9meBds7d74/RjbcmdqF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6Q4Q+Y8uPtUTaBRRQ+bVlrukV1wntEmlvvYLlidSzRCFqP0oZURAnQOMY9bjGQBx
         mBtexYDxO3gKycbGRC7MR4jftH3R+dATFsGd7PPvGnGNy5Ci9Go13HEHMZtBolIRnl
         GIO6HcH38A0+QVgcGu02WLhXjdAHBRfcY4B1fRrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 043/197] RISC-V: Clear load reservations while restoring hart contexts
Date:   Sun, 27 Oct 2019 21:59:21 +0100
Message-Id: <20191027203354.035458609@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@sifive.com>

[ Upstream commit 18856604b3e7090ce42d533995173ee70c24b1c9 ]

This is almost entirely a comment.  The bug is unlikely to manifest on
existing hardware because there is a timeout on load reservations, but
manifests on QEMU because there is no timeout.

Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/asm.h |  1 +
 arch/riscv/kernel/entry.S    | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index 5a02b7d509408..9c992a88d858f 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -22,6 +22,7 @@
 
 #define REG_L		__REG_SEL(ld, lw)
 #define REG_S		__REG_SEL(sd, sw)
+#define REG_SC		__REG_SEL(sc.d, sc.w)
 #define SZREG		__REG_SEL(8, 4)
 #define LGREG		__REG_SEL(3, 2)
 
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 9b60878a4469c..2a82e0a5af46e 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -98,7 +98,26 @@ _save_context:
  */
 	.macro RESTORE_ALL
 	REG_L a0, PT_SSTATUS(sp)
-	REG_L a2, PT_SEPC(sp)
+	/*
+	 * The current load reservation is effectively part of the processor's
+	 * state, in the sense that load reservations cannot be shared between
+	 * different hart contexts.  We can't actually save and restore a load
+	 * reservation, so instead here we clear any existing reservation --
+	 * it's always legal for implementations to clear load reservations at
+	 * any point (as long as the forward progress guarantee is kept, but
+	 * we'll ignore that here).
+	 *
+	 * Dangling load reservations can be the result of taking a trap in the
+	 * middle of an LR/SC sequence, but can also be the result of a taken
+	 * forward branch around an SC -- which is how we implement CAS.  As a
+	 * result we need to clear reservations between the last CAS and the
+	 * jump back to the new context.  While it is unlikely the store
+	 * completes, implementations are allowed to expand reservations to be
+	 * arbitrarily large.
+	 */
+	REG_L  a2, PT_SEPC(sp)
+	REG_SC x0, a2, PT_SEPC(sp)
+
 	csrw CSR_SSTATUS, a0
 	csrw CSR_SEPC, a2
 
-- 
2.20.1



