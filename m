Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112D238A7DC
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbhETKn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235872AbhETKlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:41:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F57613DD;
        Thu, 20 May 2021 09:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504563;
        bh=dmII0+BxKvSBZlr/F7aSI3o7YaafqRk3nKRuiKUXudo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tsm4g6/ddUvB6vfj12THzUgootCXErD4K9CdX9Zl58smjK0yX7pKE8z1kjmC9ISD9
         Y8Vf1FGg5NxMpOM+Ad4XbuTMssJgpEw6hi4t4d29Q8ztHt8pyhnIMV9a/YIJwulppW
         2C93Vxzute51Hi4dyJfB6DoODNZbDoU3nUWpUL+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 302/323] x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
Date:   Thu, 20 May 2021 11:23:14 +0200
Message-Id: <20210520092130.587062558@linuxfoundation.org>
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
@@ -240,7 +240,7 @@ static void __wrmsr_safe_regs_on_cpu(voi
 	rv->err = wrmsr_safe_regs(rv->regs);
 }
 
-int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	int err;
 	struct msr_regs_info rv;
@@ -253,7 +253,7 @@ int rdmsr_safe_regs_on_cpu(unsigned int
 }
 EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
 
-int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	int err;
 	struct msr_regs_info rv;


