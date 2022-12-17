Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB81D64F592
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLQAKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLQAKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:10:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B7973325;
        Fri, 16 Dec 2022 16:10:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77F2A622CB;
        Sat, 17 Dec 2022 00:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64860C433F0;
        Sat, 17 Dec 2022 00:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235802;
        bh=cbQ8SyZFREV8vFF9bRS676PytjnbqBvZbE1b8YYjSf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGVT1lR1BSEPI+IT1MXvZWsKzQD/5/VCMxoJHsoTgvmhcTi+6upkcUaJjVyTJtaQk
         Zw9293ccCV/DqhhsCUMLb3OMNLShFzGyD1edtp9e1w7+xnDbOFSdUxuUSyJFg/Phti
         HDFvkNiBO0KLsZLG2DUrTDjy2/5Ipcv4ntzatt5yABulm6xHzFYrq5qNTlrdSyyo+i
         tNVNcJP3f4NzROaYWrcMamzh4CeL8ysnBYHZRn6Po9B2sVOEVPcWdYlli1lr2983oN
         XFIqJtAxWsRA0qNUKIkF+702zM2MrLmaaamBdT/b0oXgj4zh5OSXihcsLnG2bqM+E9
         ViMl1a741De0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaurav Kohli <gauravkohli@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 5/9] x86/hyperv: Remove unregister syscore call from Hyper-V cleanup
Date:   Fri, 16 Dec 2022 19:09:32 -0500
Message-Id: <20221217000937.41115-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217000937.41115-1-sashal@kernel.org>
References: <20221217000937.41115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Kohli <gauravkohli@linux.microsoft.com>

[ Upstream commit 32c97d980e2eef25465d453f2956a9ca68926a3c ]

Hyper-V cleanup code comes under panic path where preemption and irq
is already disabled. So calling of unregister_syscore_ops might schedule
out the thread even for the case where mutex lock is free.
hyperv_cleanup
	unregister_syscore_ops
			mutex_lock(&syscore_ops_lock)
				might_sleep
Here might_sleep might schedule out this thread, where voluntary preemption
config is on and this thread will never comes back. And also this was added
earlier to maintain the symmetry which is not required as this can comes
during crash shutdown path only.

To prevent the same, removing unregister_syscore_ops function call.

Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1669443291-2575-1-git-send-email-gauravkohli@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index a269049a43ce..85863b9c9e68 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -535,8 +535,6 @@ void hyperv_cleanup(void)
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 	union hv_reference_tsc_msr tsc_msr;
 
-	unregister_syscore_ops(&hv_syscore_ops);
-
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
-- 
2.35.1

