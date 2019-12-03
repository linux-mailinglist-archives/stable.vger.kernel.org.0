Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8998F111EAA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfLCWwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729914AbfLCWwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380AC214AF;
        Tue,  3 Dec 2019 22:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413572;
        bh=j7KbmtmkT44bfLvNzW6tYCDaM4Eo1gsgtSpVmt6J7mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYkpC7IpJhns4nHugd2/xw1k4hNMJppYqU9q93KNxZIB6EUnPgjLMYx2MbSgJqmqd
         g5TUVqjb4MGLoAswmfNUQGPJmuhttNCxf37a+Z0K4q60NmBk1a/OKdepTWaq0SK1eM
         5jZFzWmmb0ghhuV5Dbsa4Dq1p3QoJ3aO/dTpvEkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/321] powerpc: Fix HMIs on big-endian with CONFIG_RELOCATABLE=y
Date:   Tue,  3 Dec 2019 23:34:06 +0100
Message-Id: <20191203223436.492214219@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 505a314fb28ce122091691c51426fa85c084e115 ]

HMIs will crash the kernel due to

	BRANCH_LINK_TO_FAR(hmi_exception_realmode)

Calling into the OPD instead of the actual code.

Fixes: 2337d207288f ("powerpc/64: CONFIG_RELOCATABLE support for hmi interrupts")
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[mpe: Use DOTSYM() rather than #ifdef]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 90af86f143a91..e1dab9b1e4478 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1123,7 +1123,7 @@ TRAMP_REAL_BEGIN(hmi_exception_early)
 	EXCEPTION_PROLOG_COMMON_2(PACA_EXGEN)
 	EXCEPTION_PROLOG_COMMON_3(0xe60)
 	addi	r3,r1,STACK_FRAME_OVERHEAD
-	BRANCH_LINK_TO_FAR(hmi_exception_realmode) /* Function call ABI */
+	BRANCH_LINK_TO_FAR(DOTSYM(hmi_exception_realmode)) /* Function call ABI */
 	cmpdi	cr0,r3,0
 
 	/* Windup the stack. */
-- 
2.20.1



