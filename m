Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A4C2ED229
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbhAGObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbhAGObG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:31:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9E0A2311E;
        Thu,  7 Jan 2021 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029826;
        bh=m6Zb5YQ5Hhd7139LiL9Nv6hkAB3nBC+B7/Fl6e/0BCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQB7JiiuKhrs8ClLKVRVgi5kl/0QjWKpY6dNfvKEKobp7W4TD7WEJke7ftKM9ShQv
         6IBvwhjbzpFuHmlZ34R8lqre+TYKM9iQSbPWbSVqBatbnx1FSihu7bUkwKiqAKpcZP
         ZuGI6KnJtFvEf/cQdgFhVtiQmU2RddS/VzYb3ajA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 01/29] x86/entry/64: Add instruction suffix
Date:   Thu,  7 Jan 2021 15:31:16 +0100
Message-Id: <20210107143053.145776189@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

commit a368d7fd2a3c6babb852fe974018dd97916bcd3b upstream.

Omitting suffixes from instructions in AT&T mode is bad practice when
operand size cannot be determined by the assembler from register
operands, and is likely going to be warned about by upstream gas in the
future (mine does already). Add the single missing suffix here.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/5A93F96902000078001ABAC8@prv-mh.provo.novell.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -55,7 +55,7 @@ END(native_usergs_sysret64)
 
 .macro TRACE_IRQS_IRETQ
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bt	$9, EFLAGS(%rsp)		/* interrupts off? */
+	btl	$9, EFLAGS(%rsp)		/* interrupts off? */
 	jnc	1f
 	TRACE_IRQS_ON
 1:


