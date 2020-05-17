Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699241D6584
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 06:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgEQEHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 00:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgEQEHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 00:07:17 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0742FC061A0C;
        Sat, 16 May 2020 21:07:17 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so3056912pjb.3;
        Sat, 16 May 2020 21:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x723HYVX6DLr2jIwmsKENzW16HVJ+jFKg8Bzo5IJIqo=;
        b=Ly7RNW5ONVRr1lsVIEEvunTmFQZPMJS0BL2/2+0C7odxoj8qWq5pOlGlIdLDJyiGq1
         YxrE/b0BHmfFduqTzNwh3gqehaaN3HPT5jYevIwPLERxx7PRxkrMBUbycpYQVjauUIDS
         PADC1OYz4Jq5uJMUZ7iibD/RLfR9GUKUkX47CfuSUUYDeDats4h1svSNLNfPgV6aYZmW
         rhdD2J0segNnVnLIifq6Ywj5voMm0VylvEE+2GcEc0ewCK5IeWxvFtmCw/Y8rmdxEFyf
         LbwkeR00B73H/5xC7t9o8X5FjGjk3t6hHYUA24aUgo4/7rPRSI4UWdkCt+s7xuPJf0zN
         DWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=x723HYVX6DLr2jIwmsKENzW16HVJ+jFKg8Bzo5IJIqo=;
        b=ef79HsnMTDxb/lmnw+yXBYLrA02plioDqh4NV8UKmYPj6dhjP6yihXx+3PZVx6wHn+
         FgYCCwDUoKxnwSPMPS9rp5He3pE+SHblcD9UXLWLZb8NB+Rglmsb8LL9ISMiVtA2KcPF
         BwUEX8d7y9XHcZeErBSiD6d3zMUeepL/U0ZLN+8Gk9HNvvRR3OtHUUC4XI1Se8CL4bgy
         sXUPvgkeD3rtsB4fmfcIjMAwixQnOwSvP/nKaY7FwhRMLhgmWGc/w2d92wxAjVOD3y3k
         bODZlljwboUfmwN+uEIyonpHwF2yDxXfTGKsoFSEuNg7izOAdYgn/BOth1eeXANfMXGy
         uABg==
X-Gm-Message-State: AOAM532IDJSN693PqE0HJiDZm/2sosBQBOKTiwwqJVjAvQePx023JgPd
        ItKBbHmNj/AAtZuviaGT2no=
X-Google-Smtp-Source: ABdhPJxNqw3ZO5NstbH6AwW8qKBDc0jwi0iLWNJ5QQ0nOzpwujtm0ASMegdUJuo2DzT83gSoT7VdvA==
X-Received: by 2002:a17:90a:1aa3:: with SMTP id p32mr12547758pjp.4.1589688436559;
        Sat, 16 May 2020 21:07:16 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.07.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:07:16 -0700 (PDT)
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
Subject: [PATCH V6 02/15] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Sun, 17 May 2020 12:05:59 +0800
Message-Id: <1589688372-3098-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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

