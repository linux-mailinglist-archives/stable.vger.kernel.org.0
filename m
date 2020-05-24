Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA91DFE7A
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 13:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgEXLNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 07:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgEXLNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 07:13:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3BEC061A0E;
        Sun, 24 May 2020 04:13:48 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q8so7554946pfu.5;
        Sun, 24 May 2020 04:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4SWwTIKbVIQ/Euyx0ClXTgcjt078nGlfq9rzX2kAtFs=;
        b=JX6r/7SkdpVN8pAm4Y7uYm90bezy5agmvHhfyiaO19BW1Aw+chOEYxVPEkl0cExUUc
         OwErkAh/Sq4FokF9OwddUUN9NelhWIiRqgT88cm5GN0AstXQaSZ2pMJKjzeZEqDChD4T
         i0s9uknCAq7KBUaQ5Tupwu8wKRGIrLq4tOWZ9u2RmJ5WVVh/+m0rzgLbq/GHtuTazP8X
         prWQwZaRqeqoM1vwVqcJ9SUZ/p9v+BGNVfC0+HtGGhPmfoevwmCWrLc36X/3mnhKmPu4
         +u/4rIhdstQ/XvF0t/giFMXDIw6AUmXnd9dCNB6Ih9/jQQ1coX2wzfGjI7jrTEz++axB
         OkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=4SWwTIKbVIQ/Euyx0ClXTgcjt078nGlfq9rzX2kAtFs=;
        b=ClpSoKpByZIrpmKafu2706npeOt0Xmd7kCarcdlar5ePYcrEA124hBlFS+AxztsDaB
         D53LeVNydN1k+XDUEJa2WQFOMnVFXPNADOvdx+S3SFOcvsjH8V4juf/NWWOqEa/pT6Tx
         HTub38YqLYUI4irxUhgTA1yjRPZI2HudcScBJWoNqw4S5cz9zluPAQD9BZi+Ma4ZXUZA
         K0Uq1wEhWmIVjhtW62vUMsCTGHjVi7PEHjeFaLAq7E9GFJ9j8nYoN1ulfJ5llRx1Sl4Y
         k7fMfav+gjAMzikrvoPMvMd152QrtOi5DmbMq1J1mF44LZRFizCf8RHgwtcVejmdVR8z
         ybKg==
X-Gm-Message-State: AOAM532XFVlCWh7+s1i1y4ZFeaFdXt9ArFYuiiPi/8DPRI/YIzFJjISU
        3I0wRSMvv6EWiAyZWlfkUuY=
X-Google-Smtp-Source: ABdhPJy7r6RAIENvEuj+J/Qex1tDgsb5Gz6FVG+v7Uznk5tJg8GzQlRT90SnwelwGq+mfdIRZr8GVg==
X-Received: by 2002:a63:b64e:: with SMTP id v14mr22465248pgt.164.1590318828296;
        Sun, 24 May 2020 04:13:48 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.13.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:13:47 -0700 (PDT)
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
Subject: [PATCH V8 02/15] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Sun, 24 May 2020 19:13:26 +0800
Message-Id: <1590318819-24520-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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
index 609fdcd..31c84d8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -276,7 +276,11 @@ enum emulation_result {
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

