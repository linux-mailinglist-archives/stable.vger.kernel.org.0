Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A551491858
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbiARCqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51556 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbiARCmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:42:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C2C8B81249;
        Tue, 18 Jan 2022 02:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B922C36AE3;
        Tue, 18 Jan 2022 02:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473772;
        bh=xkO1nvKt4O3YteSpK5taGaQFmGOjDPnXJi8Tu8UR6g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAeqf7FYbaIxbud2L98+ds6hTumPq1zH2OiszCHV98Jil0pMZDUNqJq5zHWOM98sh
         6JJjh1ScOp1xJCz6IBhxKf/ZlUHuTXOVTjPkbdYDShqm10lxzaux6njor3DDyAEEMC
         BZrINsMvzBF+zAoq3e2fCX70RDWLaAAPHpv2wdxzD/dhS5TXMaVGXiR2z9K0ljLkDm
         ws2jFjx66tQlFhBIwdodbeA2Zo3bZTkj6F5WhI1F3MpqBiAAbPCeJGggfu3uJHvyVy
         HYFTa0wOJvS6jNblGkHSaDjWe0O3f2L/ZWjjlfE6io+rXD4+Za5ILg0Wn3R7dNa/or
         /sMog17VuN67Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 063/116] x86/mce: Mark mce_end() noinstr
Date:   Mon, 17 Jan 2022 21:39:14 -0500
Message-Id: <20220118024007.1950576-63-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit b4813539d37fa31fed62cdfab7bd2dd8929c5b2e ]

It is called by the #MC handler which is noinstr.

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0xbd6: call to memset() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-9-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 64d8a96a2bf1e..2a608f0819765 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1070,10 +1070,13 @@ static int mce_start(int *no_way_out)
  * Synchronize between CPUs after main scanning loop.
  * This invokes the bulk of the Monarch processing.
  */
-static int mce_end(int order)
+static noinstr int mce_end(int order)
 {
-	int ret = -1;
 	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;
+	int ret = -1;
+
+	/* Allow instrumentation around external facilities. */
+	instrumentation_begin();
 
 	if (!timeout)
 		goto reset;
@@ -1117,7 +1120,8 @@ static int mce_end(int order)
 		/*
 		 * Don't reset anything. That's done by the Monarch.
 		 */
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	/*
@@ -1132,6 +1136,10 @@ static int mce_end(int order)
 	 * Let others run again.
 	 */
 	atomic_set(&mce_executing, 0);
+
+out:
+	instrumentation_end();
+
 	return ret;
 }
 
-- 
2.34.1

