Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057CE13E3EA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbgAPRCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388408AbgAPRCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4B802087E;
        Thu, 16 Jan 2020 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194155;
        bh=ulldtO/RFNmOoEzUWRdK1DRt06HF+hBHLHkpTjhoxSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBbnXdsELDhGLcaFlEPclgoT2RjmL2F4vDxKNCvwVwoOKbpNHhINg07CdPlCFC4ig
         rP9p6WO2bJ9ugS5f4dtXv3AYbsuLjH/Fif4Xh8ScZSwWWSatK/NvSEEtT3zs1pcIms
         LWoEPHV/+MI8CRdbzXt45kb9W4WYYqPHCjKKGvhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        Andyt Lutomirski <luto@kernel.org>,
        dave.hansen@linux.intel.com, peterz@infradead.org, bp@alien8.de,
        hpa@zytor.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 238/671] x86/mm: Remove unused variable 'cpu'
Date:   Thu, 16 Jan 2020 11:52:27 -0500
Message-Id: <20200116165940.10720-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 3609e31bc8dc03b701390f79c74fc7fe92b95039 ]

The commit a2055abe9c67 ("x86/mm: Pass flush_tlb_info to
flush_tlb_others() etc") removed the unnecessary cpu parameter from
uv_flush_tlb_others() but left an unused variable.

arch/x86/mm/tlb.c: In function 'native_flush_tlb_others':
arch/x86/mm/tlb.c:688:16: warning: variable 'cpu' set but not used
[-Wunused-but-set-variable]
   unsigned int cpu;
                ^~~

Fixes: a2055abe9c67 ("x86/mm: Pass flush_tlb_info to flush_tlb_others() etc")
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Andyt Lutomirski <luto@kernel.org>
Cc: dave.hansen@linux.intel.com
Cc: peterz@infradead.org
Cc: bp@alien8.de
Cc: hpa@zytor.com
Link: https://lkml.kernel.org/r/20190228220155.88124-1-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/tlb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a6836ab0fcc7..b72296bd04a2 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -664,9 +664,6 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 		 * that UV should be updated so that smp_call_function_many(),
 		 * etc, are optimal on UV.
 		 */
-		unsigned int cpu;
-
-		cpu = smp_processor_id();
 		cpumask = uv_flush_tlb_others(cpumask, info);
 		if (cpumask)
 			smp_call_function_many(cpumask, flush_tlb_func_remote,
-- 
2.20.1

