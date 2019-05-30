Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80172EF51
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbfE3DTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731848AbfE3DTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:15 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0744F2485E;
        Thu, 30 May 2019 03:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186355;
        bh=zmCdAn9dAnPcSZ07GrUCxCZ+in2QjZV2IqkciN5z/vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wd/JYJcgAiHS06LPrErkBzXNUc+E1gNfoyaTHCD0I4PjvrzqPbQpBS3PVRRGiGZCF
         dd13RFkR4tkLCQn6sIAx6R2uLwgqGHS1tf4XIM/LGnXNScGEkYvG9/E+nzGXe8i7vj
         LD/MGO9kReAw/etr+xC5slhfwqMH6uhUM6AyrffQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/193] powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX
Date:   Wed, 29 May 2019 20:05:51 -0700
Message-Id: <20190530030502.511689011@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 56c46bba9bbfe229b4472a5be313c44c5b714a39 ]

With STRICT_KERNEL_RWX enabled anything marked __init is placed at a 16M
boundary.  This is necessary so that it can be repurposed later with
different permissions.  However, in kernels with text larger than 16M,
this pushes early_setup past 32M, incapable of being reached by the
branch instruction.

Fix this by setting the CTR and branching there instead.

Fixes: 1e0fc9d1eb2b ("powerpc/Kconfig: Enable STRICT_KERNEL_RWX for some configs")
Signed-off-by: Russell Currey <ruscur@russell.cc>
[mpe: Fix it to work on BE by using DOTSYM()]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_64.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index ff8511d6d8ead..4f2e18266e34a 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -961,7 +961,9 @@ start_here_multiplatform:
 
 	/* Restore parameters passed from prom_init/kexec */
 	mr	r3,r31
-	bl	early_setup		/* also sets r13 and SPRG_PACA */
+	LOAD_REG_ADDR(r12, DOTSYM(early_setup))
+	mtctr	r12
+	bctrl		/* also sets r13 and SPRG_PACA */
 
 	LOAD_REG_ADDR(r3, start_here_common)
 	ld	r4,PACAKMSR(r13)
-- 
2.20.1



