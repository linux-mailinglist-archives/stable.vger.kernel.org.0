Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0A315BB9
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 01:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhBJA4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 19:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbhBJAyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 19:54:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E715DC06174A;
        Tue,  9 Feb 2021 16:53:28 -0800 (PST)
Message-Id: <20210210002512.106502464@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612918406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=FxwveKckE0tqKxgLn3EeM+hWUlhTWbik83gdx5hPZqk=;
        b=vf1m5pgyzXTcJyVlDUobt6WHl/1m9ZgVvKKZNd0IP/x3YcZMAg0ApAwbxyLuupWDls6Tj8
        kTkeKsY8XcO/jGBbJRZpf/kH872wFZNqhKMXjUq3V6aPzIBjjqxAsRzW0VdiJFSlclww1H
        yY4JM5L9l93Hngb7kxrF0n1yB/JZtu80/54E4Vmuv2sMggtp1dOuF89oHNEWY/8q0j9iI2
        ezjZnLCSRI+5fm5nSzv94/HSHiKGoloCvfWQvz+70O9fOVnU2qEsNVabGxEzXK9H78imEt
        mplcrcTinbRL7N9JAIZvI5nSdhUGeqKGlx9CZoXsZmVIFT0z5v9I99t58Oz0xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612918406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=FxwveKckE0tqKxgLn3EeM+hWUlhTWbik83gdx5hPZqk=;
        b=x5iZVVmFeFDsmqSBdBMklqowiTv+OFDqK+BpBfZNGJN9+R5E1VuQykYfdnTUtiWYrbxw+i
        AqA1C6M1m/cj0RDw==
Date:   Wed, 10 Feb 2021 00:40:42 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Rich Felker <dalias@libc.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Subject: [patch V2 01/13] x86/entry: Fix instrumentation annotation
References: <20210209234041.127454039@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Embracing a callout into instrumentation_begin() / instrumentation_begin()
does not really make sense. Make the latter instrumentation_end().

Fixes: 2f6474e4636b ("x86/entry: Switch XEN/PV hypercall entry to IDTENTRY")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
 arch/x86/entry/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -270,7 +270,7 @@ static void __xen_pv_evtchn_do_upcall(vo
 
 	instrumentation_begin();
 	run_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
-	instrumentation_begin();
+	instrumentation_end();
 
 	set_irq_regs(old_regs);
 


