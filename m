Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5243289C3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhCASFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239234AbhCAR7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:59:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C1C665081;
        Mon,  1 Mar 2021 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619755;
        bh=wRGM3/BjI/nJA3+UZwz2VPq1wZJq4Wi5x7SBqp9iHcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds8PMcL+lFN15zHV76CVuRa1yDuIFMCG+XFoqj4imA6YjiYAhXqZpplV1JyuujMoQ
         BBAMGjU2Tn/U2Zw2Oyn39LMZ048n4+rf4z0YNC/jx2ySi86nDy34oRkyRMaEqRLUJL
         k06gUNA+N6y0LZoukqPISo1dHt6ZA2Smxx4nQvZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 570/663] x86/entry: Fix instrumentation annotation
Date:   Mon,  1 Mar 2021 17:13:38 +0100
Message-Id: <20210301161210.070497598@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 15f720aabe71a5662c4198b22532d95bbeec80ef upstream.

Embracing a callout into instrumentation_begin() / instrumentation_begin()
does not really make sense. Make the latter instrumentation_end().

Fixes: 2f6474e4636b ("x86/entry: Switch XEN/PV hypercall entry to IDTENTRY")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210210002512.106502464@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -304,7 +304,7 @@ __visible noinstr void xen_pv_evtchn_do_
 
 	instrumentation_begin();
 	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
-	instrumentation_begin();
+	instrumentation_end();
 
 	set_irq_regs(old_regs);
 


