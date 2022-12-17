Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67D664F5B8
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiLQAMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiLQALY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:11:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEDB40800;
        Fri, 16 Dec 2022 16:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3E8622C9;
        Sat, 17 Dec 2022 00:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BF3C433EF;
        Sat, 17 Dec 2022 00:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235831;
        bh=y9bwSUuc+lA1U3NC4hPJWbpqyHp4QqmMJF7rGIqbdi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7N7zvdbu6GvkIOJ1Eeyn+JUuUV0XcWHBnoxJygoc0z1Z/JZ3MCjbb6dejfP0ctl2
         yuYIyiD/KdX+00xXXDGnyXGf4CEI+dx0eW8J45zcwd3ck3EfStyIlVXugrzqp/KJ/B
         xLFPXz0pyvOQyM0locaK0FFFCd4O54Ip01VkUXYZy/pzH601WmxyWcXkvbB40e07EU
         p5mLQqFBY5+kjkYuYDSifXIGaSFoZh6hhyo+b5zqVetSP4Nqxezlye2F7uu4s/OPGq
         4jw0m5W8ktEigltY8NKDOm7lN950+auPw2IIc8EXxF2FCDMvxNOqBFEz9zUGLeeEBY
         sicaDthF//H3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaurav Kohli <gauravkohli@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 5/8] x86/hyperv: Remove unregister syscore call from Hyper-V cleanup
Date:   Fri, 16 Dec 2022 19:10:09 -0500
Message-Id: <20221217001013.41239-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001013.41239-1-sashal@kernel.org>
References: <20221217001013.41239-1-sashal@kernel.org>
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
index a0165df3c4d8..d03561b2fffe 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -536,8 +536,6 @@ void hyperv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 
-	unregister_syscore_ops(&hv_syscore_ops);
-
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
-- 
2.35.1

