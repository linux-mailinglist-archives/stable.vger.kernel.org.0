Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3738EF8E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhEXP6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235080AbhEXP5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A3BF61950;
        Mon, 24 May 2021 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871009;
        bh=8MmAe9ioIJXYEC9+vWdC7mJvZaHue8oIlnJ3m1cRlx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2Jh21tfZArMCgNAto3rVEJJ7Uc1LfRnhl/WnPZ5PITtZtHoJ8nK+JdAz2O/bjIfo
         EnfJqwLKE2xO1nT4B1PSFd1VkwEDTeiAJX/h2Ufs+AZ52r+07dIozJ+RAASMAao0Vg
         UUOjPBdgRuuDVFzu4Zmm2x6jJ5yijFc8pNgmonnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 031/127] perf/x86: Avoid touching LBR_TOS MSR for Arch LBR
Date:   Mon, 24 May 2021 17:25:48 +0200
Message-Id: <20210524152335.894137968@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

[ Upstream commit 3317c26a4b413b41364f2c4b83c778c6aba1576d ]

The Architecture LBR does not have MSR_LBR_TOS (0x000001c9).
In a guest that should support Architecture LBR, check_msr()
will be a non-related check for the architecture MSR 0x0
(IA32_P5_MC_ADDR) that is also not supported by KVM.

The failure will cause x86_pmu.lbr_nr = 0, thereby preventing
the initialization of the guest Arch LBR. Fix it by avoiding
this extraneous check in intel_pmu_init() for Arch LBR.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
[peterz: simpler still]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210430052247.3079672-1-like.xu@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c57ec8e27907..4c18e7fb58f5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5741,7 +5741,7 @@ __init int intel_pmu_init(void)
 	 * Check all LBT MSR here.
 	 * Disable LBR access if any LBR MSRs can not be accessed.
 	 */
-	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
+	if (x86_pmu.lbr_tos && !check_msr(x86_pmu.lbr_tos, 0x3UL))
 		x86_pmu.lbr_nr = 0;
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
 		if (!(check_msr(x86_pmu.lbr_from + i, 0xffffUL) &&
-- 
2.30.2



