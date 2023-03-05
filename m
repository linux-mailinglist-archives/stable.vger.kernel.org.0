Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6896AB0D3
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCEOFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 09:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCEOFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 09:05:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8750218A82;
        Sun,  5 Mar 2023 06:05:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5E3B80A7C;
        Sun,  5 Mar 2023 13:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECDFC433EF;
        Sun,  5 Mar 2023 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024454;
        bh=sVH2vsIk/sno9MnNFLS6rc3jeKS1wSCfh1TDNxfxzF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ix+oxMiorDrLWyihh3pjEVPCZfs9ieTOulOBrT/NUbtnyCTq9CG+If3m5XmzkNBJ9
         Hrnn5J6qRvLS5nseIT6l1mSvvZrCmeFOHirG/C+XMfd0BXsnaZryjiiuXypR6p+3W5
         jresMAyvT6IbVXqBeySH/4KZHiv/bRsohLDLUQYnul5NfQ63MvR1QcaXInHAhhGgb1
         ElnsZx6SlB9/yCNd6/JtLQ5K2ei44ljamOXzxEr3C5Yv+vT/354W/3HVqjzp5A8ppt
         yU8GKiy1t+zNreJ3MuNSYg/aVIeDXYZ3nBdJfl6ledRoVECoNz5kyqN93r4kDcTdc5
         31O8wE8MTEVgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rohan McLure <rmclure@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, alexandre.belloni@bootlin.com,
        heying24@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 5/9] powerpc/kcsan: Exclude udelay to prevent recursive instrumentation
Date:   Sun,  5 Mar 2023 08:53:55 -0500
Message-Id: <20230305135359.1793830-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135359.1793830-1-sashal@kernel.org>
References: <20230305135359.1793830-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohan McLure <rmclure@linux.ibm.com>

[ Upstream commit 2a7ce82dc46c591c9244057d89a6591c9639b9b9 ]

In order for KCSAN to increase its likelihood of observing a data race,
it sets a watchpoint on memory accesses and stalls, allowing for
detection of conflicting accesses by other kernel threads or interrupts.

Stalls are implemented by injecting a call to udelay in instrumented code.
To prevent recursive instrumentation, exclude udelay from being instrumented.

Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230206021801.105268-3-rmclure@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 934d8ae66cc63..4406d7a89558b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -450,7 +450,7 @@ void vtime_flush(struct task_struct *tsk)
 #define calc_cputime_factors()
 #endif
 
-void __delay(unsigned long loops)
+void __no_kcsan __delay(unsigned long loops)
 {
 	unsigned long start;
 
@@ -471,7 +471,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-void udelay(unsigned long usecs)
+void __no_kcsan udelay(unsigned long usecs)
 {
 	__delay(tb_ticks_per_usec * usecs);
 }
-- 
2.39.2

