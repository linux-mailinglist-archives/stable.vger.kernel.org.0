Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78022490F35
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbiAQRQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243852AbiAQRN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:13:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8F6C0612E2;
        Mon, 17 Jan 2022 09:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19D56B8115B;
        Mon, 17 Jan 2022 17:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C349C36AEF;
        Mon, 17 Jan 2022 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439290;
        bh=4Dw/6zFwUu1pvPlMw2/pQ1gJ+iowxFDpDx957UrzjiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/BRcQSMxkr7piVrBEORq0m7HGKO9RbfLkjIoOvMkw/xh25TDZrBaRQfQFAdn26wK
         qwnA5RStHJFGsjrtLjTYqQpr8lg/rQ8BIle0z9A3KJKSGKiu6b0ZUmfuhVVHyK2rls
         NhG36ot7ET9jn7H4TXUNQTvRFwFUkCrO0XkUyWKQbnlDBK8+ENtcOrpPJs1NYzGL56
         LJjRyc1LvXf26SaB/J6GYEW+qkui1M8yXvcZ62s7JHktFhVHY3jgwQW5SceaQdBoix
         GNHLVdyjko20Hxa7qNzGsv4+PYFNyxPqoBeip4zONdxlCdUDOSeBgFaSQDRIIB2Y2p
         tKpPksQfbZDpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, valentin.schneider@arm.com, clg@kaod.org,
        hbathini@linux.ibm.com, parth@linux.ibm.com, npiggin@gmail.com,
        robh@kernel.org, yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 06/12] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:07:50 -0500
Message-Id: <20220117170757.1473318-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170757.1473318-1-sashal@kernel.org>
References: <20220117170757.1473318-1-sashal@kernel.org>
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
index ec9ec2058d2d3..19ba60ab18073 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -732,10 +732,12 @@ void start_secondary(void *unused)
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

