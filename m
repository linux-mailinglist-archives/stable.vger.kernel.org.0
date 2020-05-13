Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B761D0B0B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 10:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbgEMInd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 04:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732346AbgEMInd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 04:43:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154CDC061A0C;
        Wed, 13 May 2020 01:43:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j21so7480895pgb.7;
        Wed, 13 May 2020 01:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x723HYVX6DLr2jIwmsKENzW16HVJ+jFKg8Bzo5IJIqo=;
        b=l3zPLZzESzlx4CgUI3d7+chEy9CkNolo7AFjW3rPtQAwBnB+CZ4UzwVASkdR1PbV+K
         PwXp5Esox038QlBWAtrwLgxbx8OciJwED6UyMklpSy9pHOwKe9yidIp9m6sSjITn6im+
         2g972iVCYCyE2dI65KrncIz6f74LJHS62cNu/5IDWJ5SZYVdS+iy2zLdB/g++JRf4ngi
         0fRWgqb11YRvATfHtVbvzKaGmBg3LADVY9G2TeJX7CmkhPIRZ823SUwmBaqXCH9a/AkO
         u6zPSU8BAIQkz6yXMd5Kx1c+YP9wu+o2yHn0+k7h0N5EAcSv6FKJUurJULlgZ3/9efHy
         gkcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=x723HYVX6DLr2jIwmsKENzW16HVJ+jFKg8Bzo5IJIqo=;
        b=ugxt91TKhae/Ag0Z1Xto6ctll+w4NvAH6MWaB7HhvXqTePPJDwbIKGQDH7HXwXo5Jg
         gO7UDfLXZgOZNBEa8B2KTjs8rYWUlO9tom70Vs+GiDbGwTW0C0+9mGsAUZhfYb+vz1Yh
         C8ASbUtHsUrzVciWJ3dFsE4xD3Ua4WoGUhsr44JtOqSbnO7IwtuRQxZNysJe9Gz2xBlN
         4No2uHIwFJGbXOikR32HXglrkWm+X59UuPAXTwhaBiBPUJy8eSidvvfp9t4Ic0MsEce9
         FhcIkv2QM9cWRoCnLvJFfzH/s5wukNgz69mqYzswl7JVegb0iwL3GH0f+RNT7wYXxpPQ
         Qivg==
X-Gm-Message-State: AOAM532yiYKSC4gC8R07YHpCjTkwDCq/+eHOBC3M/1sAgg+nnAwbKLWL
        KEc4MMVqWG6k9fnuVbaNbxk=
X-Google-Smtp-Source: ABdhPJwwD83Vg/EutCB+P323CDIRmGboQdQC50XakZbK60NDvlB1fuWnSctqXPyqsp2KGcmqfEb8Rg==
X-Received: by 2002:a63:b219:: with SMTP id x25mr14736291pge.66.1589359412677;
        Wed, 13 May 2020 01:43:32 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.43.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:43:32 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 02/15] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Wed, 13 May 2020 16:42:33 +0800
Message-Id: <1589359366-1669-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Li <lixing@loongson.cn>

If a CPU support more than 32bit vmbits (which is true for 64bit CPUs),
VPN2_MASK set to fixed 0xffffe000 will lead to a wrong EntryHi in some
functions such as _kvm_mips_host_tlb_inv().

The cpu_vmbits definition of 32bit CPU in cpu-features.h is 31, so we
still use the old definition.

Cc: stable@vger.kernel.org
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Xing Li <lixing@loongson.cn>
[Huacai: Improve commit messages]
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index a01cee9..caa2b936 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -274,7 +274,11 @@ enum emulation_result {
 #define MIPS3_PG_SHIFT		6
 #define MIPS3_PG_FRAME		0x3fffffc0
 
+#if defined(CONFIG_64BIT)
+#define VPN2_MASK		GENMASK(cpu_vmbits - 1, 13)
+#else
 #define VPN2_MASK		0xffffe000
+#endif
 #define KVM_ENTRYHI_ASID	cpu_asid_mask(&boot_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
-- 
2.7.0

