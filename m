Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6986840639E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhIJAsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhIJAYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67D5D60FDA;
        Fri, 10 Sep 2021 00:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233404;
        bh=lZkivQP3DofMjGxIe08apnirKRtBtazACpanOtt5U3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8tKRqY7wX14GIZLP6o+linu0jCKEvJwTA1EOafPMSS461RogyBbf8NL1ZUMHeJ6i
         fFXy0ypOpkG7kMw9ism84p3Cy0+gUXSOC3wElLqf7X5jC6krEgVYmoklUCYyeHJLoy
         VwFJFrmeOm0RKlkAcrXXQLQ/NlP4niVHUrsJ+H1vEYzhLWeka1lm4vxIHzx2AufkZF
         aDODOkJIQoBCXpWythi1qDZLE2H7iQVj3xzZoKrBZuj/DB4El2YH38J5AScqXJR//o
         vMaHk+8Fb2JSitqEBEYAD3EE6XymTF/K6elyy/u3/F1Ax5EW4AtS0EcLxxiSQ2XN3J
         G8bbkB6rfsEWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 10/19] powerpc/32: indirect function call use bctrl rather than blrl in ret_from_kernel_thread
Date:   Thu,  9 Sep 2021 20:23:00 -0400
Message-Id: <20210910002309.176412-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
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
index a2999cd73a82..ea1c00bc6ced 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -468,10 +468,10 @@ ret_from_fork:
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

