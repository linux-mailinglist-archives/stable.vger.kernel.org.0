Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D311DB65E
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgETOYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33218 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-00036s-JF; Wed, 20 May 2020 15:22:21 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DT9-07; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Miaohe Lin" <linmiaohe@huawei.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Liran Alon" <liran.alon@oracle.com>
Date:   Wed, 20 May 2020 15:14:27 +0100
Message-ID: <lsq.1589984008.575672866@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 59/99] KVM: nVMX: vmread should not set rflags to
 specify success in case of #PF
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

commit a4d956b9390418623ae5d07933e2679c68b6f83c upstream.

In case writing to vmread destination operand result in a #PF, vmread
should not call nested_vmx_succeed() to set rflags to specify success.
Similar to as done in VMPTRST (See handle_vmptrst()).

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6455,8 +6455,10 @@ static int handle_vmread(struct kvm_vcpu
 		/* _system ok, as nested_vmx_check_permission verified cpl=0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
 						(is_long_mode(vcpu) ? 8 : 4),
-						&e))
+						&e)) {
 			kvm_inject_page_fault(vcpu, &e);
+			return 1;
+		}
 	}
 
 	nested_vmx_succeed(vcpu);

