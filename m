Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691F338A1AB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhETJdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232367AbhETJbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:31:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DA01613D7;
        Thu, 20 May 2021 09:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502882;
        bh=fRBEVpGFEeuQFVQALto36Js2BDnb8czXNzo5M32cks4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIS8W1JcwQurnATRNzsGHKvc/2N5djIT8toOCMBr+pWQ4N5dLMP5toti8+xPM3Pbj
         ohagiWrCqwhmP73wfa/ITn50U84KLVvR/4DOqhowx9HqYg9tdIFhRFOx4g5vByqnK+
         HU3FaQQSqW1mCzV1U2y9S1kofE8MDmbuhdgbEP+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 01/37] x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
Date:   Thu, 20 May 2021 11:22:22 +0200
Message-Id: <20210520092052.316553852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 396a66aa1172ef2b78c21651f59b40b87b2e5e1e upstream.

gcc-11 warns about mismatched prototypes here:

  arch/x86/lib/msr-smp.c:255:51: error: argument 2 of type ‘u32 *’ {aka ‘unsigned int *’} declared as a pointer [-Werror=array-parameter=]
    255 | int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
        |                                              ~~~~~^~~~
  arch/x86/include/asm/msr.h:347:50: note: previously declared as an array ‘u32[8]’ {aka ‘unsigned int[8]’}

GCC is right here - fix up the types.

[ mingo: Twiddled the changelog. ]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210322164541.912261-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/msr-smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/msr-smp.c
+++ b/arch/x86/lib/msr-smp.c
@@ -253,7 +253,7 @@ static void __wrmsr_safe_regs_on_cpu(voi
 	rv->err = wrmsr_safe_regs(rv->regs);
 }
 
-int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	int err;
 	struct msr_regs_info rv;
@@ -266,7 +266,7 @@ int rdmsr_safe_regs_on_cpu(unsigned int
 }
 EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
 
-int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	int err;
 	struct msr_regs_info rv;


