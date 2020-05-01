Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861BE1C13E8
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgEANeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbgEANeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B03208D6;
        Fri,  1 May 2020 13:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340040;
        bh=M1Uw2oN3BhKp4keHsbQLTDAyrYEGICjGNJp73s1thXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1I20ynFwN9Vxdn5KaQcJlovWpDuROoDKyEx5Oxbo/0v1t1MMlRfnJ52q6T/6eljx0
         jQ2Rbzlvnff/gj/l7guo7Tg8XzxLBIQCnZKwVdpyoOvQt48BzTUCrjBR+85QKH7SXd
         kE+ZPr/DKI2AcWP5SyQTzaswv/NMznl5vwt3wXhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH 4.14 060/117] KVM: VMX: Enable machine check support for 32bit targets
Date:   Fri,  1 May 2020 15:21:36 +0200
Message-Id: <20200501131552.572128466@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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
@@ -6250,7 +6250,7 @@ static int handle_rmode_exception(struct
  */
 static void kvm_machine_check(void)
 {
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_MCE)
 	struct pt_regs regs = {
 		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
 		.flags = X86_EFLAGS_IF,


