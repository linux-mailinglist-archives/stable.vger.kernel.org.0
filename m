Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3B1C2B17
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 12:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgECKGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 06:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727971AbgECKGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 06:06:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7298BC061A0C;
        Sun,  3 May 2020 03:06:52 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a7so2336591pju.2;
        Sun, 03 May 2020 03:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PbRSEAf2iP4s0AdgPIwTBI8UU6TRpGo2RmWTv12T7ho=;
        b=VTYiLf8K3ZXQ03QVxYhF/9uO0E/tOu+kPQwoAc93b3BEAgcVSLQpBRqF2Tf/oUnNLT
         5MfOCVNkyIxmfW6rqRAG/KDOGfJ90qSCOYkyLVyp0kCgfho/WbXvhYjmWOk0cHJ5XATU
         DT0r+nBcu/TmiBtudt7o8B42SrS5xlGZch/1pUGsPFXcIVqwxqDNtPmHwMfsxvoFXZ1A
         7UIBtWfNo9LYAGZPY0CkpTT/Cb9i6S0Nln245se2dLDSKKL+IHXw45JcsEkqVcmoO5VM
         mVffHeh9xVjeJYazs9MkBbMnBRM3I7qierSyZc936jKsNujp4nP3aLs9jchzfKN8CZ1c
         LRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=PbRSEAf2iP4s0AdgPIwTBI8UU6TRpGo2RmWTv12T7ho=;
        b=kd2FBUxics+bZfp4qgSj4YoncMeCzVeuG2768QeZgE3M8sRK5AGi143DIW4Bmsfn00
         n9OqyzYrhiefnbnvJ1T44vVSLs384QWzl3sQHTZ4lMRHxMbRhfBjMIlTqEjYtd2xhaEk
         guxJNtD2J14HR32Bl0cBQ2m2/yZQmxxQoCQhob7LI3DdekoZtfP4WkvzNerKS96e+6Qw
         aHEQjMEvbge7SlNJsfHBX1Pg893UF1jCpvgH/CzWxURDVXqTXNWHirPmwj0QJUb9Dptw
         bmdHQVEOVJbLiMe2/gtgk7eqtOOJ0Quvre/JjHGmqCy68NjQne7oCYV1njSax2BumxX5
         4f5Q==
X-Gm-Message-State: AGi0PuZ0cn8iich0ESm/UC/ZqYdLxNcTR/FMyd/BHZf+tNb1G9uZQnro
        PMnv5DmEIWMpX6MYb39S1+k=
X-Google-Smtp-Source: APiQypIMzb4fvmZ2zpKo8dEGVhfSuz5hlvqkKdlygX14KjFPoy1s9T1BV1mrn7vMVcueySXbmeQTHw==
X-Received: by 2002:a17:902:7045:: with SMTP id h5mr212211plt.108.1588500411150;
        Sun, 03 May 2020 03:06:51 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.06.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:06:50 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Sun,  3 May 2020 18:05:54 +0800
Message-Id: <1588500367-1056-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
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

