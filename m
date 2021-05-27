Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844DD39322E
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhE0PPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236990AbhE0PPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D476561358;
        Thu, 27 May 2021 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128427;
        bh=vbYEyiu46r8f7LglZL8phVdZXdj3Uoh7h2G8G9S/Dik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMqNjOC+z8lz7uceVAx1u/mzhbQB5lmiV9SUlxxv42Lj97CjBbdagqVvc6/RTC0Sk
         KgYPBEn31CPHqqOfnURoZxKv3jtXyRnCFhXREBuxnWoYYg73RWq3Mc1z87dr34tVnY
         FABVnTmYbOScyjV0y0e7NsVNhLE0A7G0t0BykroY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.12 5/7] context_tracking: Move guest exit vtime accounting to separate helpers
Date:   Thu, 27 May 2021 17:13:06 +0200
Message-Id: <20210527151139.413722748@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
References: <20210527151139.241267495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 88d8220bbf06dd8045b2ac4be1046290eaa7773a upstream.

Provide separate vtime accounting functions for guest exit instead of
open coding the logic within the context tracking code.  This will allow
KVM x86 to handle vtime accounting slightly differently when using
tick-based accounting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210505002735.1684165-3-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/context_tracking.h |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -137,15 +137,20 @@ static __always_inline void context_trac
 		__context_tracking_exit(CONTEXT_GUEST);
 }
 
-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void vtime_account_guest_exit(void)
 {
-	context_tracking_guest_exit();
-
-	instrumentation_begin();
 	if (vtime_accounting_enabled_this_cpu())
 		vtime_guest_exit(current);
 	else
 		current->flags &= ~PF_VCPU;
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_tracking_guest_exit();
+
+	instrumentation_begin();
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
@@ -166,12 +171,17 @@ static __always_inline void guest_enter_
 
 static __always_inline void context_tracking_guest_exit(void) { }
 
+static __always_inline void vtime_account_guest_exit(void)
+{
+	vtime_account_kernel(current);
+	current->flags &= ~PF_VCPU;
+}
+
 static __always_inline void guest_exit_irqoff(void)
 {
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
-	vtime_account_kernel(current);
-	current->flags &= ~PF_VCPU;
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */


