Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFA7409029
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbhIMNui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243276AbhIMNrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB53D61211;
        Mon, 13 Sep 2021 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539950;
        bh=QZzrdQ2cwn4WxiPAJIowrMx9IsdAja4shefopQdmRgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEvUVrXPsrRJ7sBJb0lJAp/cJzL0Dn2ZfgyHSzohCY7NmI4H0ZWOxVCYjy/X9Q/4N
         D5YcuK6nmlaiXqqT8OQmgxC3gOpXRCZAUFQyXga1zlZtNa8KXLc9xZliWULXLeXBsb
         rYieixOyJO7pr/7CjoNc1VP5i4tWdBngOPppF9GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 226/236] KVM: x86: Update vCPUs hv_clock before back to guest when tsc_offset is adjusted
Date:   Mon, 13 Sep 2021 15:15:31 +0200
Message-Id: <20210913131108.039455298@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zelin Deng <zelin.deng@linux.alibaba.com>

commit d9130a2dfdd4b21736c91b818f87dbc0ccd1e757 upstream.

When MSR_IA32_TSC_ADJUST is written by guest due to TSC ADJUST feature
especially there's a big tsc warp (like a new vCPU is hot-added into VM
which has been up for a long time), tsc_offset is added by a large value
then go back to guest. This causes system time jump as tsc_timestamp is
not adjusted in the meantime and pvclock monotonic character.
To fix this, just notify kvm to update vCPU's guest time before back to
guest.

Cc: stable@vger.kernel.org
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <1619576521-81399-2-git-send-email-zelin.deng@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3116,6 +3116,10 @@ int kvm_set_msr_common(struct kvm_vcpu *
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
+				/* Before back to guest, tsc_timestamp must be adjusted
+				 * as well, otherwise guest's percpu pvclock time could jump.
+				 */
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			}
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}


