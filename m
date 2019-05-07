Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EAD15BA9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfEGF4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbfEGFh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 473C221744;
        Tue,  7 May 2019 05:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207477;
        bh=pDLDkI34/bMifWaMB9y5Jcs2j0YqpN098bGuLfV9x1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBGMlRgWQaQG58y3fAOvR4qs6ub5oOVYmuEqxVfiT+62R585ekvemVsKOpikFv+L9
         zawdZhobFAIU8IdlHS9Jbb9fUdSkogrEFQDi4a6oa0XduFEbzND+VFrHkG6t3PQ+L6
         dG9HEpfDn1Kw/Vek/4duCuUXEGClrJdXysgUT0Po=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 64/81] powerpc/smp: Fix NMI IPI timeout
Date:   Tue,  7 May 2019 01:35:35 -0400
Message-Id: <20190507053554.30848-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 1b5fc84aba170bdfe3533396ca9662ceea1609b7 ]

The NMI IPI timeout logic is broken, if __smp_send_nmi_ipi() times out
on the first condition, delay_us will be zero which will send it into
the second spin loop with no timeout so it will spin forever.

Fixes: 5b73151fff63 ("powerpc: NMI IPI make NMI IPIs fully sychronous")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/powerpc/kernel/smp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 61c1fadbc644..22abba5f4cf0 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -499,7 +499,7 @@ int __smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us, bool
 		if (delay_us) {
 			delay_us--;
 			if (!delay_us)
-				break;
+				goto timeout;
 		}
 	}
 
@@ -510,10 +510,11 @@ int __smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us, bool
 		if (delay_us) {
 			delay_us--;
 			if (!delay_us)
-				break;
+				goto timeout;
 		}
 	}
 
+timeout:
 	if (!cpumask_empty(&nmi_ipi_pending_mask)) {
 		/* Timeout waiting for CPUs to call smp_handle_nmi_ipi */
 		ret = 0;
-- 
2.20.1

