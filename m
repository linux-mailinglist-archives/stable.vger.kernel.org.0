Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458B92ED1E7
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbhAGOTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbhAGOR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53A223118;
        Thu,  7 Jan 2021 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028973;
        bh=f+gKTL+Xv0xQDRRdSSznorA6RLOU2x2O4AiXRoVeL6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsHlngxjzpNDRZyO3yw/RJXYMXwFVkuQq6D4YlHR311TXgzYt0s63IrCYGA/WfMna
         1jCTe1Oz3F+VvRbSMDB4TM+dIphV8zLQ8b1njDWsdCUeyMH8dv9xsRjkM8r86va1GS
         Oj3vIK/84XzR0q+4I4W+W7eNnKy46XnhqXGu4iEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 01/32] x86/entry/64: Add instruction suffix
Date:   Thu,  7 Jan 2021 15:16:21 +0100
Message-Id: <20210107140827.938155331@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
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
@@ -58,7 +58,7 @@ ENDPROC(native_usergs_sysret64)
 
 .macro TRACE_IRQS_IRETQ
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bt	$9, EFLAGS(%rsp)		/* interrupts off? */
+	btl	$9, EFLAGS(%rsp)		/* interrupts off? */
 	jnc	1f
 	TRACE_IRQS_ON
 1:


