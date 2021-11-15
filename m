Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87274524F2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbhKPBqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237282AbhKOSVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CB3163407;
        Mon, 15 Nov 2021 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998767;
        bh=cX9jUs9U6sWEecgWN4aN2C/sPor38mcS6tCtsyRAD7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCKIBw852hL6SzXgmllk9FKSK9+3JluWobr29Gq93/NZHXOonQNhwfvNFCq02HPB2
         WYRe8/nb0hqw9i/fubE78WouLt9IMPVMZe6YEQmHOKtqWUN6DtR9XW9TmLG/0Zx9SZ
         iViJmYddbXAKznuPh8Dc56i26L182Wrzys0mr2AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 054/849] x86/irq: Ensure PI wakeup handler is unregistered before module unload
Date:   Mon, 15 Nov 2021 17:52:17 +0100
Message-Id: <20211115165421.845618881@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 6ff53f6a438f72998f56e82e76694a1df9d1ea2c upstream.

Add a synchronize_rcu() after clearing the posted interrupt wakeup handler
to ensure all readers, i.e. in-flight IRQ handlers, see the new handler
before returning to the caller.  If the caller is an exiting module and
is unregistering its handler, failure to wait could result in the IRQ
handler jumping into an unloaded module.

The registration path doesn't require synchronization, as it's the
caller's responsibility to not generate interrupts it cares about until
after its handler is registered.

Fixes: f6b3c72c2366 ("x86/irq: Define a global vector for VT-d Posted-Interrupts")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009001107.3936588-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -291,8 +291,10 @@ void kvm_set_posted_intr_wakeup_handler(
 {
 	if (handler)
 		kvm_posted_intr_wakeup_handler = handler;
-	else
+	else {
 		kvm_posted_intr_wakeup_handler = dummy_handler;
+		synchronize_rcu();
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
 


