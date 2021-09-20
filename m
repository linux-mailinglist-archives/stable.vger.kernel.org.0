Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578D7411BD3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245230AbhITRCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235934AbhITRAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B126135E;
        Mon, 20 Sep 2021 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156783;
        bh=ecdzkSPgQbxYf5hpjar8p9p+f2rloYzIymYxhWyvR8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ammXn4tX6FcX23t2vAkPve24gfKe5jleI/i47oW7kQiIdM9aBkY/PKD5oEXYuLUHf
         0WEZtn/ZvmsK0TIDBFTMo+fTncDs5iMzF2PDkuP2nttD4rY7c8sk0cnlMF35FCTjH/
         snG0+5A/EzML9Abf8Fj7ljCtGgMU0I7eNr8U2YP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 084/175] KVM: x86: Update vCPUs hv_clock before back to guest when tsc_offset is adjusted
Date:   Mon, 20 Sep 2021 18:42:13 +0200
Message-Id: <20210920163920.822847551@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
@@ -2315,6 +2315,10 @@ int kvm_set_msr_common(struct kvm_vcpu *
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


