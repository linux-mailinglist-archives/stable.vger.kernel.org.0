Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278EC6B6B1C
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 21:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCLUim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 16:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCLUil (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 16:38:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39106241CB;
        Sun, 12 Mar 2023 13:38:37 -0700 (PDT)
Date:   Sun, 12 Mar 2023 20:38:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678653515;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8phezYGkV4ZFxG7GBTMyfW74H5g3ySQBRmXlT502Xs=;
        b=d/rRk4Uk7vsF1DgIlNSMRjyFl0PdtHlENZl3UhP0e5tOJTBJyhQpH0yZUSQiq8Kc/0D6kq
        pr1B5MoDvU4cHzvXtaZPFIbrlcg2H6rfujJShlYLIh1Zh+76I1CY3X9GUrQVstlRha+ysi
        eovjkQCC/wLWqgHO/4GP+UdJIK+FoFk8rC5mGiOtifcF5cWiNrg22sjo6tWf4j5bK8J8bC
        cO8cWe+TQ78LWdOdA0FsvF30rfPYOoY7qRPZ7sS4BXkDDqQUueSndeEsE2PP8CzsS1xWP/
        /eOeoGuUTtG0lVNvML4o5v1VVkh+XFn+tf1pDgiQcmoGHLdiNhMdjDjfOJ8Q2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678653515;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8phezYGkV4ZFxG7GBTMyfW74H5g3ySQBRmXlT502Xs=;
        b=JXzPiDfYhO+5BWfNMFyUyTKUkBcUZzUPgOZIx8bgdqaPgIZ2NfEtjYXcC0CZBtAV2ZRyHM
        45tB3uoETAJL1iDg==
From:   "tip-bot2 for Yazen Ghannam" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/urgent] x86/mce: Make sure logged MCEs are processed after
 sysfs update
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230301221420.2203184-1-yazen.ghannam@amd.com>
References: <20230301221420.2203184-1-yazen.ghannam@amd.com>
MIME-Version: 1.0
Message-ID: <167865351393.5837.17719714572303479044.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/urgent branch of tip:

Commit-ID:     4783b9cb374af02d49740e00e2da19fd4ed6dec4
Gitweb:        https://git.kernel.org/tip/4783b9cb374af02d49740e00e2da19fd4ed6dec4
Author:        Yazen Ghannam <yazen.ghannam@amd.com>
AuthorDate:    Wed, 01 Mar 2023 22:14:20 
Committer:     Borislav Petkov (AMD) <bp@alien8.de>
CommitterDate: Sun, 12 Mar 2023 21:12:21 +01:00

x86/mce: Make sure logged MCEs are processed after sysfs update

A recent change introduced a flag to queue up errors found during
boot-time polling. These errors will be processed during late init once
the MCE subsystem is fully set up.

A number of sysfs updates call mce_restart() which goes through a subset
of the CPU init flow. This includes polling MCA banks and logging any
errors found. Since the same function is used as boot-time polling,
errors will be queued. However, the system is now past late init, so the
errors will remain queued until another error is found and the workqueue
is triggered.

Call mce_schedule_work() at the end of mce_restart() so that queued
errors are processed.

Fixes: 3bff147b187d ("x86/mce: Defer processing of early errors")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230301221420.2203184-1-yazen.ghannam@amd.com
---
 arch/x86/kernel/cpu/mce/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 7832a69..2eec60f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2355,6 +2355,7 @@ static void mce_restart(void)
 {
 	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
+	mce_schedule_work();
 }
 
 /* Toggle features for corrected errors */
