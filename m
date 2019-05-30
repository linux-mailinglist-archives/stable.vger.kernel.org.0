Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2777F2F04C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbfE3ECl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbfE3DSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:01 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966F624758;
        Thu, 30 May 2019 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186280;
        bh=ERNI1iVJSN9+IwiNgJ0s5j82Eq9zXDtHaM3CaEsCXmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbFrZJtEz3hnTI60fxpzZQCyuwy1M94lx2Kn7iEhSxdXJ0WyJm0rbWFtE2q5Pyovg
         +ikeO5rTWJIw92wHfrJsq3xjMGs5QR9W/fDPBhxOcrMaxG5owZ5/Qd9n9M+SkKdNMV
         py/epuTAllz01HdKXXZi2ahiCpDzwdg1rI9rmZpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 231/276] x86/mce: Fix machine_check_poll() tests for error types
Date:   Wed, 29 May 2019 20:06:29 -0700
Message-Id: <20190530030539.579589348@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f19501aa07f18268ab14f458b51c1c6b7f72a134 ]

There has been a lurking "TBD" in the machine check poll routine ever
since it was first split out from the machine check handler. The
potential issue is that the poll routine may have just begun a read from
the STATUS register in a machine check bank when the hardware logs an
error in that bank and signals a machine check.

That race used to be pretty small back when machine checks were
broadcast, but the addition of local machine check means that the poll
code could continue running and clear the error from the bank before the
local machine check handler on another CPU gets around to reading it.

Fix the code to be sure to only process errors that need to be processed
in the poll code, leaving other logged errors alone for the machine
check handler to find and process.

 [ bp: Massage a bit and flip the "== 0" check to the usual !(..) test. ]

Fixes: b79109c3bbcf ("x86, mce: separate correct machine check poller and fatal exception handler")
Fixes: ed7290d0ee8f ("x86, mce: implement new status bits")
Reported-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>
Link: https://lkml.kernel.org/r/20190312170938.GA23035@agluck-desk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 44 +++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f9e7096b1804d..45bd926359f62 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -711,19 +711,49 @@ bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 		barrier();
 		m.status = mce_rdmsrl(msr_ops.status(i));
+
+		/* If this entry is not valid, ignore it */
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
 		/*
-		 * Uncorrected or signalled events are handled by the exception
-		 * handler when it is enabled, so don't process those here.
-		 *
-		 * TBD do the same check for MCI_STATUS_EN here?
+		 * If we are logging everything (at CPU online) or this
+		 * is a corrected error, then we must log it.
 		 */
-		if (!(flags & MCP_UC) &&
-		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
-			continue;
+		if ((flags & MCP_UC) || !(m.status & MCI_STATUS_UC))
+			goto log_it;
+
+		/*
+		 * Newer Intel systems that support software error
+		 * recovery need to make additional checks. Other
+		 * CPUs should skip over uncorrected errors, but log
+		 * everything else.
+		 */
+		if (!mca_cfg.ser) {
+			if (m.status & MCI_STATUS_UC)
+				continue;
+			goto log_it;
+		}
+
+		/* Log "not enabled" (speculative) errors */
+		if (!(m.status & MCI_STATUS_EN))
+			goto log_it;
+
+		/*
+		 * Log UCNA (SDM: 15.6.3 "UCR Error Classification")
+		 * UC == 1 && PCC == 0 && S == 0
+		 */
+		if (!(m.status & MCI_STATUS_PCC) && !(m.status & MCI_STATUS_S))
+			goto log_it;
+
+		/*
+		 * Skip anything else. Presumption is that our read of this
+		 * bank is racing with a machine check. Leave the log alone
+		 * for do_machine_check() to deal with it.
+		 */
+		continue;
 
+log_it:
 		error_seen = true;
 
 		mce_read_aux(&m, i);
-- 
2.20.1



