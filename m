Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07844461F46
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378898AbhK2Sp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380284AbhK2Sn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35549B815C9;
        Mon, 29 Nov 2021 18:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9F4C53FAD;
        Mon, 29 Nov 2021 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211207;
        bh=nFeVJENmnb1f/2Uj6fZwYFql+n9XmZelkoWzVeWVQp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8qKmAA6jNFJzRHioc1nb4ZLbIWJw/ghHIwGgIOntAoe0w1m8lcl9xsJbY/49RtyZ
         wyYkfJvOO1Ltgs+hFuXFRkUj28YplsZCark+Iy1HM53HXAI/Qv+Mf6yhT895pWZV9L
         mZgBDLd7gOk2oO8s15uXmE2Mh0I9+u7/M1cGVzOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/179] MIPS: loongson64: fix FTLB configuration
Date:   Mon, 29 Nov 2021 19:18:55 +0100
Message-Id: <20211129181723.585631679@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit 7db5e9e9e5e6c10d7d26f8df7f8fd8841cb15ee7 ]

It turns out that 'decode_configs' -> 'set_ftlb_enable' is called under
c->cputype unset, which leaves FTLB disabled on BOTH 3A2000 and 3A3000

Fix it by calling "decode_configs" after c->cputype is initialized

Fixes: da1bd29742b1 ("MIPS: Loongson64: Probe CPU features via CPUCFG")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cpu-probe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 630fcb4cb30e7..7c861e6a89529 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1734,8 +1734,6 @@ static inline void decode_cpucfg(struct cpuinfo_mips *c)
 
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 {
-	decode_configs(c);
-
 	/* All Loongson processors covered here define ExcCode 16 as GSExc. */
 	c->options |= MIPS_CPU_GSEXCEX;
 
@@ -1796,6 +1794,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		panic("Unknown Loongson Processor ID!");
 		break;
 	}
+
+	decode_configs(c);
 }
 #else
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu) { }
-- 
2.33.0



