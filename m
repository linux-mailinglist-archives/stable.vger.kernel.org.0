Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BBC490E2D
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242928AbiAQRHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242673AbiAQRFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:05:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22158C0612DF;
        Mon, 17 Jan 2022 09:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3E8761237;
        Mon, 17 Jan 2022 17:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898D0C36AE3;
        Mon, 17 Jan 2022 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439026;
        bh=JWXNqsVU8CyrmkM1MYCCOMy09l/9ViqNHqXM/QnraDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSOpeQkd/eW3WY0SpD/9hm0yVveEyaqUwn77M4mZRK+IiQVPVZCOeo8QLlIqdMEDQ
         E8WmNvXiOAVoCs+3jrRFfiyUGJS2ePsxChAOJ/1nho+G27bTQVkJyVFGbx2iTRBOne
         HDWUXNLMeJqEcqe2rf6LWrwrapsywWqHv932q0LaHu9W18FMFko4D2+1K1dUaTMYiB
         nUC4kDUK0yYhl8nv2mgx135tNwprhSv8lm5T3y3OLBf2U2PNtKAKQQLVg8z9j0dxJB
         feZyMqOCUa+6CHnxu1i8wI8n/zpCp4/MZ3UrPsZa0DaQoCgDjc1mYhDGQoS1+7SjWO
         +3NXQzrU7j3Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, clg@kaod.org, valentin.schneider@arm.com,
        hbathini@linux.ibm.com, parth@linux.ibm.com, npiggin@gmail.com,
        robh@kernel.org, yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 09/34] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:02:59 -0500
Message-Id: <20220117170326.1471712-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
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
index 452cbf98bfd71..50aeef08aa470 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1488,10 +1488,12 @@ void start_secondary(void *unused)
 	BUG();
 }
 
+#ifdef CONFIG_PROFILING
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return 0;
 }
+#endif
 
 static void fixup_topology(void)
 {
-- 
2.34.1

