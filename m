Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930051D0B04
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 10:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbgEMImr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 04:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732346AbgEMImq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 04:42:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75189C061A0E;
        Wed, 13 May 2020 01:42:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f4so483808pgi.10;
        Wed, 13 May 2020 01:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j/OSBdV9DXY2ETWsIc3eeYNxFXzAjwLns12YdEbp9AY=;
        b=EIAEu13s66oW9k6Vovao7G9E5SdbVttY2FcvhrhrOpALX1xzdvK/fi/5tSU7AchDrp
         xjLtTXSaYOXC++MtKSG6XSfRi9Uzq1LWgosZxGGJVrmIj7S2PUe4+KOYCVyOlSGXf3Be
         5v1Bo79980xaF8uzo7M0mIugK/BM3uAyVAKwwKiYNjrikkAKXa7FfnwfkUi8ED3Svk3O
         3fv+F72WDxYp7zS9Iii1kCYc+5Ibvam78ju91GWMfRjrXyfbpkW3BlgP3k/AMXBl8izp
         2t73getaNkWaFmZAXSG2AAIwrOUt9mMyFAfFh+Umi9i+CdOWtpfaR1sTnPHEQ9Pyb9M2
         +AjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=j/OSBdV9DXY2ETWsIc3eeYNxFXzAjwLns12YdEbp9AY=;
        b=T5msJx6rRbsJyoQgLf7HovOv1bNZ//ti8yrhRChYtzX5znKZlK5Lqlf70kW24MTAyU
         QP/yr2Cc1l4JN2GIX0kiTLAomRz3sEHs6HHlRjWXn7Tz6kA0kTCDJ14Ui3OsJlk8skN8
         3e5Tqlqal5epyB0d1O9c1oFm3oKGvG6QWzWD4iNYbo0XXAFSjDjk22zOw5NYdttrLwyR
         wItWSGNx2Kzd47Fe04wAa+6Pvs9zjW4QSdVDxfaPWq7SyqXKpAO3XWbgI3a7BvDp12V1
         /rseUDoflppdR+SfX2t+T0RSpCHa+2CAsOlc69tIuSg7nXXW/6pMGUSdijq+KuSCb+5m
         ynTw==
X-Gm-Message-State: AGi0PuYGcYG13ybuini5cpXlZU0Gpb5XRFQdQSVdMtTpnX+TxBCYodlv
        UIiiC9PLAwIQm1gC3WOZfxc=
X-Google-Smtp-Source: APiQypLiGdoKvwZ0R+yNy9cOCSzPNjj0ev7QHPZckQlRMXmZf3SX1Uw+A0KESJ2kE5bzKLnnJnjwgA==
X-Received: by 2002:a63:f90a:: with SMTP id h10mr23319344pgi.57.1589359366020;
        Wed, 13 May 2020 01:42:46 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.42.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:42:45 -0700 (PDT)
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
Subject: [PATCH V5 01/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Wed, 13 May 2020 16:42:32 +0800
Message-Id: <1589359366-1669-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
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

