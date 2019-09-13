Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA86BB1FF0
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389003AbfIMNLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388968AbfIMNLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:38 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C58C214AE;
        Fri, 13 Sep 2019 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380298;
        bh=fnklbgzgvFBnb/NQeX2JR8VGGnefvxq8JcceyaWMSVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArY4Xg/cZeU02zI44v2WyREm2wFTjy4boZqoJ8qhbVR9twQbdU4tTjs6kz1DTX2Ha
         NdwEF7B8HUFPMzz/dfAqwtwD+E+qj980X7cJWqPlX1CULM9OKNdchpUNU/4yJ+Wec8
         8GT7wDg9Z+Fokf7FGiDZjTnLJezdGe/hsfb9artg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/190] powerpc/64: mark start_here_multiplatform as __ref
Date:   Fri, 13 Sep 2019 14:04:35 +0100
Message-Id: <20190913130601.185759697@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9c4e4c90ec24652921e31e9551fcaedc26eec86d ]

Otherwise, the following warning is encountered:

WARNING: vmlinux.o(.text+0x3dc6): Section mismatch in reference from the variable start_here_multiplatform to the function .init.text:.early_setup()
The function start_here_multiplatform() references
the function __init .early_setup().
This is often because start_here_multiplatform lacks a __init
annotation or the annotation of .early_setup is wrong.

Fixes: 56c46bba9bbf ("powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX")
Cc: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 9168a247e24ff..3fb564f3e8874 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -906,6 +906,7 @@ p_toc:	.8byte	__toc_start + 0x8000 - 0b
 /*
  * This is where the main kernel code starts.
  */
+__REF
 start_here_multiplatform:
 	/* set up the TOC */
 	bl      relative_toc
@@ -981,6 +982,7 @@ start_here_multiplatform:
 	RFI
 	b	.	/* prevent speculative execution */
 
+	.previous
 	/* This is where all platforms converge execution */
 
 start_here_common:
-- 
2.20.1



