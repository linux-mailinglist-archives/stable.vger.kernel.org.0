Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2946AE946
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCGRWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCGRWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175B898E9D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8D8461506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F57CC433D2;
        Tue,  7 Mar 2023 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209451;
        bh=oBtsLCRt5HsuHdDNr7wqb4hop3WG00XamyWbbcnYOeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FW/lgDKl6lFS5pbe4q+c/nmcq0ubr2e6RHovhHEuotaO+9++CZPImFwCwE9IMSXpV
         OcXVNtSvCsk8SCvwgG6JnPgAHvZ9I+22iNYDxN7yWQnwa76P+D1dkG8P7ssbAUWfQN
         /N2amTxZjSqJTWdI5Owxtl1byw/azs3ViUlkyUpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0193/1001] s390/early: fix sclp_early_sccb variable lifetime
Date:   Tue,  7 Mar 2023 17:49:25 +0100
Message-Id: <20230307170030.271760756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 639886b71ddef085a0e7bb1f225b8ae3eda5c06f ]

Commit ada1da31ce34 ("s390/sclp: sort out physical vs
virtual pointers usage") fixed the notion of virtual
address for sclp_early_sccb pointer. However, it did
not take into account that kasan_early_init() can also
output messages and sclp_early_sccb should be adjusted
by the time kasan_early_init() is called.

Currently it is not a problem, since virtual and physical
addresses on s390 are the same. Nevertheless, should they
ever differ, this would cause an invalid pointer access.

Fixes: ada1da31ce34 ("s390/sclp: sort out physical vs virtual pointers usage")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c       | 1 -
 arch/s390/kernel/head64.S      | 1 +
 drivers/s390/char/sclp_early.c | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 6030fdd6997bc..9693c8630e73f 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -288,7 +288,6 @@ static void __init sort_amode31_extable(void)
 
 void __init startup_init(void)
 {
-	sclp_early_adjust_va();
 	reset_tod_clock();
 	check_image_bootable();
 	time_early_init();
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index d7b8b6ad574dc..3b3bf8329e6c1 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -25,6 +25,7 @@ ENTRY(startup_continue)
 	larl	%r14,init_task
 	stg	%r14,__LC_CURRENT
 	larl	%r15,init_thread_union+THREAD_SIZE-STACK_FRAME_OVERHEAD-__PT_SIZE
+	brasl	%r14,sclp_early_adjust_va	# allow sclp_early_printk
 #ifdef CONFIG_KASAN
 	brasl	%r14,kasan_early_init
 #endif
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index c1c70a161c0e2..f480d6c7fd399 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -163,7 +163,7 @@ static void __init sclp_early_console_detect(struct init_sccb *sccb)
 		sclp.has_linemode = 1;
 }
 
-void __init sclp_early_adjust_va(void)
+void __init __no_sanitize_address sclp_early_adjust_va(void)
 {
 	sclp_early_sccb = __va((unsigned long)sclp_early_sccb);
 }
-- 
2.39.2



