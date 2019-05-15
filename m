Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7973B1ED00
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfEOLEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbfEOLED (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132332084F;
        Wed, 15 May 2019 11:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918242;
        bh=pJOGQxL8js92D2ZmrZ8Cv29N2yQDX0ZLCt6D+jVAz7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsGAoY+5x6dOeOTeSaZP1LPgjcTdnSSdwmh8l7Nvd+IjZiRAXuNyZOCLB2T1qgpT0
         uKJHmwo8LXeeSlWceJC5sXUbcYpXd2mR7icU27XZNWLep5ymYhJKA8vKOdk/hxyvdv
         5Nbullod1IKO3KhpTTGpRHgPh0QSYF2rBoI3/GPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 058/266] powerpc/fsl: Add macro to flush the branch predictor
Date:   Wed, 15 May 2019 12:52:45 +0200
Message-Id: <20190515090724.402733242@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 1cbf8990d79ff69da8ad09e8a3df014e1494462b upstream.

The BUCSR register can be used to invalidate the entries in the
branch prediction mechanisms.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ppc_asm.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -821,4 +821,15 @@ END_FTR_SECTION_NESTED(CPU_FTR_HAS_PPR,C
 	.long 0x2400004c  /* rfid				*/
 #endif /* !CONFIG_PPC_BOOK3E */
 #endif /*  __ASSEMBLY__ */
+
+#ifdef CONFIG_PPC_FSL_BOOK3E
+#define BTB_FLUSH(reg)			\
+	lis reg,BUCSR_INIT@h;		\
+	ori reg,reg,BUCSR_INIT@l;	\
+	mtspr SPRN_BUCSR,reg;		\
+	isync;
+#else
+#define BTB_FLUSH(reg)
+#endif /* CONFIG_PPC_FSL_BOOK3E */
+
 #endif /* _ASM_POWERPC_PPC_ASM_H */


