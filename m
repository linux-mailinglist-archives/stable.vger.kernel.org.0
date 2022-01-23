Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED44F49756A
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 20:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiAWT6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 14:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiAWT6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 14:58:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EF3C06173B;
        Sun, 23 Jan 2022 11:58:03 -0800 (PST)
Date:   Sun, 23 Jan 2022 19:58:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642967882;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qy935+STtZcetGgcKtrF9n+5wmvO4Pa6KwGNf6TOHXo=;
        b=Y+MrMdV4DpvFEvKcU7JrfaPN75oWgiAEJiIybO4GO/6TH5HgPkCkQ9amzFvBjoyMqNYOUm
        OkHRdcKwwGXKnQW9p5R8vpmx1bUbASc0nIzOR0Rtt41c5KqpH0lR8o6nHIoDfAyBDxRzj3
        qcMMvu0LHpR7/I1kkJ3B6nlUD3Tt3YMLr++/TFOmTIl7i0NivLLi1tD7wAKd0UzVcmQYdg
        YizTWDQsi0Z5Ijvxoznn8tTexJLoU0FiHtWAhoZIV6DfI7FqtjSGKQ0sXe10Pq/Qap7r4g
        3huZjogxE650upGEz9LdEo+dYGGn/e7YeoQ8PDJ9PZibl6J+JwZItvWx/QYIWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642967882;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qy935+STtZcetGgcKtrF9n+5wmvO4Pa6KwGNf6TOHXo=;
        b=adUF8WnmpwGycJD7emJeUT3u73BpNRAweZiZoqgel4Ga8fv56gvug+wrslzaZzt9yS+JtS
        zzxR9MF1OmS6jUDg==
From:   "tip-bot2 for Yazen Ghannam" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/MCE/AMD: Allow thresholding interface updates
 after init
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220117161328.19148-1-yazen.ghannam@amd.com>
References: <20220117161328.19148-1-yazen.ghannam@amd.com>
MIME-Version: 1.0
Message-ID: <164296788110.16921.15198014097333837407.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     1f52b0aba6fd37653416375cb8a1ca673acf8d5f
Gitweb:        https://git.kernel.org/tip/1f52b0aba6fd37653416375cb8a1ca673acf8d5f
Author:        Yazen Ghannam <yazen.ghannam@amd.com>
AuthorDate:    Mon, 17 Jan 2022 16:13:28 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sun, 23 Jan 2022 20:50:18 +01:00

x86/MCE/AMD: Allow thresholding interface updates after init

Changes to the AMD Thresholding sysfs code prevents sysfs writes from
updating the underlying registers once CPU init is completed, i.e.
"threshold_banks" is set.

Allow the registers to be updated if the thresholding interface is
already initialized or if in the init path. Use the "set_lvt_off" value
to indicate if running in the init path, since this value is only set
during init.

Fixes: a037f3ca0ea0 ("x86/mce/amd: Make threshold bank setting hotplug robust")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220117161328.19148-1-yazen.ghannam@amd.com
---
 arch/x86/kernel/cpu/mce/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index a1e2f41..9f4b508 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -423,7 +423,7 @@ static void threshold_restart_bank(void *_tr)
 	u32 hi, lo;
 
 	/* sysfs write might race against an offline operation */
-	if (this_cpu_read(threshold_banks))
+	if (!this_cpu_read(threshold_banks) && !tr->set_lvt_off)
 		return;
 
 	rdmsr(tr->b->address, lo, hi);
