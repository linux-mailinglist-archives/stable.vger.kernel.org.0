Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC4490E41
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbiAQRIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56292 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242051AbiAQRGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A1AE61269;
        Mon, 17 Jan 2022 17:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69805C36AE7;
        Mon, 17 Jan 2022 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439170;
        bh=cfgNBCaLfspusGGx3TWNkR2/M1NK5ZI0i2GmyN/yYHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o62rGmFN3AAhbFB2TO1vGUs753h6uIV5HZA4oROL4ihehfH2/BcFMN/7sl1YOhbz/
         KdL07LbWQ0hJqnFT5pnDzIX+S2iM6nADQJN2q+3BUWDm5mQ4qWBG2sYcE0PxxRyjnx
         c8BahYzSqHJMDcdAPURYPWiIh59+OAmV8ma944jDkquk06sedJlMSNlo2XinW/rmmg
         E6/PNqsSQ9APkt48/FBtcA/6O8la+bATmE+KR2hdNim4TAjRGM2bq2BAKYs63wrrjb
         Dmv0uXVLsFP9AogTdtO/H4Dd9/kH/nPTMi+kBW08GfVx+cfklQTHFzfQXgUINDYiQH
         Vs60btbFshEPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, clg@kaod.org, hbathini@linux.ibm.com,
        parth@linux.ibm.com, npiggin@gmail.com, robh@kernel.org,
        yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 08/17] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:05:42 -0500
Message-Id: <20220117170551.1472640-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170551.1472640-1-sashal@kernel.org>
References: <20220117170551.1472640-1-sashal@kernel.org>
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
index 14adfeacfa46e..4853ac67cf21f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1070,10 +1070,12 @@ void start_secondary(void *unused)
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

