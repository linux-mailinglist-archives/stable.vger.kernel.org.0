Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE251383840
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244266AbhEQPu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245377AbhEQPsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:48:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 031376195D;
        Mon, 17 May 2021 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262710;
        bh=sR9RtU9rmIeaagdxWOfkIzp4CvBkwCckfDcFl20vvUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G8bd/P635cFCMzNgk7/wwcUBJtHwPuaUW/xIBId20ag+/on2Qj5LImu81kcfD1D6
         oM8+tFOKJa/ch770mSR3v7RrXuVMIZX64Ux7euDsjBG+2BbrsxJ+WUgl971izPIX3j
         0b9i1ZSM6N0g1+lZMBiSP4NWnYKnvpQk0mn9aVTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.10 274/289] ARM: 9027/1: head.S: explicitly map DT even if it lives in the first physical section
Date:   Mon, 17 May 2021 16:03:19 +0200
Message-Id: <20210517140314.363696055@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 upstream

The early ATAGS/DT mapping code uses SECTION_SHIFT to mask low order
bits of R2, and decides that no ATAGS/DTB were provided if the resulting
value is 0x0.

This means that on systems where DRAM starts at 0x0 (such as Raspberry
Pi), no explicit mapping of the DT will be created if R2 points into the
first 1 MB section of memory. This was not a problem before, because the
decompressed kernel is loaded at the base of DRAM and mapped using
sections as well, and so as long as the DT is referenced via a virtual
address that uses the same translation (the linear map, in this case),
things work fine.

However, commit 7a1be318f579 ("9012/1: move device tree mapping out of
linear region") changes this, and now the DT is referenced via a virtual
address that is disjoint from the linear mapping of DRAM, and so we need
the early code to create the DT mapping unconditionally.

So let's create the early DT mapping for any value of R2 != 0x0.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/head.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -274,10 +274,10 @@ __create_page_tables:
 	 * We map 2 sections in case the ATAGs/DTB crosses a section boundary.
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
-	movs	r0, r0, lsl #SECTION_SHIFT
+	cmp	r2, #0
 	ldrne	r3, =FDT_FIXED_BASE >> (SECTION_SHIFT - PMD_ORDER)
 	addne	r3, r3, r4
-	orrne	r6, r7, r0
+	orrne	r6, r7, r0, lsl #SECTION_SHIFT
 	strne	r6, [r3], #1 << PMD_ORDER
 	addne	r6, r6, #1 << SECTION_SHIFT
 	strne	r6, [r3]


