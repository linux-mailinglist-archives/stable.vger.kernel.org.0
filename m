Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8E24B451
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgHTKDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbgHTKBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:01:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CAA622BEF;
        Thu, 20 Aug 2020 10:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917710;
        bh=y6wwBtn+KP9Yd5tnD9YVIntDuu6JPXyHFIUPNYMgO3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0kXG+5Dke4M5rAmkqfDkz0pmbNb6LWG8nJuqIsl+QcHR7mzeZvTJdtKbfjUZPum8
         zHDBpqQDe4sR11jAKolCx6JFnteWqNrMa37euvGx/zGbwN5zwuwPkmusosJ+vUw2SG
         4GbpvZkaghc6jKbMEOJVqce4C9PayGNw/Ea5k1jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milton Miller <miltonm@us.ibm.com>,
        Anton Blanchard <anton@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 128/212] powerpc/vdso: Fix vdso cpu truncation
Date:   Thu, 20 Aug 2020 11:21:41 +0200
Message-Id: <20200820091608.814277295@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milton Miller <miltonm@us.ibm.com>

[ Upstream commit a9f675f950a07d5c1dbcbb97aabac56f5ed085e3 ]

The code in vdso_cpu_init that exposes the cpu and numa node to
userspace via SPRG_VDSO incorrctly masks the cpu to 12 bits. This means
that any kernel running on a box with more than 4096 threads (NR_CPUS
advertises a limit of of 8192 cpus) would expose userspace to two cpu
contexts running at the same time with the same cpu number.

Note: I'm not aware of any distro shipping a kernel with support for more
than 4096 threads today, nor of any system image that currently exceeds
4096 threads. Found via code browsing.

Fixes: 18ad51dd342a7eb09dbcd059d0b451b616d4dafc ("powerpc: Add VDSO version of getcpu")
Signed-off-by: Milton Miller <miltonm@us.ibm.com>
Signed-off-by: Anton Blanchard <anton@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200715233704.1352257-1-anton@ozlabs.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 4111d30badfad..d24aea160352b 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -704,7 +704,7 @@ int vdso_getcpu_init(void)
 	node = cpu_to_node(cpu);
 	WARN_ON_ONCE(node > 0xffff);
 
-	val = (cpu & 0xfff) | ((node & 0xffff) << 16);
+	val = (cpu & 0xffff) | ((node & 0xffff) << 16);
 	mtspr(SPRN_SPRG_VDSO_WRITE, val);
 	get_paca()->sprg_vdso = val;
 
-- 
2.25.1



