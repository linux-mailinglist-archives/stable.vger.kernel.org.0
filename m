Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5553538A648
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhETKZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45948 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbhETKXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 06:23:49 -0400
Date:   Thu, 20 May 2021 10:22:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621506139;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZagrcgFZectxiy1/3uvyt0uDezedS074rlpmvxtY4DQ=;
        b=3xIo7UEBmxMtMQMX9TaUhsqixau3Gxed2cR9o93+FsABTxjKWV4D0fTQTHgZ9upt52Pw2w
        7HmrLfYBh8AjHLrbYtG1ARiutxSyHqIfIdsaYyTah5eq5Ir7mgCubkuiGoTI23mC7Rr01G
        afFURpA1zi2PAIJli/YG9vzyvyqW0FV4cDOCUdkdKz7tJlyuw0HvVsQooNZBaU4ggYEGkA
        CTbUPnvkCad9rf1YOOkDkAP3qecdL5nO3YMmPDfCV+sv4TWyaYvo7J+9G/rvEAhT7y1Pol
        ewJWOYgj4I7lJ6B/oDFrfGAt/GVt5X7QRElDeCBrKWUPqIPfIxnAknEl8s3OfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621506139;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZagrcgFZectxiy1/3uvyt0uDezedS074rlpmvxtY4DQ=;
        b=StpVGhK6ppJzC7yhwHmDjzySzTZE3rh3j+Tw995QL7ZfjrJJ6jvjjwjmSLTUnZ690wTf1A
        q/ztyKV5FzuhmcDg==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Forward page-faults which happen during
 emulation
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v5.10+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210519135251.30093-3-joro@8bytes.org>
References: <20210519135251.30093-3-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <162150613865.29796.2348311879608249315.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     c25bbdb564060adaad5c3a8a10765c13487ba6a3
Gitweb:        https://git.kernel.org/tip/c25bbdb564060adaad5c3a8a10765c13487ba6a3
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 19 May 2021 15:52:45 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 19 May 2021 17:13:04 +02:00

x86/sev-es: Forward page-faults which happen during emulation

When emulating guest instructions for MMIO or IOIO accesses, the #VC
handler might get a page-fault and will not be able to complete. Forward
the page-fault in this case to the correct handler instead of killing
the machine.

Fixes: 0786138c78e7 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210519135251.30093-3-joro@8bytes.org
---
 arch/x86/kernel/sev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 82bced8..1f428f4 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1270,6 +1270,10 @@ static __always_inline void vc_forward_exception(struct es_em_ctxt *ctxt)
 	case X86_TRAP_UD:
 		exc_invalid_op(ctxt->regs);
 		break;
+	case X86_TRAP_PF:
+		write_cr2(ctxt->fi.cr2);
+		exc_page_fault(ctxt->regs, error_code);
+		break;
 	case X86_TRAP_AC:
 		exc_alignment_check(ctxt->regs, error_code);
 		break;
