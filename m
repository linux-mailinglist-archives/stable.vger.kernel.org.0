Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE10829A0B4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408594AbgJZXtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408583AbgJZXtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ABF720872;
        Mon, 26 Oct 2020 23:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756148;
        bh=tguj/0U9f+WJ+JjUiME69FnKBajQQPSWVqFnxkZkV5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6qVn672vb4DOqU+xlg4ZNYIsgjWBnPHSxV5hyEmn4lRrgy3Tw+/H0hpK8e7NDeCf
         2DH6NZpQrvqNi0AFaru0+PlKKCWo2bO7qWcqm3t15UScvyi7fuj1RMqRklFtInaJkQ
         JyJLeRAwhZZFgA9Tclk84e/4duwNOwHGt13txyTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.9 002/147] powerpc/powernv/smp: Fix spurious DBG() warning
Date:   Mon, 26 Oct 2020 19:46:40 -0400
Message-Id: <20201026234905.1022767-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit f6bac19cf65c5be21d14a0c9684c8f560f2096dd ]

When building with W=1 we get the following warning:

 arch/powerpc/platforms/powernv/smp.c: In function ‘pnv_smp_cpu_kill_self’:
 arch/powerpc/platforms/powernv/smp.c:276:16: error: suggest braces around
 	empty body in an ‘if’ statement [-Werror=empty-body]
   276 |      cpu, srr1);
       |                ^
 cc1: all warnings being treated as errors

The full context is this block:

 if (srr1 && !generic_check_cpu_restart(cpu))
 	DBG("CPU%d Unexpected exit while offline srr1=%lx!\n",
 			cpu, srr1);

When building with DEBUG undefined DBG() expands to nothing and GCC emits
the warning due to the lack of braces around an empty statement.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200804005410.146094-2-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index b2ba3e95bda73..bbf361f23ae86 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -43,7 +43,7 @@
 #include <asm/udbg.h>
 #define DBG(fmt...) udbg_printf(fmt)
 #else
-#define DBG(fmt...)
+#define DBG(fmt...) do { } while (0)
 #endif
 
 static void pnv_smp_setup_cpu(int cpu)
-- 
2.25.1

