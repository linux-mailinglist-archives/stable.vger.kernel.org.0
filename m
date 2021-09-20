Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F3D411A6C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243888AbhITQto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242396AbhITQtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5219E61222;
        Mon, 20 Sep 2021 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156458;
        bh=dEv5uWSnTsZuRdQzUV80WWkPD19ZrAlZ393d2hK5Kis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWNJwyyRj3etI+EP/rircdAcTj02ZD4KgzejO2n8qrbKCKiWjfoePV/WlB1ntOpmL
         fmrq0moI/wr2L/OBbVG3f1ytFCr9FVp8FRG/6Yg1bnBNMRAt74Skax//hAvXrurQRm
         vH4AGTfQIDT6xDU9KPtNuS3YRNiztyP3esDClcGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 069/133] KVM: x86: Update vCPUs hv_clock before back to guest when tsc_offset is adjusted
Date:   Mon, 20 Sep 2021 18:42:27 +0200
Message-Id: <20210920163914.908269791@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -2172,6 +2172,10 @@ int kvm_set_msr_common(struct kvm_vcpu *
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


