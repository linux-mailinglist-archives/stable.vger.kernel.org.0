Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E6B302AEE
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbhAYS41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbhAYS4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:56:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 327F8224D4;
        Mon, 25 Jan 2021 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600934;
        bh=K3yJFan1A1sSRkniTOUSLnAaPwPYG4eSsXyweajtcnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKz7k0dnvgwnXSr/urMl/jpIpbWOBbAGJSW+oR92EZpbBGucCFll2CyPTdgU9FDWt
         an3YKIeBW78OZb3+Kl0fWFuzWBANU2wq1O0Zabf3gSGDtjekJAEzu4SbDJereRb4o1
         lph8cRY1+ak8pTlmUFWY4NU/MYlMmP7Or28eR01Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 187/199] x86/sev: Fix nonistr violation
Date:   Mon, 25 Jan 2021 19:40:09 +0100
Message-Id: <20210125183224.072086070@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a1d5c98aac33a5a0004ecf88905dcc261c52f988 upstream.

When the compiler fails to inline, it violates nonisntr:

  vmlinux.o: warning: objtool: __sev_es_nmi_complete()+0xc7: call to sev_es_wr_ghcb_msr() leaves .noinstr.text section

Fixes: 4ca68e023b11 ("x86/sev-es: Handle NMI State")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210106144017.532902065@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/sev-es.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -225,7 +225,7 @@ static inline u64 sev_es_rd_ghcb_msr(voi
 	return __rdmsr(MSR_AMD64_SEV_ES_GHCB);
 }
 
-static inline void sev_es_wr_ghcb_msr(u64 val)
+static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 {
 	u32 low, high;
 


