Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AA0490EB8
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbiAQRLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbiAQRIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:08:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F4C0613E3;
        Mon, 17 Jan 2022 09:05:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AEAEB8114B;
        Mon, 17 Jan 2022 17:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C918C36AE3;
        Mon, 17 Jan 2022 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439113;
        bh=xX+HrHhYId0Tfufo3/43Ld1U2JB46Xat28lK7sWeS/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oaer+tpLO6zO85RPcZmt8xTKK4NHn4bX7gwt1i/h/eXklaAwZsL7XjG2Hsd0f3JbM
         iFpDbaMoPptVM3duq87IXf8RhG/nN2l+HBkPDfmN1bBekWSzR1WlFEOT4UOY1Dhk4F
         9y9Ouo6uD0QaBC6LhREPPbtmPM7HuB6GTMFSpXfd2m7A0CGry3+3j1xIrIrk6eylRC
         o9ZULPXYtgRv5Vypz7+RwW05Jz1ZcXx0W2AOP2Ex/rcgo4IIlSh0BqomhKg1f544tn
         74MNCHC6NERH/7CqNbL0PA312b8VbSfF1yThMsynNXdR6RLo1OzFBZ/+tfpDDlppLX
         1xuHTyU9mj8kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, hbathini@linux.ibm.com,
        nathanl@linux.ibm.com, clg@kaod.org, parth@linux.ibm.com,
        npiggin@gmail.com, robh@kernel.org, yukuai3@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 08/21] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:04:40 -0500
Message-Id: <20220117170454.1472347-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a4ac0d249a5db80e79d573db9e4ad29354b643a8 ]

setup_profiling_timer() is only needed when CONFIG_PROFILING is enabled.

Fixes the following W=1 warning when CONFIG_PROFILING=n:
  linux/arch/powerpc/kernel/smp.c:1638:5: error: no previous prototype for ‘setup_profiling_timer’

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211124093254.1054750-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index c06cac543f188..82dff003a7fd6 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1296,10 +1296,12 @@ void start_secondary(void *unused)
 	BUG();
 }
 
+#ifdef CONFIG_PROFILING
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
-- 
2.34.1

