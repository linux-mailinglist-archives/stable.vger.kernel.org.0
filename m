Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B51B1DF5CA
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 09:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgEWH5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 03:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387662AbgEWH5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 03:57:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AFBC061A0E;
        Sat, 23 May 2020 00:57:36 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so5998822pjh.2;
        Sat, 23 May 2020 00:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mr0FAhLOELieh9DZeGXXj93QPjuQ0h9vSoNDx+Z8eDc=;
        b=BtXVvQiDCpwl/ELxpra13B7ykYN8P8wA+kbVRijHPgbWcAop22XEfWmO3CL19jKb2Q
         nHd94Mlpsi8wHh6jYH+Mne7OStwHolAm2H6mVNOkM0mhH0oF+Meh3dutp/f8Td4wNxCF
         Q90var25MfUA3YTYaLp7jKKpr11v5Q19NIxT9ykIhjExfaqy/FbUzCpRq9GkWC7EIGYF
         ZoNwJ/N1/CsZzKWCsWVKyPlVn/NAWbeqV9iFMSWUetUepwvnqe2OguCJGzAlYoaefBB3
         7CTVaJgMK5zBGxRO81EP7AN13MCc7JkivtCeNLu6r01b2kv1dQmQMQ5WmuxSWXK07h+a
         XV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Mr0FAhLOELieh9DZeGXXj93QPjuQ0h9vSoNDx+Z8eDc=;
        b=Vtozw0MalsCBArXCipb6y4P+1kQ/sZBSzIgo8Yd4GKZjKGIXJiMwm3YmLfwD94TCqZ
         fK5+ZxI3Vmf1kEPCNvEh7e370CeaVhgXZskt26qv3qtGXqLxkl9XqNUMbdJFJvwkKtLc
         s8ddw0avgUJWm5iu3VPy4qVl61hWUCo4eqkbfTvt91/zP5pCQcbZ4j9kpQ3FpVeT+6ht
         lKPOqEkCQKO4dJF/e53FTcpmOXumUg/CtGAKU5azK2W6rUBSXzzNOVDk2oWHZsLVwSNd
         EK0imXsI2OtbrheaGfkrV797MUgdvlrmzt5yeq3CjquxVRx0kQGKlVPd1DK05AqR7QM1
         xZvw==
X-Gm-Message-State: AOAM533nXox5obDy+7I/3Yw6i/Zuhh5/huq1zzH7CGiQp7S+A7K2O/bO
        Mtfwrudd1ktF4kziuOcx4/s=
X-Google-Smtp-Source: ABdhPJzx1h/licsWZ8dISNfZZUCevtRFUJzENEoLMFGD6SsVui+3LFaubvXscXPE1vr3nG/x1a/3mQ==
X-Received: by 2002:a17:90a:1a90:: with SMTP id p16mr8457285pjp.185.1590220655660;
        Sat, 23 May 2020 00:57:35 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.00.57.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 00:57:35 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, Stable <stable@vger.kernel.org>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 02/15] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Sat, 23 May 2020 15:56:29 +0800
Message-Id: <1590220602-3547-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
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

Cc: Stable <stable@vger.kernel.org>
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

