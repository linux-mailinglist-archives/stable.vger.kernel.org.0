Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58D529B4F1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793604AbgJ0PHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789833AbgJ0PDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE4220747;
        Tue, 27 Oct 2020 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810989;
        bh=NRBwGddatv+MfdZJb5wbsyP/OzXrAL3uRMvI8utZBy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apq3OqpyMcxmPVmtGPy7uhSgYbNLsFGxGrxAdkpae6Amg4iYPP5DWg5EfyAz6I1Pv
         Qmfden0XOEsYKAbdi98kOZG5lh2VSsIzsUc9KTxNN/zP+P3xmwSN6swysz0IYbP5aO
         gWhBUtJPHgTd+3jFJTR7iXHyUfT4AkBVxKC2Sa88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 334/633] powerpc/pseries: explicitly reschedule during drmem_lmb list traversal
Date:   Tue, 27 Oct 2020 14:51:17 +0100
Message-Id: <20201027135538.352316674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 9d6792ffe140240ae54c881cc4183f9acc24b4df ]

The drmem lmb list can have hundreds of thousands of entries, and
unfortunately lookups take the form of linear searches. As long as
this is the case, traversals have the potential to monopolize the CPU
and provoke lockup reports, workqueue stalls, and the like unless
they explicitly yield.

Rather than placing cond_resched() calls within various
for_each_drmem_lmb() loop blocks in the code, put it in the iteration
expression of the loop macro itself so users can't omit it.

Introduce a drmem_lmb_next() iteration helper function which calls
cond_resched() at a regular interval during array traversal. Each
iteration of the loop in DLPAR code paths can involve around ten RTAS
calls which can each take up to 250us, so this ensures the check is
performed at worst every few milliseconds.

Fixes: 6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200813151131.2070161-1-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/drmem.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/drmem.h b/arch/powerpc/include/asm/drmem.h
index 414d209f45bbe..1ec6de1a88514 100644
--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_POWERPC_LMB_H
 #define _ASM_POWERPC_LMB_H
 
+#include <linux/sched.h>
+
 struct drmem_lmb {
 	u64     base_addr;
 	u32     drc_index;
@@ -26,8 +28,22 @@ struct drmem_lmb_info {
 
 extern struct drmem_lmb_info *drmem_info;
 
+static inline struct drmem_lmb *drmem_lmb_next(struct drmem_lmb *lmb,
+					       const struct drmem_lmb *start)
+{
+	/*
+	 * DLPAR code paths can take several milliseconds per element
+	 * when interacting with firmware. Ensure that we don't
+	 * unfairly monopolize the CPU.
+	 */
+	if (((++lmb - start) % 16) == 0)
+		cond_resched();
+
+	return lmb;
+}
+
 #define for_each_drmem_lmb_in_range(lmb, start, end)		\
-	for ((lmb) = (start); (lmb) < (end); (lmb)++)
+	for ((lmb) = (start); (lmb) < (end); lmb = drmem_lmb_next(lmb, start))
 
 #define for_each_drmem_lmb(lmb)					\
 	for_each_drmem_lmb_in_range((lmb),			\
-- 
2.25.1



