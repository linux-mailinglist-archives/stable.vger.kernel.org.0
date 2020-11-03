Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDE2A566D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbgKCV2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733199AbgKCVA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:00:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34EA6223FD;
        Tue,  3 Nov 2020 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437227;
        bh=h8VO8aKLMLf4XmZjmCqV56IrKC+YonT/HRfwBjcxFM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjTbktvr0vqYhXBGScjD3wmujtEFYhOj29Cwgy2QVRJZZ87V4AwSxuYAq9CEdKBpL
         ZmmXwSJn+d5QDuSq3lktTBdXdOZsVXtxK1/SoDiCk+Vmlhnfn5OB39/nXXsFZL2x1K
         LlXV4b1uVdA4dCMqSTfWVURXKutvBzf5eJ1Dtayo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 163/214] powerpc: Fix undetected data corruption with P9N DD2.1 VSX CI load emulation
Date:   Tue,  3 Nov 2020 21:36:51 +0100
Message-Id: <20201103203306.048306295@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

commit 1da4a0272c5469169f78cd76cf175ff984f52f06 upstream.

__get_user_atomic_128_aligned() stores to kaddr using stvx which is a
VMX store instruction, hence kaddr must be 16 byte aligned otherwise
the store won't occur as expected.

Unfortunately when we call __get_user_atomic_128_aligned() in
p9_hmi_special_emu(), the buffer we pass as kaddr (ie. vbuf) isn't
guaranteed to be 16B aligned. This means that the write to vbuf in
__get_user_atomic_128_aligned() has the bottom bits of the address
truncated. This results in other local variables being
overwritten. Also vbuf will not contain the correct data which results
in the userspace emulation being wrong and hence undetected user data
corruption.

In the past we've been mostly lucky as vbuf has ended up aligned but
this is fragile and isn't always true. CONFIG_STACKPROTECTOR in
particular can change the stack arrangement enough that our luck runs
out.

This issue only occurs on POWER9 Nimbus <= DD2.1 bare metal.

The fix is to align vbuf to a 16 byte boundary.

Fixes: 5080332c2c89 ("powerpc/64s: Add workaround for P9 vector CI load issue")
Cc: stable@vger.kernel.org # v4.15+
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201013043741.743413-1-mikey@neuling.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -877,7 +877,7 @@ static void p9_hmi_special_emu(struct pt
 {
 	unsigned int ra, rb, t, i, sel, instr, rc;
 	const void __user *addr;
-	u8 vbuf[16], *vdst;
+	u8 vbuf[16] __aligned(16), *vdst;
 	unsigned long ea, msr, msr_mask;
 	bool swap;
 


