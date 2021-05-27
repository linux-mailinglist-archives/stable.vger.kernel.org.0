Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72C4393211
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbhE0PPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhE0PO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAEDB613AF;
        Thu, 27 May 2021 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128403;
        bh=KMSKd3WhdCgZbyK8rMaWSOKsaZ3WKoE3YsUvgz2CXvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wibaJj0p2Fu6/6S32jJ1GQT/ZrKxlfgemLVzEzWTcw9Ii2RsI5b6RT9y9kWDZJcu4
         hEgEAMdfxPTClBB8wZn9bHN2NvdNKkXfC4NCUsobxyAyTU8xbQPGlVL+UczgPog7nV
         F6DtR/fbFy3zD5bbSYLDdaCYbQsyt/lsnq46R8b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 4/9] context_tracking: Move guest exit context tracking to separate helpers
Date:   Thu, 27 May 2021 17:12:56 +0200
Message-Id: <20210527151139.380074305@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
References: <20210527151139.242182390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 866a6dadbb027b2955a7ae00bab9705d382def12 upstream.

Provide separate context tracking helpers for guest exit, the standalone
helpers will be called separately by KVM x86 in later patches to fix
tick-based accounting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210505002735.1684165-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/context_tracking.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -129,10 +129,15 @@ static __always_inline void guest_enter_
 	}
 }
 
-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void context_tracking_guest_exit(void)
 {
 	if (context_tracking_enabled())
 		__context_tracking_exit(CONTEXT_GUEST);
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	if (vtime_accounting_enabled_this_cpu())
@@ -157,6 +162,8 @@ static __always_inline void guest_enter_
 	instrumentation_end();
 }
 
+static __always_inline void context_tracking_guest_exit(void) { }
+
 static __always_inline void guest_exit_irqoff(void)
 {
 	instrumentation_begin();


