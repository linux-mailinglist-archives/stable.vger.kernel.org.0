Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CA82F13DF
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731811AbhAKNQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732312AbhAKNQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3D8A22B30;
        Mon, 11 Jan 2021 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370946;
        bh=ZbujmS69WR6t/uJjXGc7R4rfcFQz2umsIUdMLYASQ8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyNRgusP4qGql0vUHQdiVvd+68HOWlUh+5biZCDvWB9zk74B2F5kx5eGHO+qKWeqt
         rwEie+8C3vd/YsjNfDSJdCMkskrcY44N/QdF6FNjsoWsKodpmMjP+RiKUFYnCbg1Ww
         371rT0eJJOpHwYGwVd8YGty7zaHfQA2CqsjhyZoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 074/145] powerpc/32s: Fix RTAS machine check with VMAP stack
Date:   Mon, 11 Jan 2021 14:01:38 +0100
Message-Id: <20210111130052.084962074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 98bf2d3f4970179c702ef64db658e0553bc6ef3a upstream.

When we have VMAP stack, exception prolog 1 sets r1, not r11.

When it is not an RTAS machine check, don't trash r1 because it is
needed by prolog 1.

Fixes: da7bb43ab9da ("powerpc/32: Fix vmap stack - Properly set r1 before activating MMU")
Fixes: d2e006036082 ("powerpc/32: Use SPRN_SPRG_SCRATCH2 in exception prologs")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Squash in fixup for RTAS machine check from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bc77d61d1c18940e456a2dee464f1e2eda65a3f0.1608621048.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_book3s_32.S |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -262,10 +262,19 @@ __secondary_hold_acknowledge:
 MachineCheck:
 	EXCEPTION_PROLOG_0
 #ifdef CONFIG_PPC_CHRP
+#ifdef CONFIG_VMAP_STACK
+	mtspr	SPRN_SPRG_SCRATCH2,r1
+	mfspr	r1, SPRN_SPRG_THREAD
+	lwz	r1, RTAS_SP(r1)
+	cmpwi	cr1, r1, 0
+	bne	cr1, 7f
+	mfspr	r1, SPRN_SPRG_SCRATCH2
+#else
 	mfspr	r11, SPRN_SPRG_THREAD
 	lwz	r11, RTAS_SP(r11)
 	cmpwi	cr1, r11, 0
 	bne	cr1, 7f
+#endif
 #endif /* CONFIG_PPC_CHRP */
 	EXCEPTION_PROLOG_1 for_rtas=1
 7:	EXCEPTION_PROLOG_2


