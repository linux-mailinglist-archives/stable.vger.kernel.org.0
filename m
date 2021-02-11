Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539D03182BC
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 01:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhBKAvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 19:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhBKAvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 19:51:14 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD3DC06178C;
        Wed, 10 Feb 2021 16:50:28 -0800 (PST)
Date:   Thu, 11 Feb 2021 00:50:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613004627;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pX+YaPAnnOVy3bv73++XGwEpy7ufnfN5Bx2KrTGv/HY=;
        b=F5S9N+P7sd5aD+IpPASsvyjhkDO7TOqLv4tLOsGmMqcAsOUmoRTDRWDJOvT9J9Uk+GBePE
        d/7tlDrcsaU4sIkZEFIE4ElbsvsYgyia6ppAI5HdEw6yw41qcWG4qk8A1Yu4SXdGfdwB4I
        YVn6s/Or389Eai9x49F98BOGsaYvRtvhBj/iTcYq4up5N+B38EJgbn87ttrArqPshCdAs6
        U6eVibZQQVOo/MkAt2q0cYRNq8IFfb4FhlTPcUQJYh2AMyAdIZ/E9K8ZbcjJsq5mmXFjA/
        ZDPVukBvHN5WA7h7fBJZDtneBBvdaRERj9BYi8/GDuBuv+FeaGNKl87gIpz2OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613004627;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pX+YaPAnnOVy3bv73++XGwEpy7ufnfN5Bx2KrTGv/HY=;
        b=81nddm/KQnK3aWbINgFR34oxryELKSoE23eDWV4isWZz1ccH2ycfBwq/+QF/Z5C/wcoDfb
        ikqlnc0TciK744Dw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/entry] x86/entry: Fix instrumentation annotation
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210210002512.106502464@linutronix.de>
References: <20210210002512.106502464@linutronix.de>
MIME-Version: 1.0
Message-ID: <161300462686.23325.5366837009836887341.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/entry branch of tip:

Commit-ID:     15f720aabe71a5662c4198b22532d95bbeec80ef
Gitweb:        https://git.kernel.org/tip/15f720aabe71a5662c4198b22532d95bbeec80ef
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 10 Feb 2021 00:40:42 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 10 Feb 2021 23:34:13 +01:00

x86/entry: Fix instrumentation annotation

Embracing a callout into instrumentation_begin() / instrumentation_begin()
does not really make sense. Make the latter instrumentation_end().

Fixes: 2f6474e4636b ("x86/entry: Switch XEN/PV hypercall entry to IDTENTRY")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210210002512.106502464@linutronix.de

---
 arch/x86/entry/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 18d8f17..c4efffb 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -266,7 +266,7 @@ __visible noinstr void xen_pv_evtchn_do_upcall(struct pt_regs *regs)
 
 	instrumentation_begin();
 	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
-	instrumentation_begin();
+	instrumentation_end();
 
 	set_irq_regs(old_regs);
 
