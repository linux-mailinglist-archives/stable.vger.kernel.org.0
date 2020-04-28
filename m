Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3F91BCB09
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgD1Sd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbgD1SdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9C8D21835;
        Tue, 28 Apr 2020 18:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098805;
        bh=WCHXzWwqAstatUoruqMOdtVKrthmhw+tUuchZIXN6P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqKo5NX4zU8nK30XVJVUsvVPs4AoGqe/4IOnop7vSGTUKCd/9YDRcy7by/aTYKH4Q
         lvgdK7jKKd1qQT8kO6XlGUrkgeEJVIFpPYlFmGC7w3mO8QuxFKbVYhDV1Nmxzozd1c
         GOrXMkZjIQvmAHo90Fq6RQ0WFFpOD3ek/6mHLAKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH 5.6 114/167] KVM: VMX: Enable machine check support for 32bit targets
Date:   Tue, 28 Apr 2020 20:24:50 +0200
Message-Id: <20200428182239.628317549@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

commit fb56baae5ea509e63c2a068d66a4d8ea91969fca upstream.

There is no reason to limit the use of do_machine_check
to 64bit targets. MCE handling works for both target familes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: stable@vger.kernel.org
Fixes: a0861c02a981 ("KVM: Add VT-x machine check support")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Message-Id: <20200414071414.45636-1-ubizjak@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4571,7 +4571,7 @@ static int handle_rmode_exception(struct
  */
 static void kvm_machine_check(void)
 {
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_MCE)
 	struct pt_regs regs = {
 		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
 		.flags = X86_EFLAGS_IF,


