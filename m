Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA730490EEF
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242558AbiAQRNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242753AbiAQRLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:11:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF274C08C5D7;
        Mon, 17 Jan 2022 09:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E1E2611D9;
        Mon, 17 Jan 2022 17:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972D4C36AE7;
        Mon, 17 Jan 2022 17:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439216;
        bh=FRms4rYVIvN6iZnmgg6BThnJYfNtMZYW0Z7PMF+z5K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVqVfnEJYnT/lamr1venE5VTY5GBfglcrg8afJdy1/XOurWUfbx18pHdc7YCX8+/u
         uVAWVlbRI/1wER41p2ABXbkiC57LWxQZ+KCL+JdPIn/2MOfIgSTb9C0qkfgXX/noyq
         GzkFEfgpN8HWKaAPxfCMGQ8qNFVOvBjZX1Po4QILPNTHNWHWEL5S2wadsTHXpWX3Lc
         WukjGroCR0d7iRPhUliNAP6FZtCthnpCCfJSxuTHV3Lei1abuYde2JOCcRVXZYhxjx
         kJxpuodUjo6TYFRVnVxe4+oP+0JSPemG6O8UTJP0UCmfQzBTvIVcK8XYrK4eAvkD+B
         hebHrUaVcqKXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, hbathini@linux.ibm.com,
        valentin.schneider@arm.com, clg@kaod.org, parth@linux.ibm.com,
        npiggin@gmail.com, robh@kernel.org, yukuai3@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 08/16] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:06:30 -0500
Message-Id: <20220117170638.1472900-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170638.1472900-1-sashal@kernel.org>
References: <20220117170638.1472900-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a4ac0d249a5db80e79d573db9e4ad29354b643a8 ]

setup_profiling_timer() is only needed when CONFIG_PROFILING is enabled.

Fixes the following W=1 warning when CONFIG_PROFILING=n:
  linux/arch/powerpc/kernel/smp.c:1638:5: error: no previous prototype for ‘setup_profiling_timer’

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211124093254.1054750-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 7c7aa7c98ba31..cf25b95ceee13 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1009,10 +1009,12 @@ void start_secondary(void *unused)
 	BUG();
 }
 
+#ifdef CONFIG_PROFILING
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
-- 
2.34.1

