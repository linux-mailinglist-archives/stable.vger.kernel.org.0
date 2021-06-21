Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3C03AEEF5
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhFUQeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232478AbhFUQcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7874561380;
        Mon, 21 Jun 2021 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292749;
        bh=wmQijU7kKbKj7CTjjXlN4Qf/Ll7b92Zy7dVFKLFaTWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDDeZv0Uu1lwhAsKL8/qAn2mpI5yVFPxKeeksvELWxabYHDiRZMDTfQNWC2olgSeS
         4jemThzyKEkFZ2Y9WMSLcbOqgUwgBf5JKeylPjnGsaGf5RV/WQ8PAwkjUES6GWtBFj
         5S2beQRIealAoVG6ePRJNTPM09jFqZWkIs+riOV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 114/146] KVM: X86: Fix x86_emulator slab cache leak
Date:   Mon, 21 Jun 2021 18:15:44 +0200
Message-Id: <20210621154918.625077118@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit dfdc0a714d241bfbf951886c373cd1ae463fcc25 upstream.

Commit c9b8b07cded58 (KVM: x86: Dynamically allocate per-vCPU emulation context)
tries to allocate per-vCPU emulation context dynamically, however, the
x86_emulator slab cache is still exiting after the kvm module is unload
as below after destroying the VM and unloading the kvm module.

grep x86_emulator /proc/slabinfo
x86_emulator          36     36   2672   12    8 : tunables    0    0    0 : slabdata      3      3      0

This patch fixes this slab cache leak by destroying the x86_emulator slab cache
when the kvm module is unloaded.

Fixes: c9b8b07cded58 (KVM: x86: Dynamically allocate per-vCPU emulation context)
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1623387573-5969-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8021,6 +8021,7 @@ void kvm_arch_exit(void)
 	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
+	kmem_cache_destroy(x86_emulator_cache);
 	kmem_cache_destroy(x86_fpu_cache);
 }
 


