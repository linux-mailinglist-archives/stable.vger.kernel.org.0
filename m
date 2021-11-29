Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD553461E8D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351996AbhK2ShP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:37:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51684 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378760AbhK2SfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:35:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2080CE13C4;
        Mon, 29 Nov 2021 18:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CD8C53FC7;
        Mon, 29 Nov 2021 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210714;
        bh=GfFT2GMkSOnPkaL7P46tG7bDElxCKV02FEDM9qZ41Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NO64/OBFTFgRKjfwol/jUgFOnxrGH6EdoHmssRlsfoksf/nLEZLd6RtOiiCVuK0Q9
         XSL5flX0riaSteUmErr4mJp7hxmQp2V2OGu58Wxv3z3DOjeocyKThvc9b2bgCsfF7C
         fWj+t+OUjvUi/8HevbN5M7AFPKYfm0nIdpFBhzjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/121] MIPS: loongson64: fix FTLB configuration
Date:   Mon, 29 Nov 2021 19:18:42 +0100
Message-Id: <20211129181714.730118922@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 067cb3eb16141..d120201910acf 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1721,8 +1721,6 @@ static inline void decode_cpucfg(struct cpuinfo_mips *c)
 
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 {
-	decode_configs(c);
-
 	/* All Loongson processors covered here define ExcCode 16 as GSExc. */
 	c->options |= MIPS_CPU_GSEXCEX;
 
@@ -1783,6 +1781,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
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



