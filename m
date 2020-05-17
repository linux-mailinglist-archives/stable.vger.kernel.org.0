Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947161D6583
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 06:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgEQEHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 00:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgEQEHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 00:07:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E59C061A0C;
        Sat, 16 May 2020 21:07:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu7so501286pjb.0;
        Sat, 16 May 2020 21:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j/OSBdV9DXY2ETWsIc3eeYNxFXzAjwLns12YdEbp9AY=;
        b=B2yMKeghdKEalQL1S/6cpbziQB/gYSCUjWQq8KZc7BlNnE15ZV1g+FNLK1L12KtzKW
         zaUeGEGitoqvSfLH7ELQw5N0AYwW2CL5qnB9zdZxLI4CjdAt88AkdaJVuakXOkTabRWQ
         rq8B4t5xY98WbScJYvwcio9LlKB0bVooVyDve/r5pLS9PpCCyDIzUHYP390kzISUHf/T
         ihSmj0mZr2uHCWtqO4dB8JdS3o8hRiv6odiNAxIj/Hn9bp4J6iYFawkSjIgUXyKMPI1o
         YHcqawQ/MEmLSs+vBvQZdByS7zKZAnwrM0wQo7+Gm8CeA+nBrooTFuXp2/mKFe8PQz5/
         eB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=j/OSBdV9DXY2ETWsIc3eeYNxFXzAjwLns12YdEbp9AY=;
        b=eoyadwHHLY9BkPo5UoEMHeDubb1HqlRBC19RMy27aEyAxoH3m9Ujhel7xpDehgtwIO
         5xLhl1vHJpZJ0ePcvUQROvoLwcl6lCQpJdSwOCW6g1Rwdnnlwm/87K1Cf2HiE8seLpMd
         g3xgGTcZQ6ZjRMdAUwA6qOWSvXT++0gv9SAycaJekKx75fESl4FuEOLWhPMqmXsTAPoc
         6sOTX74Gu4ctkv9H/X+WZT/BFfvouVx+c3KuumX2pj7Fv5k/kcEtmejKAYpLpCngnHTG
         ORBwiNXKXIMhwUPKRG6CjYJXBIH+ImMhwRGVbLHAFHqmg06xEc0/hQrUrsracXUyfXxJ
         eIxw==
X-Gm-Message-State: AOAM530JNDTYKiqzrVTh7OCzS/wWsRaSCGYbdGQa1sTexPn8PO8zd4PI
        M8U+qKByjESDPYZosyq6J8g=
X-Google-Smtp-Source: ABdhPJwdG4WjNuaZ0mEN6ll9DPFldhOiQbQ7WYxPL89UBUCmDLxP9iYuwEuUDqbnsoa+kQZPOuUbAw==
X-Received: by 2002:a17:90a:ee85:: with SMTP id i5mr11721106pjz.165.1589688419666;
        Sat, 16 May 2020 21:06:59 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.06.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:06:59 -0700 (PDT)
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
Subject: [PATCH V6 01/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Sun, 17 May 2020 12:05:58 +0800
Message-Id: <1589688372-3098-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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

