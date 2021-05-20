Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB43A38A58B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhETKRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236508AbhETKP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F10961992;
        Thu, 20 May 2021 09:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503943;
        bh=BrOjBnt9DewRdaC055tohcnQ/St4nBuNGSrAG5wErXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZhXlxNsaEidsuWoGsHsJYHHVANfbbi3ITCkjILtYE3qVzbgE5nlwL3C8PEl2XkVL
         WAw71dnNvfJCvDHMWiV0/n+AD3H6cCvJ05T75dlhvf5zJTKb8d+G3VeiOWVdBhbEeF
         G0OTLj5PYFk4GOiees/cpFDjbkgRC2ES6FoSrg4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Redfearn <matt.redfearn@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        "Maciej W. Rozycki" <macro@mips.com>, linux-mips@linux-mips.org,
        James Hogan <jhogan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 009/323] MIPS: cpu-features.h: Replace __mips_isa_rev with MIPS_ISA_REV
Date:   Thu, 20 May 2021 11:18:21 +0200
Message-Id: <20210520092120.438370982@linuxfoundation.org>
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

commit 18ba210a29d08ea96025cb9d19c2eebf65846330 upstream

Remove the need to check that __mips_isa_rev is defined by using the
newly added MIPS_ISA_REV.

Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: "Maciej W. Rozycki" <macro@mips.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/18675/
Signed-off-by: James Hogan <jhogan@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/cpu-features.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -11,6 +11,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpu-info.h>
+#include <asm/isa-rev.h>
 #include <cpu-feature-overrides.h>
 
 /*
@@ -493,7 +494,7 @@
 # define cpu_has_perf		(cpu_data[0].options & MIPS_CPU_PERF)
 #endif
 
-#if defined(CONFIG_SMP) && defined(__mips_isa_rev) && (__mips_isa_rev >= 6)
+#if defined(CONFIG_SMP) && (MIPS_ISA_REV >= 6)
 /*
  * Some systems share FTLB RAMs between threads within a core (siblings in
  * kernel parlance). This means that FTLB entries may become invalid at almost
@@ -525,7 +526,7 @@
 #  define cpu_has_shared_ftlb_entries \
 	(current_cpu_data.options & MIPS_CPU_SHARED_FTLB_ENTRIES)
 # endif
-#endif /* SMP && __mips_isa_rev >= 6 */
+#endif /* SMP && MIPS_ISA_REV >= 6 */
 
 #ifndef cpu_has_shared_ftlb_ram
 # define cpu_has_shared_ftlb_ram 0


