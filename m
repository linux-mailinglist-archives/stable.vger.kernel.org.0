Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272CB38A0C4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhETJZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhETJZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6142761244;
        Thu, 20 May 2021 09:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502675;
        bh=rxvVo1mbwg1haJLsBX/KuJjKQzseHj9hXv/3V3jLG9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iotP1r2MvpU2qsfpqhKxLVy8J7mTIWi+eDhkw2+8HrXh91f6dXC+4pIYNNvaNudcV
         O8AJDJ/8fAGqaiqL4XqL0uAqCzCD50IgPjt6toBFjG//bIzA12GsicBHjGxEoquLzu
         q2511gKMmzblwnQKUWhwt411gCUSDan9vVS6W/iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.12 01/45] x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
Date:   Thu, 20 May 2021 11:21:49 +0200
Message-Id: <20210520092053.564432736@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
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
@@ -252,7 +252,7 @@ static void __wrmsr_safe_regs_on_cpu(voi
 	rv->err = wrmsr_safe_regs(rv->regs);
 }
 
-int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	int err;
 	struct msr_regs_info rv;
@@ -265,7 +265,7 @@ int rdmsr_safe_regs_on_cpu(unsigned int
 }
 EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
 
-int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	int err;
 	struct msr_regs_info rv;


