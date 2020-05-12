Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A581A1CF26A
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 12:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgELKbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 06:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727783AbgELKbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 06:31:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E13C061A0C;
        Tue, 12 May 2020 03:31:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 145so6146896pfw.13;
        Tue, 12 May 2020 03:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j/OSBdV9DXY2ETWsIc3eeYNxFXzAjwLns12YdEbp9AY=;
        b=fEq7Sr4EkplIF9pG8id32iWH/aPwuaVUqoIqACL9UNK7QQmjJ4n9IW2uMxLTcHPFxx
         H/eGKb/O4GgC6Fnv1QsiLRuswSiEI3P/Fyy700xI4YMZHO9YpjKJV9MWaSy6P7fKQ0Ob
         lrEJ+S+G24XaMXTDHwDtNlVRAP8qLPBmmvRi51hwlufs2Fk8eZxZC/JTWm6kLQaLYJN6
         vSd7lCgqMLQ5PEnl9TNLNfNvxd8HfpL3gKwcAg3r0fA/WYKyHC7e7BbTm6BvYFFxa1Qo
         Kdcolr/iQej3Vii30o3fWgc2KsGVREXXK5RYrTpuLvvr1OuNkoInPrfPaluvTYuvxJSa
         EDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=j/OSBdV9DXY2ETWsIc3eeYNxFXzAjwLns12YdEbp9AY=;
        b=PAi2o6Pyy7S43uoaN1FrSnhO18Jz/WmLNSo0TdbpQGfo23UksLcMSd0jsZ+mGy729U
         941D1a8xD9theryhxT8YYkf36Yi2ByGYNiFgZ2mW7sW+KTyDYtl/Cb9dADJY/w5/9hqh
         MDY0vSE0QSLKqspZdxxJ6xBxJGTqOF47IMR4rkIcQK5v3NEXyAKdwo9+pOxC3A+fADfh
         FYcgRrdMdjkNXiKZXy1wKVL5Tti5X9eslqp9hU3Jxe5U/xWAIjWWtnOx6uvYRKBSxQVv
         tt0Pq+vBpvifNa0QKUHp7iKWMk20RIMaHQ7Qkbej+gqTrAyG5+Pa1XDfs+NErSCj3GuS
         Xe7A==
X-Gm-Message-State: AOAM533UroBn0w8ywsB1BbmoJeCHmD9/SnK6AaTvsYbrt5oPqpMPaW5Z
        A+5onEMSNNMmOHXscrG4uD8=
X-Google-Smtp-Source: ABdhPJxdMD9Ow/MbQA5IBOhG4NQb6JObw/P1+wDSKXEqd0lzf7a0RORVeuumSrXi6/C2J3J3mZsn6A==
X-Received: by 2002:aa7:8754:: with SMTP id g20mr15026pfo.236.1589279479065;
        Tue, 12 May 2020 03:31:19 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.31.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:31:18 -0700 (PDT)
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
Subject: [PATCH V4 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Tue, 12 May 2020 18:31:07 +0800
Message-Id: <1589279480-27722-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Li <lixing@loongson.cn>

The code in decode_config4() of arch/mips/kernel/cpu-probe.c

        asid_mask = MIPS_ENTRYHI_ASID;
        if (config4 & MIPS_CONF4_AE)
                asid_mask |= MIPS_ENTRYHI_ASIDX;
        set_cpu_asid_mask(c, asid_mask);

set asid_mask to cpuinfo->asid_mask.

So in order to support variable ASID_MASK, KVM_ENTRYHI_ASID should also
be changed to cpu_asid_mask(&boot_cpu_data).

Cc: stable@vger.kernel.org
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Xing Li <lixing@loongson.cn>
[Huacai: Change current_cpu_data to boot_cpu_data for optimization]
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 2c343c3..a01cee9 100644
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
-- 
2.7.0

