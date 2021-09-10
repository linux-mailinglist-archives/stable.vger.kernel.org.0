Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B994063C9
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhIJAs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234927AbhIJAZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF6860FC0;
        Fri, 10 Sep 2021 00:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233454;
        bh=Sl5P9ILcuOYwTOCf7XUClOm4ZS/DqxqQQyjcLYKE9vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZgEgOr09FhxyMin83Jzz2gnKJdkFWBCVZdDy1xccciriop2e5dpaN/jVv7g5bECL
         wIZF4hV8mj0cSq5HfovkeYx8eRhzpAsIyawek+4nbNf47zRsBmhrKNQR06xAmQYyVc
         Ob5rTGHDcd4vtanniARviby+A7TDU7CkKTrF6I8U4+GkTo7gc14448DVp1GsAGOWHO
         aPiRUCXibJh1WWzrKhUv5dH1l+BQ529fUncpFMpEL6Z1XcNLsCCWizTPsal25maoM7
         Y1C+7/Fi/t8WyA0tzw0R89LU96of0BuFSGhDaY8uFxL5FoRz6o7nGLuJuLnWf878C8
         nUo/hIy6BDWNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 08/14] powerpc/32: indirect function call use bctrl rather than blrl in ret_from_kernel_thread
Date:   Thu,  9 Sep 2021 20:23:57 -0400
Message-Id: <20210910002403.176887-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002403.176887-1-sashal@kernel.org>
References: <20210910002403.176887-1-sashal@kernel.org>
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
index 609bc7d01f13..2164ff5a171c 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -441,10 +441,10 @@ ret_from_fork:
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

