Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D262648E607
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbiANIWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239947AbiANIV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3341C06174E;
        Fri, 14 Jan 2022 00:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4637961E36;
        Fri, 14 Jan 2022 08:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C51BC36AE9;
        Fri, 14 Jan 2022 08:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148480;
        bh=zVUjk13QbjHnnbgJiUT99EkoDLe1UTJi0lqaOp0nuOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0W2OPTofZHqY7Egv3AiNTEWm1vl/GM2i8joZ3P/eDM89BhKE/fNa99TzWN0BN4gc
         7ZjN3tPCuHvYaXReqDbRmB1lc8jZAmSFPQn3DQw3RwzJzWSRlskmaRj+HrlOeOA/2j
         7cYfFQBiEEM+iDBfTbwxRBOdWQxPyPlhg3ysC5Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 30/41] x86/mce: Remove noinstr annotation from mce_setup()
Date:   Fri, 14 Jan 2022 09:16:30 +0100
Message-Id: <20220114081546.160146929@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 487d654db3edacc31dee86b10258cc740640fad8 upstream.

Instead, sandwitch around the call which is done in noinstr context and
mark the caller - mce_gather_info() - as noinstr.

Also, document what the whole instrumentation strategy with #MC is going
to be in the future and where it all is supposed to be going to.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-5-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -130,7 +130,7 @@ static void (*quirk_no_way_out)(int bank
 BLOCKING_NOTIFIER_HEAD(x86_mce_decoder_chain);
 
 /* Do initial initialization of a struct mce */
-noinstr void mce_setup(struct mce *m)
+void mce_setup(struct mce *m)
 {
 	memset(m, 0, sizeof(struct mce));
 	m->cpu = m->extcpu = smp_processor_id();
@@ -479,9 +479,15 @@ static noinstr void mce_wrmsrl(u32 msr,
  * check into our "mce" struct so that we can use it later to assess
  * the severity of the problem as we read per-bank specific details.
  */
-static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
+static noinstr void mce_gather_info(struct mce *m, struct pt_regs *regs)
 {
+	/*
+	 * Enable instrumentation around mce_setup() which calls external
+	 * facilities.
+	 */
+	instrumentation_begin();
 	mce_setup(m);
+	instrumentation_end();
 
 	m->mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	if (regs) {
@@ -1327,11 +1333,11 @@ static void queue_task_work(struct mce *
 }
 
 /*
- * The actual machine check handler. This only handles real
- * exceptions when something got corrupted coming in through int 18.
+ * The actual machine check handler. This only handles real exceptions when
+ * something got corrupted coming in through int 18.
  *
- * This is executed in NMI context not subject to normal locking rules. This
- * implies that most kernel services cannot be safely used. Don't even
+ * This is executed in #MC context not subject to normal locking rules.
+ * This implies that most kernel services cannot be safely used. Don't even
  * think about putting a printk in there!
  *
  * On Intel systems this is entered on all CPUs in parallel through
@@ -1343,6 +1349,14 @@ static void queue_task_work(struct mce *
  * issues: if the machine check was due to a failure of the memory
  * backing the user stack, tracing that reads the user stack will cause
  * potentially infinite recursion.
+ *
+ * Currently, the #MC handler calls out to a number of external facilities
+ * and, therefore, allows instrumentation around them. The optimal thing to
+ * have would be to do the absolutely minimal work required in #MC context
+ * and have instrumentation disabled only around that. Further processing can
+ * then happen in process context where instrumentation is allowed. Achieving
+ * that requires careful auditing and modifications. Until then, the code
+ * allows instrumentation temporarily, where required. *
  */
 noinstr void do_machine_check(struct pt_regs *regs)
 {


