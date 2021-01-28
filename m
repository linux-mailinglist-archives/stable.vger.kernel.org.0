Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48E307BDD
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhA1RLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:11:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232785AbhA1RJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 12:09:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=56oQ7o7FTqNZj3MPWTOvHCfMyHXwWD8QK/wEL2B1WRw=;
        b=MmjlWuw+xjdVtnfad9N6+tdGllMpQbB3Am+Opq+3hRLIh0wnZgX6Kub8P0IvnlCf1wjKXh
        /+LKQMBx89EzmtIxZV3K48BnGoWnyeAB+PXWqhMXZLrlWeQYVoSKWi6c+l0TyolOXRftNd
        STiYIz24b95K3nTNhEIni2ZU28PXlZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-6MfMRXZwO1GQNqcfnJwJPQ-1; Thu, 28 Jan 2021 12:08:02 -0500
X-MC-Unique: 6MfMRXZwO1GQNqcfnJwJPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 536FC84A5E7;
        Thu, 28 Jan 2021 17:08:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9CA75D9EF;
        Thu, 28 Jan 2021 17:08:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, stable@vger.kernel.org
Subject: [PATCH] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off
Date:   Thu, 28 Jan 2021 12:08:00 -0500
Message-Id: <20210128170800.1783502-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Userspace that does not know about KVM_GET_MSR_FEATURE_INDEX_LIST will
generally use the default value for MSR_IA32_ARCH_CAPABILITIES.
When this happens and the host has tsx=on, it is possible to end up
with virtual machines that have HLE and RTM disabled, but TSX_CTRL
disabled.

If the fleet is then switched to tsx=off, kvm_get_arch_capabilities()
will clear the ARCH_CAP_TSX_CTRL_MSR bit and it will not be possible
to use the tsx=off as migration destinations, even though the guests
indeed do not have TSX enabled.

When tsx=off is used, however, we know that guests will not have
HLE and RTM (or if userspace sets bogus CPUID data, we do not
expect HLE and RTM to work in guests).  Therefore we can keep
TSX_CTRL_RTM_DISABLE set for the entire life of the guests and
save MSR reads and writes on KVM_RUN and in the user return
notifiers.

Cc: stable@vger.kernel.org
Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++++++-
 arch/x86/kvm/x86.c     |  2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc60b1fc3ee7..80491a729408 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6863,8 +6863,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			 * No need to pass TSX_CTRL_CPUID_CLEAR through, so
 			 * let's avoid changing CPUID bits under the host
 			 * kernel's feet.
+			 *
+			 * If the host disabled RTM, we may still need TSX_CTRL
+			 * to be supported in the guest; for example the guest
+			 * could have been created on a tsx=on host with hle=0,
+			 * rtm=0, tsx_ctrl=1 and later migrate to a tsx=off host.
+			 * In that case however do not change the value on the host,
+			 * so that TSX remains always disabled.
 			 */
-			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			if (boot_cpu_has(X86_FEATURE_RTM))
+				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			else
+				vmx->guest_uret_msrs[j].mask = 0;
 			break;
 		default:
 			vmx->guest_uret_msrs[j].mask = -1ull;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76bce832cade..15733013b266 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1401,7 +1401,7 @@ static u64 kvm_get_arch_capabilities(void)
 	 *	  This lets the guest use VERW to clear CPU buffers.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_RTM))
-		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
+		data &= ~ARCH_CAP_TAA_NO;
 	else if (!boot_cpu_has_bug(X86_BUG_TAA))
 		data |= ARCH_CAP_TAA_NO;
 
-- 
2.26.2

