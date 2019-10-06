Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F199CD40C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfJFRTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfJFRTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:19:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6A420835;
        Sun,  6 Oct 2019 17:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382376;
        bh=JWnS6eCa3vkdo1jTO8fCCNR5Mxxo+4+dhhhRNHODc+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbYtJUEmRdxeoIpPvzt3g9QKLHkmD2/Slihf/MGhQnkGVqLv5+XuJ6Ai+H3i52/wN
         69aelOXGM1b5ULIwJjocUgsYULJTMSWxZOhD1PpH42ZGiQDXUsdG2c6+VHeNN9YXu5
         fKaHtzK7rTPgw2fQ22Z00EPl3/g0tsAO+oSMFVFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/36] powerpc/pseries: correctly track irq state in default idle
Date:   Sun,  6 Oct 2019 19:18:55 +0200
Message-Id: <20191006171049.740975554@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 92c94dfb69e350471473fd3075c74bc68150879e ]

prep_irq_for_idle() is intended to be called before entering
H_CEDE (and it is used by the pseries cpuidle driver). However the
default pseries idle routine does not call it, leading to mismanaged
lazy irq state when the cpuidle driver isn't in use. Manifestations of
this include:

* Dropped IPIs in the time immediately after a cpu comes
  online (before it has installed the cpuidle handler), making the
  online operation block indefinitely waiting for the new cpu to
  respond.

* Hitting this WARN_ON in arch_local_irq_restore():
	/*
	 * We should already be hard disabled here. We had bugs
	 * where that wasn't the case so let's dbl check it and
	 * warn if we are wrong. Only do that when IRQ tracing
	 * is enabled as mfmsr() can be costly.
	 */
	if (WARN_ON_ONCE(mfmsr() & MSR_EE))
		__hard_irq_disable();

Call prep_irq_for_idle() from pseries_lpar_idle() and honor its
result.

Fixes: 363edbe2614a ("powerpc: Default arch idle could cede processor on pseries")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190910225244.25056-1-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 9cc976ff7fecc..88fcf6a95fa67 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -369,6 +369,9 @@ static void pseries_lpar_idle(void)
 	 * low power mode by cedeing processor to hypervisor
 	 */
 
+	if (!prep_irq_for_idle())
+		return;
+
 	/* Indicate to hypervisor that we are idle. */
 	get_lppaca()->idle = 1;
 
-- 
2.20.1



