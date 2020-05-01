Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B581C1584
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgEAN3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729819AbgEAN3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:29:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47B572495A;
        Fri,  1 May 2020 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339780;
        bh=oKPEVnF03r3G2DLWNq0tK6eovYLjR0lpVzFPy7t21Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxvT/c/YkGfyd7cMOzg/y/MCY8RxiVvm1gkg2+hqmrhORvRcK9TAWhtOpCcFYiZFe
         JVuaTUownaf+bAjk+kkKFvTtmP17JaOoWTjP5LZy7tO1R10iS/y48MDjPz2bsNV5Ut
         26/4Fibxo3alUeg5lZcwrz82oG1f6HbV+PIj3Id8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH 4.9 45/80] KVM: VMX: Enable machine check support for 32bit targets
Date:   Fri,  1 May 2020 15:21:39 +0200
Message-Id: <20200501131527.915393222@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
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
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5785,7 +5785,7 @@ static int handle_rmode_exception(struct
  */
 static void kvm_machine_check(void)
 {
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_MCE)
 	struct pt_regs regs = {
 		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
 		.flags = X86_EFLAGS_IF,


