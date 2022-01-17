Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E9490CCF
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiAQQ71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47364 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241241AbiAQQ7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DF33B81147;
        Mon, 17 Jan 2022 16:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7E7C36AE3;
        Mon, 17 Jan 2022 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438758;
        bh=KWoGejEVrZUfkV1DJjO87i+BhLl7v3X3Zk9ndV6PkeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5q3xyLx4uguXf0abO8/s6Ix5fXtHQ15cU0xsRkSjLzBoWyIE3qpcGYJ7dznKyEYA
         8nyQv9r34f4zcsFASoCtFDWvroTp1FxfYP43yOQmmDZnuNhKIfxJT7m0/M1fbbfqy+
         UVK6SB13PlF2W0Vq6Nn6Gu5RH6czVoPk3nYNzC5W3nDHzy1+nFZTCMLZIdOwn4c4+W
         mZ7HG4nqpPD0++Kq4zq9E+bX8SH3iL1U0x1NRdaPcl82KVOv7Y/X/y5GedW3YWiIFf
         Ld20pxq5oETlW5JYDMRdhSBhEO1jonhVs2D0tIK1L3mDsnlD/PXldsAkWUSorIygIg
         VSd4ku8c3XUWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, clg@kaod.org, parth@linux.ibm.com,
        hbathini@linux.ibm.com, npiggin@gmail.com, robh@kernel.org,
        yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.16 10/52] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 11:58:11 -0500
Message-Id: <20220117165853.1470420-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
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
index c23ee842c4c33..aee3a7119f977 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1635,10 +1635,12 @@ void start_secondary(void *unused)
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

