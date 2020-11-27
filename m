Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02002C69F3
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgK0Qn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 11:43:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35400 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbgK0Qn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 11:43:56 -0500
Date:   Fri, 27 Nov 2020 16:43:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606495433;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nv5gpi5HupILoHk+ot9Wn43htm6UC76V9jpG2KLKJEE=;
        b=180Bn1+L/FnoJaxMgIXFqxT9+x38cbsnfP5fDnYq7Cj5SBTWsJ7nUcJs1OkcYd0s0GKbR7
        l/1bVNXT51Fbwp/6ZZ2knfLyu7mZ2iHWgQL2uuiO3rh+plvVWPdCsOkyoMx5hbtz2Kxe/u
        3O/WLOS+EtHh2gRePoHWKEoM98Wxl999NUqF1jYrVxUqDINNeO0q83AcrXTptpxfvuILWy
        prP6yIusuZxWCdb9ROYJ+Kt/Pj8MTZDZcRIegNxPtZzDCAbKvdyXi+dtCNSDhNB9gq+DPr
        Wp9jCyaQePy6FmhCUaAHWOM7cVWmRlz47n3epLqkxqp8U1eAbs6cD9kAbkGPew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606495433;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nv5gpi5HupILoHk+ot9Wn43htm6UC76V9jpG2KLKJEE=;
        b=Sv6ayQ4aGumcqDVd7CqDEmYLQiJSSYkKdw41Z2Tg9wZkMwzHTUc4Ilo8RZhwuCmPFsJc2c
        3P17tdsnXnm/ffBA==
From:   "tip-bot2 for Gabriele Paoloni" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mce: Do not overwrite no_way_out if mce_end() fails
Cc:     Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201127161819.3106432-2-gabriele.paoloni@intel.com>
References: <20201127161819.3106432-2-gabriele.paoloni@intel.com>
MIME-Version: 1.0
Message-ID: <160649543297.3364.4572741027949627240.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     25bc65d8ddfc17cc1d7a45bd48e9bdc0e729ced3
Gitweb:        https://git.kernel.org/tip/25bc65d8ddfc17cc1d7a45bd48e9bdc0e729ced3
Author:        Gabriele Paoloni <gabriele.paoloni@intel.com>
AuthorDate:    Fri, 27 Nov 2020 16:18:15 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 27 Nov 2020 17:38:36 +01:00

x86/mce: Do not overwrite no_way_out if mce_end() fails

Currently, if mce_end() fails, no_way_out - the variable denoting
whether the machine can recover from this MCE - is determined by whether
the worst severity that was found across the MCA banks associated with
the current CPU, is of panic severity.

However, at this point no_way_out could have been already set by
mca_start() after looking at all severities of all CPUs that entered the
MCE handler. If mce_end() fails, check first if no_way_out is already
set and, if so, stick to it, otherwise use the local worst value.

 [ bp: Massage. ]

Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201127161819.3106432-2-gabriele.paoloni@intel.com
---
 arch/x86/kernel/cpu/mce/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4102b86..32b7099 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1384,8 +1384,10 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	 * When there's any problem use only local no_way_out state.
 	 */
 	if (!lmce) {
-		if (mce_end(order) < 0)
-			no_way_out = worst >= MCE_PANIC_SEVERITY;
+		if (mce_end(order) < 0) {
+			if (!no_way_out)
+				no_way_out = worst >= MCE_PANIC_SEVERITY;
+		}
 	} else {
 		/*
 		 * If there was a fatal machine check we should have
