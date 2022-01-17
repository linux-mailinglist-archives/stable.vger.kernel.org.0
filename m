Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE4490D7B
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiAQRDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241561AbiAQRB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16946C061760;
        Mon, 17 Jan 2022 09:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BF061230;
        Mon, 17 Jan 2022 17:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE869C36AEC;
        Mon, 17 Jan 2022 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438909;
        bh=ZKIO0EI8etdhFdJgw05cNmBcT16ZGNTA2eUjGktLPHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+vJHy2zHOfxkmI49EcYGXUHgqi/dhx9fLsAKLEbiCvLo3XFsC4AbuG8xDIzxvcRA
         gAiO77F4uHAbZy7j8NpFE/LTY1r79PihHyK/xrdC0hOOhbR70sKVMp2rKghXd2KcGV
         oDx76qMBBRXZMWF+ujpI6xzRa0RmfFWMu84DgAnNoNrkkjSrSOaJm63Cls3VJFW4DG
         pWcAdaguuFrf4Hlv/yLpYGRwD7fiKJgziWJboy7nfRV0JpbxWxyi81OI6J8P0R/y9f
         nkbAqAlD8nxyCeNb01Ud6MCoP1g2PsISdPsoI/sNT6cQcnAtgyFVqptOZnYFSjiXBm
         uu/62VDbpSAHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, parth@linux.ibm.com, clg@kaod.org,
        hbathini@linux.ibm.com, npiggin@gmail.com, robh@kernel.org,
        yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 09/44] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:00:52 -0500
Message-Id: <20220117170127.1471115-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index 605bab448f847..c7ef0739c8640 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1640,10 +1640,12 @@ void start_secondary(void *unused)
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

