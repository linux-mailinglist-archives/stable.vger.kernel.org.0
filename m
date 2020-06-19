Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC9E200CBB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbgFSOtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389158AbgFSOtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:49:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41531217BA;
        Fri, 19 Jun 2020 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578141;
        bh=H74n6MAvvB1UwVfIs7kkoqmc7JsILcseQ+7gWMFrCa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jas6y154a2hUTKH1K1SLFoVhKeWFJ02O70dOk8CmJdp6llcxzZs5pt4MpNQh3ycSf
         PzjQGmDh4z5aB4UfT2zEgJRxtJrvT1O4Wl2HXmpBl7GwL6VvjmJBYvh6g79pOsmH5w
         fAzo4qtmLkkKGRINhpvavV1ckBvSR5YIaWsbQp3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Xing Li <lixing@loongson.cn>, Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 059/190] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Fri, 19 Jun 2020 16:31:44 +0200
Message-Id: <20200619141636.525966091@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Li <lixing@loongson.cn>

commit fe2b73dba47fb6d6922df1ad44e83b1754d5ed4d upstream.

The code in decode_config4() of arch/mips/kernel/cpu-probe.c

        asid_mask = MIPS_ENTRYHI_ASID;
        if (config4 & MIPS_CONF4_AE)
                asid_mask |= MIPS_ENTRYHI_ASIDX;
        set_cpu_asid_mask(c, asid_mask);

set asid_mask to cpuinfo->asid_mask.

So in order to support variable ASID_MASK, KVM_ENTRYHI_ASID should also
be changed to cpu_asid_mask(&boot_cpu_data).

Cc: Stable <stable@vger.kernel.org>  #4.9+
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Xing Li <lixing@loongson.cn>
[Huacai: Change current_cpu_data to boot_cpu_data for optimization]
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Message-Id: <1590220602-3547-2-git-send-email-chenhc@lemote.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -275,7 +275,7 @@ enum emulation_result {
 #define MIPS3_PG_FRAME		0x3fffffc0
 
 #define VPN2_MASK		0xffffe000
-#define KVM_ENTRYHI_ASID	MIPS_ENTRYHI_ASID
+#define KVM_ENTRYHI_ASID	cpu_asid_mask(&boot_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
 #define TLB_ASID(x)		((x).tlb_hi & KVM_ENTRYHI_ASID)


