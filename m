Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3F645273B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244266AbhKPCUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238041AbhKORjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B4F163238;
        Mon, 15 Nov 2021 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997165;
        bh=sCGRoqgIuTqVQaUHV3hSxzqpHqtGIbeipKYmDeqB+bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lt3O5VMTWhZ8i7H1kBlziuUn5sjrr5a9T6MwkWfEpxTh2k/RKh9nN6whhSe9xcDym
         ucQRbgO0CZ00xFe7sNOD9vfYlaCM9cKDxx/u2jwZh/nG1N+zbvgV74Abl3gzQO6PAo
         d9NyZr49anW7LXPdPDcWrDMR7BsravBQoNB3QhnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 049/575] x86/irq: Ensure PI wakeup handler is unregistered before module unload
Date:   Mon, 15 Nov 2021 17:56:14 +0100
Message-Id: <20211115165345.330094384@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
@@ -290,8 +290,10 @@ void kvm_set_posted_intr_wakeup_handler(
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
 


