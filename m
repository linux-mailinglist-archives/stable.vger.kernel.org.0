Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DCE2A555D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbgKCVJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388415AbgKCVJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5797206B5;
        Tue,  3 Nov 2020 21:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437749;
        bh=UIqfSzJMo6WnLq5ulTz553bqwG4I9sZ5qerzitUXoIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0z+PQLAYK4tp8/28474g9zloF8pjlRHFaQuRVM5MEB60djIPmmJJ8TVU3XP08Cj8
         eYL5CnC+ydOTPvrYDIeQhw3jlKAaIdAjod24p0GcB62C1tE3ooyyu29gcSw5laoF5h
         XVXRV2vnV5KD/yhwkrwHHPO465hIXThEcLTtWMjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 017/125] powerpc/powernv/smp: Fix spurious DBG() warning
Date:   Tue,  3 Nov 2020 21:36:34 +0100
Message-Id: <20201103203159.239202679@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c17f81e433f7d..11d8fde770c38 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -44,7 +44,7 @@
 #include <asm/udbg.h>
 #define DBG(fmt...) udbg_printf(fmt)
 #else
-#define DBG(fmt...)
+#define DBG(fmt...) do { } while (0)
 #endif
 
 static void pnv_smp_setup_cpu(int cpu)
-- 
2.27.0



