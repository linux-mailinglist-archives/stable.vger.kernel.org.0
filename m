Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25FC38A12B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhETJ2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232025AbhETJ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35F3E613BE;
        Thu, 20 May 2021 09:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502777;
        bh=fRBEVpGFEeuQFVQALto36Js2BDnb8czXNzo5M32cks4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6c9+59KZ0a2e9LbR5/Z8QNA3n/hl7Mb9NaI07VPV6pESZpcUTzUAe2AaShrhHCIh
         /YhsHiGDnwfGIHcv7bZ3McaWBhDkWu8qT11dLbYopgTLxkUbjCxBZ1JbUeJ7qbeAu9
         W8JbOdsINzhHNgJoAWLWB8j8J+1sUCtXRY8ErgIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.10 01/47] x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
Date:   Thu, 20 May 2021 11:21:59 +0200
Message-Id: <20210520092053.608939482@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
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


