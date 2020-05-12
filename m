Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6312D1CF275
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 12:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgELKb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 06:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728990AbgELKb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 06:31:58 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19391C061A0C;
        Tue, 12 May 2020 03:31:58 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f15so5199836plr.3;
        Tue, 12 May 2020 03:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x723HYVX6DLr2jIwmsKENzW16HVJ+jFKg8Bzo5IJIqo=;
        b=AkanddFeTVYotV2MU3WkzuS08pCcGroQ6uiV+hbrB28sgRMn3Y6ot5cQNrUlA4rR5y
         iBE9iRKSg/E9yg9Lba+FQm+MmSdre/264HEkqpUPCZq55vfJm72HjiOVcsqaVEp4oAJW
         Yut03N8cE78U3Lu6HqSY7rYC4SWpBTlb1Q14QovbEtJ/vLeSrGS4o/E/FU5PwZmFnIQW
         FfxFMkit75KGBBOg8ztgdTPtOw4nfhDOhiNzJevSNbXHdzOw5hzmEAcPjnJPZgzd0RW0
         bqn2MDT6sOue8YcksTXW57MijaQ44Pojhb7ijE/rz1ZZoJlqCxJ5wHZ0/BZ+tPZJNlD1
         B8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=x723HYVX6DLr2jIwmsKENzW16HVJ+jFKg8Bzo5IJIqo=;
        b=RuBpcxLGtI2FY+xmxY5dpposx7Ex39VK36mgw+a8/LJyLDvJKcivN8543+5HeJOmwy
         VPpK5yfpHagLj6Ya3g86oKVBMuFTT0Jp3DPaEzjR6zirlsV8/8OWhu2cmzjUHE6SSNAQ
         n9TU3g75uS0MjTkp93c755MJUjTNkMYkOJL3974ZiP2fqCVeoN7Js08NGPVO+JKz+ZQJ
         /TiLWHEH9ZxgSjjloKDr1WsqES9uFarqnixbqBYP4lPDxKqmzLyWglYO1Xx7zOY6LRzd
         uyOVuAjRaCTsm0RRhmP6ffgfPwnBscMQ9gvBIPgZULnrVD0FGGjKb52oGUj1nLmRtLtP
         9MXg==
X-Gm-Message-State: AGi0Puam3GSIOQnErnawRUqMWXcaFHKIZsfDffXEP9sW/vDMRMwYEmjx
        Tj6u4L2/GSAIp6kEDcenAHs=
X-Google-Smtp-Source: APiQypKYuvP6Yz8SZAqAYu/2EVhVfHUTVYeUP9sMz6TAP8fztO/cBA31vvm749W29zykWzTtvZRzeA==
X-Received: by 2002:a17:902:7d96:: with SMTP id a22mr20445958plm.194.1589279517429;
        Tue, 12 May 2020 03:31:57 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.31.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:31:57 -0700 (PDT)
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
Subject: [PATCH V4 02/14] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Tue, 12 May 2020 18:31:08 +0800
Message-Id: <1589279480-27722-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
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

