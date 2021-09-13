Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB594093A2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344121AbhIMO0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346315AbhIMOYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F4EF61B3E;
        Mon, 13 Sep 2021 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540884;
        bh=URB8kG7j7JXbGwk4FRLk6yfl4EOoaAnhuT74pNPHgGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hb7QHehT6GOf44fWBN31rTQKhbYriSmdefXSzJyX5PmyELMAI2Xb63ZsTxuqpMxLj
         2YCsLKc3FRq+IyhJP1QFQKd8sAvDu1tA5RdguKzs0I9oH1IBAT4tFCiBsbPqLPgHvx
         TiZxg2OrIl44CwwSHdNHuPVn1tPGi8zSBtasJXEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumanth Kamatala <skamatala@juniper.net>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 075/334] x86/mce: Defer processing of early errors
Date:   Mon, 13 Sep 2021 15:12:09 +0200
Message-Id: <20210913131115.934577590@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

[ Upstream commit 3bff147b187d5dfccfca1ee231b0761a89f1eff5 ]

When a fatal machine check results in a system reset, Linux does not
clear the error(s) from machine check bank(s) - hardware preserves the
machine check banks across a warm reset.

During initialization of the kernel after the reboot, Linux reads, logs,
and clears all machine check banks.

But there is a problem. In:

  5de97c9f6d85 ("x86/mce: Factor out and deprecate the /dev/mcelog driver")

the call to mce_register_decode_chain() moved later in the boot
sequence. This means that /dev/mcelog doesn't see those early error
logs.

This was partially fixed by:

  cd9c57cad3fe ("x86/MCE: Dump MCE to dmesg if no consumers")

which made sure that the logs were not lost completely by printing
to the console. But parsing console logs is error prone. Users of
/dev/mcelog should expect to find any early errors logged to standard
places.

Add a new flag MCP_QUEUE_LOG to machine_check_poll() to be used in early
machine check initialization to indicate that any errors found should
just be queued to genpool. When mcheck_late_init() is called it will
call mce_schedule_work() to actually log and flush any errors queued in
the genpool.

 [ Based on an original patch, commit message by and completely
   productized by Tony Luck. ]

Fixes: 5de97c9f6d85 ("x86/mce: Factor out and deprecate the /dev/mcelog driver")
Reported-by: Sumanth Kamatala <skamatala@juniper.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210824003129.GA1642753@agluck-desk2.amr.corp.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/mce.h     |  1 +
 arch/x86/kernel/cpu/mce/core.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 0607ec4f5091..da9321548f6f 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -265,6 +265,7 @@ enum mcp_flags {
 	MCP_TIMESTAMP	= BIT(0),	/* log time stamp */
 	MCP_UC		= BIT(1),	/* log uncorrected errors */
 	MCP_DONTLOG	= BIT(2),	/* only clear, don't log */
+	MCP_QUEUE_LOG	= BIT(3),	/* only queue to genpool */
 };
 bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 22791aadc085..8cb7816d03b4 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -817,7 +817,10 @@ log_it:
 		if (mca_cfg.dont_log_ce && !mce_usable_address(&m))
 			goto clear_it;
 
-		mce_log(&m);
+		if (flags & MCP_QUEUE_LOG)
+			mce_gen_pool_add(&m);
+		else
+			mce_log(&m);
 
 clear_it:
 		/*
@@ -1639,10 +1642,12 @@ static void __mcheck_cpu_init_generic(void)
 		m_fl = MCP_DONTLOG;
 
 	/*
-	 * Log the machine checks left over from the previous reset.
+	 * Log the machine checks left over from the previous reset. Log them
+	 * only, do not start processing them. That will happen in mcheck_late_init()
+	 * when all consumers have been registered on the notifier chain.
 	 */
 	bitmap_fill(all_banks, MAX_NR_BANKS);
-	machine_check_poll(MCP_UC | m_fl, &all_banks);
+	machine_check_poll(MCP_UC | MCP_QUEUE_LOG | m_fl, &all_banks);
 
 	cr4_set_bits(X86_CR4_MCE);
 
-- 
2.30.2



