Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3066C897
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjAPQky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjAPQkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:40:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0031736B0E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94EED61049
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA8EC433D2;
        Mon, 16 Jan 2023 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886520;
        bh=4qeNsLanRH8vu+10g2r/Nt6z3LyDMhuw1UxE117f+yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXWagy6ZpuXonO5hmEElHtJcjlFH3z8vACEQxEdHlNvL1Nj7PULQ40ZRbdcddfNFf
         rHjDLwISO+Z7Hu3jEdotX9J/kyAsJVz4ww0XinToAPBV4TkVZqqd7lSELEhAdg7e46
         mEi/O2PGMzFiYSx60nm27K2ubgT0zHVtJR6NvrbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Lynch <nathanl@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 462/658] powerpc/rtas: avoid scheduling in rtas_os_term()
Date:   Mon, 16 Jan 2023 16:49:10 +0100
Message-Id: <20230116154930.636174888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 6c606e57eecc37d6b36d732b1ff7e55b7dc32dd4 ]

It's unsafe to use rtas_busy_delay() to handle a busy status from
the ibm,os-term RTAS function in rtas_os_term():

Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
BUG: sleeping function called from invalid context at arch/powerpc/kernel/rtas.c:618
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
preempt_count: 2, expected: 0
CPU: 7 PID: 1 Comm: swapper/0 Tainted: G      D            6.0.0-rc5-02182-gf8553a572277-dirty #9
Call Trace:
[c000000007b8f000] [c000000001337110] dump_stack_lvl+0xb4/0x110 (unreliable)
[c000000007b8f040] [c0000000002440e4] __might_resched+0x394/0x3c0
[c000000007b8f0e0] [c00000000004f680] rtas_busy_delay+0x120/0x1b0
[c000000007b8f100] [c000000000052d04] rtas_os_term+0xb8/0xf4
[c000000007b8f180] [c0000000001150fc] pseries_panic+0x50/0x68
[c000000007b8f1f0] [c000000000036354] ppc_panic_platform_handler+0x34/0x50
[c000000007b8f210] [c0000000002303c4] notifier_call_chain+0xd4/0x1c0
[c000000007b8f2b0] [c0000000002306cc] atomic_notifier_call_chain+0xac/0x1c0
[c000000007b8f2f0] [c0000000001d62b8] panic+0x228/0x4d0
[c000000007b8f390] [c0000000001e573c] do_exit+0x140c/0x1420
[c000000007b8f480] [c0000000001e586c] make_task_dead+0xdc/0x200

Use rtas_busy_delay_time() instead, which signals without side effects
whether to attempt the ibm,os-term RTAS call again.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221118150751.469393-5-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 8ec69ea81fb4..139377f37b74 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -731,10 +731,15 @@ void rtas_os_term(char *str)
 
 	snprintf(rtas_os_term_buf, 2048, "OS panic: %s", str);
 
+	/*
+	 * Keep calling as long as RTAS returns a "try again" status,
+	 * but don't use rtas_busy_delay(), which potentially
+	 * schedules.
+	 */
 	do {
 		status = rtas_call(ibm_os_term_token, 1, 1, NULL,
 				   __pa(rtas_os_term_buf));
-	} while (rtas_busy_delay(status));
+	} while (rtas_busy_delay_time(status));
 
 	if (status != 0)
 		printk(KERN_EMERG "ibm,os-term call failed %d\n", status);
-- 
2.35.1



