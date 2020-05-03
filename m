Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4B1C2B1B
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 12:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgECKHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 06:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727892AbgECKHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 06:07:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4833AC061A0C;
        Sun,  3 May 2020 03:07:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w65so4042233pfc.12;
        Sun, 03 May 2020 03:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8nxdgRcKM19fcM+rPWLhG14M7DWM4NBsZlKsa3VM4rQ=;
        b=ZpN/Pyh8jgDlcVAP+Zm995766QQ2OE8dLcS8OyvRqHICwXLezx8Stp7yWixH/5YmYh
         S//AlCI/eUoyNkcOQr8d1MPl7J+chdUCwOP3av5QEcWQ7H/meb+6ZWu9Re+PaaRZeNIR
         bQUMErOg1GRiV2AE7LpRm4BvBnjfXDOx5pWujyKpRtu/Z9UE91KkOHuCLxhwuGfn45vy
         2bFMzMFxoPMTFqKLeYis+V+YIsUYUb2LJor9tqau+kzVy8BBcdvtxLhdHMcDxY5/42kg
         oBENAMxrZM6orPq7RCF6jOgieNkatuN3+N4lkbKAXt0q2mTYfnliq5czkFMK2xp1H/Bu
         eD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=8nxdgRcKM19fcM+rPWLhG14M7DWM4NBsZlKsa3VM4rQ=;
        b=bIiP6d/zNIz5D5MzpNMiaIEMfWwPmNlGV0kJS+WzkTObqU5s65tIPtrMa4rKr5yfhO
         fuVfadpaofklYfAn9G7Wzw0Npgnzz39SIBFzti0awHfAsGJLcKcjK2CuDloHZ/WEd/H0
         PfRzywlolkM/lYhJpzkkz0EJULcCVMMJNSFK4dJxpuTWSihR6CHDrLPBVIgDIMLrHkbD
         P3zrjLTtonGrElvUTX3v47BpC1IRiqSzgisDUfqUE7UCgzywxI8UeO9iU2yxmQr9g5I4
         ZdvNKcTHnXkCwQWmoJbg5xlMOM7YTPwJDKWzOb8EqUKDJf8Lo1PP4FTlXDqDv/xOw+29
         PY4Q==
X-Gm-Message-State: AGi0Pua9bQH0IrS3EvPiBUW4oZIJziQsot4DXgDe9/ZpCpR8nMyKyp5B
        taZLyDxVJFsx7oS9nHIjjAY=
X-Google-Smtp-Source: APiQypIzotBeRon7oxlBO4yIrbf8EUAWEp+oSCqBmePTdSGLwWv/6/lE4N2UbFE6dpM7IvDijapmuw==
X-Received: by 2002:a62:808d:: with SMTP id j135mr11757046pfd.53.1588500454894;
        Sun, 03 May 2020 03:07:34 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.07.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:07:34 -0700 (PDT)
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
Subject: [PATCH V3 02/14] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Sun,  3 May 2020 18:05:55 +0800
Message-Id: <1588500367-1056-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
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

