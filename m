Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8869F12EBF1
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgABWNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbgABWNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B4C21D7D;
        Thu,  2 Jan 2020 22:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003222;
        bh=Fra8aZasCrfdjr2SqA6CMzh9DAlocZ+YwGMIgLze7jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaDohJchHauPpddrFOebyQ4AXMViyr72caJvi1Dd2QlRqoCa6BQAr8iGvTk8kr/MC
         fpYF5eipu/xJO2Ev84T6K56kTuBHcM24c6jstkFjkUMZodk8oqNrmFV+6ciyIdYYiQ
         8VSxJGrfA00mKDZa7I6CwgvQKRuo214vaX0c3AwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/191] powerpc/book3s/mm: Update Oops message to print the correct translation in use
Date:   Thu,  2 Jan 2020 23:05:53 +0100
Message-Id: <20200102215837.517222128@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit d7e02f7b7991dbe14a2acfb0e53d675cd149001c ]

Avoids confusion when printing Oops message like below

 Faulting instruction address: 0xc00000000008bdb4
 Oops: Kernel access of bad area, sig: 11 [#1]
 LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV

This was because we never clear the MMU_FTR_HPTE_TABLE feature flag
even if we run with radix translation. It was discussed that we should
look at this feature flag as an indication of the capability to run
hash translation and we should not clear the flag even if we run in
radix translation. All the code paths check for radix_enabled() check and
if found true consider we are running with radix translation. Follow the
same sequence for finding the MMU translation string to be used in Oops
message.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190711145814.17970-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 82f43535e686..014ff0701f24 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -250,15 +250,22 @@ static void oops_end(unsigned long flags, struct pt_regs *regs,
 }
 NOKPROBE_SYMBOL(oops_end);
 
+static char *get_mmu_str(void)
+{
+	if (early_radix_enabled())
+		return " MMU=Radix";
+	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		return " MMU=Hash";
+	return "";
+}
+
 static int __die(const char *str, struct pt_regs *regs, long err)
 {
 	printk("Oops: %s, sig: %ld [#%d]\n", str, err, ++die_counter);
 
-	printk("%s PAGE_SIZE=%luK%s%s%s%s%s%s%s %s\n",
+	printk("%s PAGE_SIZE=%luK%s%s%s%s%s%s %s\n",
 	       IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? "LE" : "BE",
-	       PAGE_SIZE / 1024,
-	       early_radix_enabled() ? " MMU=Radix" : "",
-	       early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ? " MMU=Hash" : "",
+	       PAGE_SIZE / 1024, get_mmu_str(),
 	       IS_ENABLED(CONFIG_PREEMPT) ? " PREEMPT" : "",
 	       IS_ENABLED(CONFIG_SMP) ? " SMP" : "",
 	       IS_ENABLED(CONFIG_SMP) ? (" NR_CPUS=" __stringify(NR_CPUS)) : "",
-- 
2.20.1



