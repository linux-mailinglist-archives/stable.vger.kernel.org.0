Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4550374089
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhEEQfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234274AbhEEQdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29446141D;
        Wed,  5 May 2021 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232348;
        bh=9ZPI8c8ZgyNTASDUo0CAywJ/citlMl5b9hVSu6rXPjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjSgiI+52cSssSqMSJSCjb/C27sNDh+md5QJk5XZlLIdF+b1L51a990ciX5uQQScr
         QjxzXlOcJvg5c4Z8aewD3Us/6UEv4yh4ZPJh3cS1apmNM5VRcM7YG6LXluhzhN8OtI
         R267GvVZWkcC4XhIRJoyx9DTiruS8ou7VY1YqSBkpfPVdVRsz6N9i6afEdOd2syzwb
         6klUBeHPYY1lZHXyEkNd+01Zgxt2oNuGN5kahsCk/a4gp2u7HXG8TwsqidZJxAlTXq
         QBq+PIvKNrkj16DboEC/FdiI3sxVJRYrUbgEaFZzPCWpUtPm23fXV95pftjlsoW2Rk
         aSJrMPbVOttEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 046/116] MIPS: Loongson64: Use _CACHE_UNCACHED instead of _CACHE_UNCACHED_ACCELERATED
Date:   Wed,  5 May 2021 12:30:14 -0400
Message-Id: <20210505163125.3460440-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 5e65c52ec716af6e8f51dacdaeb4a4d872249af1 ]

Loongson64 processors have a writecombine issue that maybe failed to
write back framebuffer used with ATI Radeon or AMD GPU at times, after
commit 8a08e50cee66 ("drm: Permit video-buffers writecombine mapping
for MIPS"), there exists some errors such as blurred screen and lockup,
and so on.

[   60.958721] radeon 0000:03:00.0: ring 0 stalled for more than 10079msec
[   60.965315] radeon 0000:03:00.0: GPU lockup (current fence id 0x0000000000000112 last fence id 0x000000000000011d on ring 0)
[   60.976525] radeon 0000:03:00.0: ring 3 stalled for more than 10086msec
[   60.983156] radeon 0000:03:00.0: GPU lockup (current fence id 0x0000000000000374 last fence id 0x00000000000003a8 on ring 3)

As discussed earlier [1], it might be better to disable writecombine
on the CPU detection side because the root cause is unknown now.

Actually, this patch is a temporary solution to just make it work well,
it is not a proper and final solution, I hope someone will have a better
solution to fix this issue in the future.

[1] https://lore.kernel.org/patchwork/patch/1285542/

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cpu-probe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index b71892064f27..0ef240adefb5 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1752,7 +1752,6 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 			set_isa(c, MIPS_CPU_ISA_M64R2);
 			break;
 		}
-		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT |
 				MIPS_ASE_LOONGSON_EXT2);
 		break;
@@ -1782,7 +1781,6 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		 * register, we correct it here.
 		 */
 		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
-		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
 		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
@@ -1793,7 +1791,6 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		set_elf_platform(cpu, "loongson3a");
 		set_isa(c, MIPS_CPU_ISA_M64R2);
 		decode_cpucfg(c);
-		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		break;
 	default:
 		panic("Unknown Loongson Processor ID!");
-- 
2.30.2

