Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4974063B5
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhIJAsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234881AbhIJAZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADFFB60FDA;
        Fri, 10 Sep 2021 00:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233431;
        bh=82y4RJ4iA7LFB3pbeMsKe77i3b8Q3omHsbppXGPBrms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogFivG+Ik4ZGeEGJe5sZ7VqPaGyBMg+c32FeRxRVYZkJOB6llKmv8OzP4U+ubIH3j
         5EXkDmcJShqWJX6PmYzasCqvH/gVcH7vde8TI6UpAM3MqeuscsByVjmsTPFNFlDZEf
         yO6INo+/Vhv/gShnE19DWYHql8BTAXaNsylQg/A25gS962h5FOXr9AG/UmpMfoa5lR
         R7BfPlObw4lNqgrVPNmIODyqLFudptYlRbQ4UgAFmDm31BdTdjMVitFlZzMOSVvjwI
         z/psJFreNCMw+JZ0PVskm0p2gbB/X/V+S8HrHBA+2H/IHQm8DOsIreGcbmEszmpZnE
         Zd33AOlfE/w5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 09/17] powerpc/32: indirect function call use bctrl rather than blrl in ret_from_kernel_thread
Date:   Thu,  9 Sep 2021 20:23:30 -0400
Message-Id: <20210910002338.176677-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 113ec9ccc8049c3772f0eab46b62c5d6654c09f7 ]

Copied from commit 89bbe4c798bc ("powerpc/64: indirect function call
use bctrl rather than blrl in ret_from_kernel_thread")

blrl is not recommended to use as an indirect function call, as it may
corrupt the link stack predictor.

This is not a performance critical path but this should be fixed for
consistency.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/91b1d242525307ceceec7ef6e832bfbacdd4501b.1629436472.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/entry_32.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index bdd88f9d7926..50a267bc56cc 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -455,10 +455,10 @@ ret_from_fork:
 ret_from_kernel_thread:
 	REST_NVGPRS(r1)
 	bl	schedule_tail
-	mtlr	r14
+	mtctr	r14
 	mr	r3,r15
 	PPC440EP_ERR42
-	blrl
+	bctrl
 	li	r3,0
 	b	ret_from_syscall
 
-- 
2.30.2

