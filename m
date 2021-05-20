Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A11538A590
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbhETKRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236504AbhETKP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D154361995;
        Thu, 20 May 2021 09:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503941;
        bh=nuChM8ImR0ujZjXzXBnAdo3YIb+qGGAUz7THygdCtGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+EG5tKXdvXFdz/clV89B4WeICHatrm+gAr1/U6BUxEEgIz2VU1083cLPgg6ofgRE
         qE3QEsV16Xx1mBQrc+IC7dW0be+esBCuuyKdbOpRWBGfBrvzQ/ZDiXFLyKyLenVQUL
         8o/ncxJKwwrEAYODH5LpMklTutAOkwhmoCVezhyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "Maciej W. Rozycki" <macro@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        James Hogan <jhogan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 008/323] MIPS: Introduce isa-rev.h to define MIPS_ISA_REV
Date:   Thu, 20 May 2021 11:18:20 +0200
Message-Id: <20210520092120.407563202@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Redfearn <matt.redfearn@mips.com>

commit 1690905240fd45cc04e873312df8574631c9f595 upstream

There are multiple instances in the kernel where we need to include or
exclude particular instructions based on the ISA revision of the target
processor. For MIPS32 / MIPS64, the compiler exports a __mips_isa_rev
define. However, when targeting MIPS I - V, this define is absent. This
leads to each use of __mips_isa_rev having to check that it is defined
first. To simplify this, introduce the isa-rev.h header which always
exports MIPS_ISA_REV. The name is changed so as to avoid confusion with
the compiler builtin and to avoid accidentally using the builtin.
MIPS_ISA_REV is defined to the compilers builtin if provided, or 0,
which satisfies all current usages.

Suggested-by: Paul Burton <paul.burton@mips.com>
Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
Reviewed-by: Maciej W. Rozycki <macro@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/18676/
Signed-off-by: James Hogan <jhogan@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/isa-rev.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 arch/mips/include/asm/isa-rev.h

--- /dev/null
+++ b/arch/mips/include/asm/isa-rev.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 MIPS Tech, LLC
+ * Author: Matt Redfearn <matt.redfearn@mips.com>
+ */
+
+#ifndef __MIPS_ASM_ISA_REV_H__
+#define __MIPS_ASM_ISA_REV_H__
+
+/*
+ * The ISA revision level. This is 0 for MIPS I to V and N for
+ * MIPS{32,64}rN.
+ */
+
+/* If the compiler has defined __mips_isa_rev, believe it. */
+#ifdef __mips_isa_rev
+#define MIPS_ISA_REV __mips_isa_rev
+#else
+/* The compiler hasn't defined the isa rev so assume it's MIPS I - V (0) */
+#define MIPS_ISA_REV 0
+#endif
+
+
+#endif /* __MIPS_ASM_ISA_REV_H__ */


