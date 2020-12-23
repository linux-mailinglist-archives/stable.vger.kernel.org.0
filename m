Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2882E14F1
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgLWCqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:46:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgLWCWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F577229C5;
        Wed, 23 Dec 2020 02:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690138;
        bh=PZkgTS62SlZ9oyrHhbnmA49Yyl+63TAaiWIp/xvU5dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV+BAtdOQI21R1SRiMfAmZvnZdp31QEfxJ9yrP5LFR6UdyoqIpFjLCu66optHGXyZ
         burR5vi6MwiHkKaNfo5z5d9Vmtnbyh7LdR39N6TmJIIzwT5lupMVshdZjkoAg/zVA1
         bxkloqoVtMxjrQwTqYv+ns71H13A9YVy/zVA7QsNfha4QYHcpGKjcNTwmufVxgyuAm
         xaRjbxc9N4HxNZZrMYgAzECruR067fzp/wptMIvbc2Pk5m9jwGK85s3r1zuztKDJk1
         9Rj4ufI5GaoonOPKK8xMWVVSVnJBTuiB3/BgNqTdqLVwGsuYXftq69r41jl0ffKU0J
         vIBFGY3Ik8KdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinyang He <hejinyang@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 60/87] MIPS: KASLR: Avoid endless loop in sync_icache if synci_step is zero
Date:   Tue, 22 Dec 2020 21:20:36 -0500
Message-Id: <20201223022103.2792705-60-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit c0aac3a51cb6364bed367ee3e1a96ed414f386b4 ]

Most platforms do not need to do synci instruction operations when
synci_step is 0. But for example, the synci implementation on Loongson64
platform has some changes. On the one hand, it ensures that the memory
access instructions have been completed. On the other hand, it guarantees
that all prefetch instructions need to be fetched again. And its address
information is useless. Thus, only one synci operation is required when
synci_step is 0 on Loongson64 platform. I guess that some other platforms
have similar implementations on synci, so add judgment conditions in
`while` to ensure that at least all platforms perform synci operations
once. For those platforms that do not need synci, they just do one more
operation similar to nop.

Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/relocate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index cbf4cc0b0b6cf..5639c2d5cf0e4 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -64,7 +64,7 @@ static void __init sync_icache(void *kbase, unsigned long kernel_length)
 			: "r" (kbase));
 
 		kbase += step;
-	} while (kbase < kend);
+	} while (step && kbase < kend);
 
 	/* Completion barrier */
 	__sync();
-- 
2.27.0

