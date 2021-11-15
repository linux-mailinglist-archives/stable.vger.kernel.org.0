Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F28A450ADA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbhKORPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:15:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236880AbhKOROC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4170A63236;
        Mon, 15 Nov 2021 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996240;
        bh=VCo8KtT/4m2feGM5iJzv4Hn3WiPiRGxGUVYg9xke834=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvI7RRhncBUVxZiLU4gKBgxnU4ffx+CzmAwH/toGEfvrH3ElVGQIjfWDYPQNzvqy9
         Py/G9PFtinN8ixo0Epxj5FAgNcjGj1kBwqpEqb/H7VNdLkkd3b0zZauCqIjTwP6clG
         lWzLoWiXnJ4DUX51tgSW3y66K0C8RSNteI+NWbFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 035/355] x86/irq: Ensure PI wakeup handler is unregistered before module unload
Date:   Mon, 15 Nov 2021 17:59:19 +0100
Message-Id: <20211115165314.681867989@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
@@ -295,8 +295,10 @@ void kvm_set_posted_intr_wakeup_handler(
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
 


