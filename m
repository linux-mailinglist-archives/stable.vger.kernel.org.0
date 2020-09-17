Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93726D3A0
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 08:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIQGZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 02:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgIQGZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 02:25:31 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 02:25:31 EDT
Received: from e123331-lin.nice.arm.com (unknown [91.140.120.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D4CD20707;
        Thu, 17 Sep 2020 06:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600323596;
        bh=ziD1S262d4AhvP0HlkLo4WCfu8gkBuZJo+18GfJki9c=;
        h=From:To:Cc:Subject:Date:From;
        b=Dfh0zH+QgFdYO0gLoboRtZhySJAl+bjUHgIo8kCQVGjvzCWF7i2BSPEKZiFbSIEGm
         fFSTDES62ApoJHYwFnIAtXQMpjV7DYbIoeuFScbKPT4lMxCYpo/X7ffl/+OEWMkRAK
         4Unu4CMR1SVL+8a4DZhSoF74nrvGspRqV5Nh1iTI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux@armlinux.org.uk, ndesaulniers@google.com,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ARM: vfp: force non-conditional encoding for external Thumb2 tail call
Date:   Thu, 17 Sep 2020 09:19:48 +0300
Message-Id: <20200917061948.12403-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nick reports that the following error is produced in some cases when
using GCC+ld.bfd to build the ARM defconfig with Thumb2 enabled:

  arch/arm/vfp/vfphw.o: in function `vfp_support_entry':
  (.text+0xa): relocation truncated to fit: R_ARM_THM_JUMP19 against
  symbol `vfp_kmode_exception' defined in .text.unlikely section in
  arch/arm/vfp/vfpmodule.o

  $ arm-linux-gnueabihf-ld --version
  GNU ld (GNU Binutils for Debian) 2.34

Generally, the linker should be able to fix up out of range branches by
emitting veneers, but apparently, it fails to do so in this particular
case, i.e., a conditional 'tail call' to vfp_kmode_exception(), which
is not defined in the same object file.

So let's force the use of a non-conditional encoding of the B instruction,
which has more space for an immediate offset.

Cc: <stable@vger.kernel.org>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/vfp/vfphw.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 4fcff9f59947..f1468702fbc9 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -82,6 +82,7 @@ ENTRY(vfp_support_entry)
 	ldr	r3, [sp, #S_PSR]	@ Neither lazy restore nor FP exceptions
 	and	r3, r3, #MODE_MASK	@ are supported in kernel mode
 	teq	r3, #USR_MODE
+THUMB(	it	ne			)
 	bne	vfp_kmode_exception	@ Returns through lr
 
 	VFPFMRX	r1, FPEXC		@ Is the VFP enabled?
-- 
2.17.1

