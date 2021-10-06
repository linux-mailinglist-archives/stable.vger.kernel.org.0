Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188A442447D
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 19:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhJFRk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 13:40:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59560 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238578AbhJFRkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 13:40:55 -0400
Date:   Wed, 06 Oct 2021 17:39:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633541941;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TgbniOj4/RkP6KBozA7mOArvhZEi2s9nIHvsU9v8wuk=;
        b=GymvlRHL2ZRWfWyA6bM8vzzthXIMjWQHT4cA0BcxSLMu7Ez3fGTU4qXll4bLu6N1XWs+1b
        enuetE2czvvaJyGSF+4teh9QiF2vvd0cgr5RL12QZbfMGqhqDI0lHt9Vh+xuY2Nx5XnuEk
        3XaaEdz9Eb4P/6Hl+RwqwkjO5emeiw+zGuMVTHzRBsdApsILiRIlDa4tTQIUXnGEljFIgY
        BF1HeZJ/GRSQCPv4xBXqQL2BUaKgNBxqrfv1sZIw2YaIu8TccSlXGbz+rXQwyny8gzIzS4
        0J9kfECSV+V1rnI9eu0sKg1SfasOdySsa3KsLGkcxhTcfCOEeRKP0fJzVdXpSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633541941;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TgbniOj4/RkP6KBozA7mOArvhZEi2s9nIHvsU9v8wuk=;
        b=hu63ktBrstS4A8bqvwz4Piz07VERdIKAmCeij04rjJtlqpR3I0+sBp/kdgG9I98esaRgcd
        unRGShBvWN8VZzBg==
From:   "tip-bot2 for James Morse" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Free the ctrlval arrays when
 domain_setup_mon_state() fails
Cc:     James Morse <james.morse@arm.com>, Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210917165958.28313-1-james.morse@arm.com>
References: <20210917165958.28313-1-james.morse@arm.com>
MIME-Version: 1.0
Message-ID: <163354194100.25758.3202711458810699953.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     64e87d4bd3201bf8a4685083ee4daf5c0d001452
Gitweb:        https://git.kernel.org/tip/64e87d4bd3201bf8a4685083ee4daf5c0d001452
Author:        James Morse <james.morse@arm.com>
AuthorDate:    Fri, 17 Sep 2021 16:59:58 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 18:45:21 +02:00

x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails

domain_add_cpu() is called whenever a CPU is brought online. The
earlier call to domain_setup_ctrlval() allocates the control value
arrays.

If domain_setup_mon_state() fails, the control value arrays are not
freed.

Add the missing kfree() calls.

Fixes: 1bd2a63b4f0de ("x86/intel_rdt/mba_sc: Add initialization support")
Fixes: edf6fa1c4a951 ("x86/intel_rdt/cqm: Add RMID (Resource monitoring ID) management")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210917165958.28313-1-james.morse@arm.com
---
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 4b8813b..b5de5a6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -532,6 +532,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(hw_dom->ctrl_val);
+		kfree(hw_dom->mbps_val);
 		kfree(d);
 		return;
 	}
