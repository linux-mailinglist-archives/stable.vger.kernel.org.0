Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1799633BAAC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhCOOKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhCOOEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1EC64EF1;
        Mon, 15 Mar 2021 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817079;
        bh=0CceF+b+LmF5KHpXmBA8tZP9h2CE5iqe//MjyHGSF9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8DHOYj3OVOmmouKlVU9+OCtBMqjCrGAxbhgUSsM86w+66ADLGLboWdLgBZTOuYnI
         /Iyc98kRAdQA+k5PkM0OG798xvw05vd+vo8OtecOd3P9Re15j5fGBpEanc6DKmK1Ju
         blG98wg0Vl4ToiIlHgRyX2I97jqlA6Cu5S92DEkk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.11 289/306] x86/sev-es: Correctly track IRQ states in runtime #VC handler
Date:   Mon, 15 Mar 2021 14:55:52 +0100
Message-Id: <20210315135517.456626134@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joerg Roedel <jroedel@suse.de>

commit 62441a1fb53263bda349b6e5997c3cc5c120d89e upstream.

Call irqentry_nmi_enter()/irqentry_nmi_exit() in the #VC handler to
correctly track the IRQ state during its execution.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Reported-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-5-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -1258,13 +1258,12 @@ static __always_inline bool on_vc_fallba
 DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 {
 	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
+	irqentry_state_t irq_state;
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
 	enum es_result result;
 	struct ghcb *ghcb;
 
-	lockdep_assert_irqs_disabled();
-
 	/*
 	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
 	 */
@@ -1273,6 +1272,8 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_co
 		return;
 	}
 
+	irq_state = irqentry_nmi_enter(regs);
+	lockdep_assert_irqs_disabled();
 	instrumentation_begin();
 
 	/*
@@ -1335,6 +1336,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_co
 
 out:
 	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
 
 	return;
 


