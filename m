Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD011B6B7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbfLKPNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbfLKPNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 085112467D;
        Wed, 11 Dec 2019 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077187;
        bh=0NJl+G0gRnpc5W8l1a+wryP6gFApkuRFbEz/02P74os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFvspwD9hPeBah6SVCrSfs4tK3FEsFHZRKMRySHnbV//fl2p+xwa62Yl2Ylh3XKKa
         1w9PbDLlOoMarUZW5mN/5p9dbH7i+JwRFE1/gavW7SfQrTM4lDumx1cZL96B+ka4qe
         3/A9lt7lbofCtvSCg+XsfQePLM0RIAcoFe+wOWcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 071/134] powerpc/book3s/mm: Update Oops message to print the correct translation in use
Date:   Wed, 11 Dec 2019 10:10:47 -0500
Message-Id: <20191211151150.19073-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

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
index 82f43535e6867..014ff0701f245 100644
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

