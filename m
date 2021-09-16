Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2765D40E2B0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243680AbhIPQlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243332AbhIPQht (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:37:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1046142A;
        Thu, 16 Sep 2021 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809350;
        bh=z1DqO8IRBjaZIL8F3r1F3PtmWISEyGlTglJpiRdy8Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA+1YSPntlp+B9MduzkKH6YQHsxdLbUTLRqlja+Jf/RKPeL42KeoMYGjjR10CqHOT
         C+ZvxkGPV08Mka67tKJCiBe4spdYMOancjow9fDVdyngXQLzz9nVwceXxhIBWgM8bB
         wA9DPD7wfB+JfnARgfjk0oP8qF4m8RzboeWVQSWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 123/380] powerpc/smp: Fix a crash while booting kvm guest with nr_cpus=2
Date:   Thu, 16 Sep 2021 17:58:00 +0200
Message-Id: <20210916155808.229133033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit 8efd249babea2fec268cff90b9f5ca723dbb7499 ]

Aneesh reported a crash with a fairly recent upstream kernel when
booting kernel whose commandline was appended with nr_cpus=2

1:mon> e
cpu 0x1: Vector: 300 (Data Access) at [c000000008a67bd0]
    pc: c00000000002557c: cpu_to_chip_id+0x3c/0x100
    lr: c000000000058380: start_secondary+0x460/0xb00
    sp: c000000008a67e70
   msr: 8000000000001033
   dar: 10
 dsisr: 80000
  current = 0xc00000000891bb00
  paca    = 0xc0000018ff981f80   irqmask: 0x03   irq_happened: 0x01
    pid   = 0, comm = swapper/1
Linux version 5.13.0-rc3-15704-ga050a6d2b7e8 (kvaneesh@ltc-boston8) (gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #433 SMP Tue May 25 02:38:49 CDT 2021
1:mon> t
[link register   ] c000000000058380 start_secondary+0x460/0xb00
[c000000008a67e70] c000000008a67eb0 (unreliable)
[c000000008a67eb0] c0000000000589d4 start_secondary+0xab4/0xb00
[c000000008a67f90] c00000000000c654 start_secondary_prolog+0x10/0x14

Current code assumes that num_possible_cpus() is always greater than
threads_per_core. However this may not be true when using nr_cpus=2 or
similar options. Handle the case where num_possible_cpus() is not an
exact multiple of  threads_per_core.

Fixes: c1e53367dab1 ("powerpc/smp: Cache CPU to chip lookup")
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Debugged-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210826100401.412519-2-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index df6b468976d5..7da1e01e2c7f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1085,7 +1085,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 
 	if (cpu_to_chip_id(boot_cpuid) != -1) {
-		int idx = num_possible_cpus() / threads_per_core;
+		int idx = DIV_ROUND_UP(num_possible_cpus(), threads_per_core);
 
 		/*
 		 * All threads of a core will all belong to the same core,
-- 
2.30.2



