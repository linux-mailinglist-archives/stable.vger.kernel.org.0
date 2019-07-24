Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A9F73E87
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbfGXTik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389655AbfGXTij (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919ED217D4;
        Wed, 24 Jul 2019 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997119;
        bh=eL0FO2CkjCIhfGMUQNVcz1iyPh7fdrLu1UzbrROToL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5Bwo+h7IkXbQ/a4nqut2yd1gAyncm+y14P9Yr6BGrsfn0CQ+FCxe2NupVECMsgvX
         Z6cFV8d+4iQN/vqesPvhjobjZus68vFpi2V3y5kaXlfX9HdcYRuKTcqKIDtrxtaGIx
         m9srpBL9j4HWv3wgw4/ZzSGWtAvrODM2zwkE+07o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 5.2 326/413] KVM: nVMX: Dont dump VMCS if virtual APIC page cant be mapped
Date:   Wed, 24 Jul 2019 21:20:17 +0200
Message-Id: <20190724191759.190392402@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 73cb85568433feadb79e963bf2efba9b3e9ae3df upstream.

... as a malicious userspace can run a toy guest to generate invalid
virtual-APIC page addresses in L1, i.e. flood the kernel log with error
messages.

Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
Cc: stable@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2878,9 +2878,6 @@ static void nested_get_vmcs12_pages(stru
 			 */
 			vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
 					CPU_BASED_TPR_SHADOW);
-		} else {
-			printk("bad virtual-APIC page address\n");
-			dump_vmcs();
 		}
 	}
 


