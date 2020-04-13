Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC55C1A6387
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 09:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgDMHW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 03:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbgDMHW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 03:22:27 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65935C008678;
        Mon, 13 Apr 2020 00:22:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cl8so2321368pjb.3;
        Mon, 13 Apr 2020 00:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IYw9KM308fvuCNV456QoScKTZAovGHwS9ZllmosmZHA=;
        b=oGsjS1xbf9xogVsLJWnou0X56088c+jXKkPfT4EJU21wV61xCDLOKDxpfmfG3pbREz
         8RQpXNeO/EqiBDGVeX6h16ORRBAT4GMuyFDC1fiPSjnwWXiceuU2GkdRxDubsjebobmS
         wdS/aovMHceQneB3xpCwn4W03T2EFMhwJdatsQgjPMvzabeRU3KMqOvbM/uPSCVUmMQZ
         Y2VqTQKgDxDT6DXqWega5bMoOk65CMSUjR63sJ+QZjjf8AbyyIgnO00cNo/wjESjTQBz
         9rZnV43N3RDME72XFmvzcsoVa3MUW1LuYiBW4T+krx3BSkwHC0rX+Y48YBgSGkDTyCFh
         m9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=IYw9KM308fvuCNV456QoScKTZAovGHwS9ZllmosmZHA=;
        b=HOwF7e+PEui332doMOy/esTve9EOCcAzVEN+Z71SGMV969+Uv2HXztpjiJhjUsBgX0
         FyAgFGp/dXf1yXdi7L5cBS0mFm9Leeaipsgc5gKYMOi6T2YyZBmB83Y5zwurp98YS6vo
         vHWrqKe6uuxtUQv7WxkCwFT62ZUqqvpiXSUTnFoBwvJI7YGvDQcZ+qgjaHRaiXSOwv4b
         0GxsXMOUmM1QoF61yb/ZRH/IZANe2kpun1yaPmZZiL//if8Xrwu2kz5IpAe6TT1L8Nn/
         jh0C+FiotpOFMIe/67h+2K9Gghvro7mm1DBrZcwMewuvxENiAf82h/1bU0DohzYRgW6y
         ljkw==
X-Gm-Message-State: AGi0PuYcRg34fNvntdyOTHBErtnLI3chs5PIruf9GIXVVKSXQl1hBWDM
        FaVGvcYBEm/iRQZJkCLUKPU=
X-Google-Smtp-Source: APiQypLratNJjdldNhRTz0xpzWmi6lNCP7lJRob5L/BRLECvfri/in1gAYGd1LdcJFUKuecUGIfAQw==
X-Received: by 2002:a17:90a:c295:: with SMTP id f21mr12982259pjt.176.1586762546007;
        Mon, 13 Apr 2020 00:22:26 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.22.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:22:25 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 02/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Mon, 13 Apr 2020 15:30:11 +0800
Message-Id: <1586763024-12197-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
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
index 41204a4..5794584 100644
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

