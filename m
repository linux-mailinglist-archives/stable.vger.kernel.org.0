Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D7C1DFE78
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 13:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgEXLNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 07:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgEXLNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 07:13:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B404C05BD43;
        Sun, 24 May 2020 04:13:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t8so5128838pju.3;
        Sun, 24 May 2020 04:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WuyhKwGEWNBKEIWUWbDKke+4SVYP5RK6xsvzYyjPUOs=;
        b=qxV8znGSeA9I1xuySErWxun71aul8o1iyvqA3YomhBbQN56syQU3pdsebg2dHZ9Dl0
         kxDTCUAS9dqtG8H+zNc3WeWy51EYYYd27Ts/Qb2Uhe/6zBSZqiIQb1kt1Ua8cds2IdEw
         cbDc6AWq0eoLncc+uGIWahOJnxn7/F/8vpmwQ+Nm3BtJITi4A/onxgb4skd/7sbiVeIj
         0IUhnGmJrXnj1Mt4FcrA7MTcoBckY5TzJGa6Ujk23N2D2gMrzQlJnRTEffabHDdiiUnV
         Zqo1thlM+/lm3c2CjRIs9HsxrmUBXbiGqvVmhel4zbb10NMxy3XN7YOxds3cItYZ1fnk
         JOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=WuyhKwGEWNBKEIWUWbDKke+4SVYP5RK6xsvzYyjPUOs=;
        b=q/8sz8rZuBeaFM+KpPbCpjM/I52upSGYhEA7Or5CHJiYi11javd5PDArxq7HKsDos4
         SPvz8whwHplzJ6UOBquxn1RlXzF9GBI0O+9K75pnos+LzIQcq+DQ0sja20qK3cOis1J9
         K5iyuefAr2xJXT4/RX7o9xQUBVxcCk1dXpbHt/GKkqlPmOBG9dN8wLi8UQsl2sHdznDg
         C4QQ7b+oPzI8b0VlaGjQid5F0RaSi3SIrF+wMW8rAmJsvCFv+4ZvPN0TRLVhflMS17er
         q0gVovjSg3/1AiguaAXC2I4e0f782zhEDklTcGn8MXvprpmFtZuYbWHLK0/RpJNQZrvQ
         adVw==
X-Gm-Message-State: AOAM531H9MZuOWZjcjRBwaic+8gb8QvnwKIKN8uNL0DHO6fsCKifMFyn
        zGkzDFFu4NcWx4PwcVTIlzfazaBhjURPBQ==
X-Google-Smtp-Source: ABdhPJwBzT1LoSKouDtictZI3N5bJev1OiQg4Q/0sd5NJmGiumBvGZZxePmAV2IrixJ0Toaso82EtA==
X-Received: by 2002:a17:902:930b:: with SMTP id bc11mr23559343plb.2.1590318790688;
        Sun, 24 May 2020 04:13:10 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:13:09 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>,
        "Stable #4 . 9+" <stable@vger.kernel.org>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 01/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Sun, 24 May 2020 19:13:25 +0800
Message-Id: <1590318819-24520-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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

Cc: Stable <stable@vger.kernel.org>  #4.9+
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Xing Li <lixing@loongson.cn>
[Huacai: Change current_cpu_data to boot_cpu_data for optimization]
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index e28b5a9..609fdcd 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -277,7 +277,7 @@ enum emulation_result {
 #define MIPS3_PG_FRAME		0x3fffffc0
 
 #define VPN2_MASK		0xffffe000
-#define KVM_ENTRYHI_ASID	MIPS_ENTRYHI_ASID
+#define KVM_ENTRYHI_ASID	cpu_asid_mask(&boot_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
 #define TLB_ASID(x)		((x).tlb_hi & KVM_ENTRYHI_ASID)
-- 
2.7.0

