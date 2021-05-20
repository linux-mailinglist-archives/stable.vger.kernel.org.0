Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5B638A649
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhETKZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45954 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236368AbhETKXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 06:23:50 -0400
Date:   Thu, 20 May 2021 10:22:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621506139;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BseoDTvKoUMT+QJFQEGGjbZApSjVZjrQkoWva0z5bQ=;
        b=eFsPWOfSQUU47ulF99G37c+vdWJdstdIyxAnwHsfnrohdl80csl4m31BrptqvzrpJf2aaW
        TjCov1FRzsIdmUc6gFwfZ2gFU+RRBVQ4Zmcl0XLp7NYR/9aSO1mz2J9ItMey7AfVB9rGw1
        l4MkguT6wQG7i7Bp4FTuOaL+RvevIIS2oPfsrTIkkrrk9GUDAxQ+p3xawPzH96LTUAF4h0
        oDyGFjoqpvtqICMT00WQRSXe9yMAyVJvW4DCAgZZaNaO0SmyhtYe7MZj5KvSp2L4qkahA4
        6HXSiJ9XjN7dooWuQ8XGwBr9UkXRmZ/c2P9Ck6dOCHGMrKRAXqyXMovrlfVEAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621506139;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BseoDTvKoUMT+QJFQEGGjbZApSjVZjrQkoWva0z5bQ=;
        b=PYXj3vRIocApDQ/qvsjVf7MiNaDfUCn71Y9SRHCibnYExes5i43yus6gcZYfjC8NNlNbXH
        /RZSPemxF3tyX6Aw==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Don't return NULL from sev_es_get_ghcb()
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v5.10+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210519135251.30093-2-joro@8bytes.org>
References: <20210519135251.30093-2-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <162150613911.29796.9924367580414039528.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b250f2f7792d15bcde98e0456781e2835556d5fa
Gitweb:        https://git.kernel.org/tip/b250f2f7792d15bcde98e0456781e2835556d5fa
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 19 May 2021 15:52:44 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 19 May 2021 17:05:13 +02:00

x86/sev-es: Don't return NULL from sev_es_get_ghcb()

sev_es_get_ghcb() is called from several places but only one of them
checks the return value. The reaction to returning NULL is always the
same: calling panic() and kill the machine.

Instead of adding checks to all call sites, move the panic() into the
function itself so that it will no longer return NULL.

Fixes: 0786138c78e7 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210519135251.30093-2-joro@8bytes.org
---
 arch/x86/kernel/sev.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 4fa111b..82bced8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -203,8 +203,18 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	if (unlikely(data->ghcb_active)) {
 		/* GHCB is already in use - save its contents */
 
-		if (unlikely(data->backup_ghcb_active))
-			return NULL;
+		if (unlikely(data->backup_ghcb_active)) {
+			/*
+			 * Backup-GHCB is also already in use. There is no way
+			 * to continue here so just kill the machine. To make
+			 * panic() work, mark GHCBs inactive so that messages
+			 * can be printed out.
+			 */
+			data->ghcb_active        = false;
+			data->backup_ghcb_active = false;
+
+			panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
+		}
 
 		/* Mark backup_ghcb active before writing to it */
 		data->backup_ghcb_active = true;
@@ -1289,7 +1299,6 @@ static __always_inline bool on_vc_fallback_stack(struct pt_regs *regs)
  */
 DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 {
-	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	irqentry_state_t irq_state;
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -1315,16 +1324,6 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	 */
 
 	ghcb = sev_es_get_ghcb(&state);
-	if (!ghcb) {
-		/*
-		 * Mark GHCBs inactive so that panic() is able to print the
-		 * message.
-		 */
-		data->ghcb_active        = false;
-		data->backup_ghcb_active = false;
-
-		panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
-	}
 
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);
