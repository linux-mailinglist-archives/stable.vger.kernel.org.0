Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3A147A7F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgAXJeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbgAXJeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:34:10 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F47B24125;
        Fri, 24 Jan 2020 09:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858449;
        bh=iROWKBdG0i9Uzw7teC7DQ+rsN5didNdgV94XLJ/+7+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/hgiwuda9gtT0ewVUj0FAZPrqheItb9eIGpyJqWSXxpeLvM4UJkjS9F7eQFt0tyi
         W45zGGTwvSrdO9W2DzSbUnx2AfdMFRmBmVaLWropGPwhrTOckp9SDG5XP+Neuo43Z+
         +fh4AwH0BT+654gzBFBn0SkZzU3xGLzvQqu7WX1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lexi Shao <shaolexi@huawei.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 021/102] powerpc/kasan: Fix boot failure with RELOCATABLE && FSL_BOOKE
Date:   Fri, 24 Jan 2020 10:30:22 +0100
Message-Id: <20200124092809.370962296@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 71eb40fc53371bc247c8066ae76ad9e22ae1e18d upstream.

When enabling CONFIG_RELOCATABLE and CONFIG_KASAN on FSL_BOOKE,
the kernel doesn't boot.

relocate_init() requires KASAN early shadow area to be set up because
it needs access to the device tree through generic functions.

Call kasan_early_init() before calling relocate_init()

Reported-by: Lexi Shao <shaolexi@huawei.com>
Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b58426f1664a4b344ff696d18cacf3b3e8962111.1575036985.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_fsl_booke.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -238,6 +238,9 @@ set_ivor:
 
 	bl	early_init
 
+#ifdef CONFIG_KASAN
+	bl	kasan_early_init
+#endif
 #ifdef CONFIG_RELOCATABLE
 	mr	r3,r30
 	mr	r4,r31
@@ -264,9 +267,6 @@ set_ivor:
 /*
  * Decide what sort of machine this is and initialize the MMU.
  */
-#ifdef CONFIG_KASAN
-	bl	kasan_early_init
-#endif
 	mr	r3,r30
 	mr	r4,r31
 	bl	machine_init


