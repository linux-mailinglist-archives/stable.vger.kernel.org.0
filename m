Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC41B72A9
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 13:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDXLHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 07:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXLHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 07:07:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B022C09B045;
        Fri, 24 Apr 2020 04:07:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so3755783pjh.2;
        Fri, 24 Apr 2020 04:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8nxdgRcKM19fcM+rPWLhG14M7DWM4NBsZlKsa3VM4rQ=;
        b=qLdeBWkd6Pc5i/uk3JQIq6ymXWgJOxswGpIawRevnZbqrDqDtbbZJEnmwDlCjSAnmy
         OLMffj2QZ/DgpUrLj5J6SslTYDhn4B4QgAL/BSwhxO3GHfN6SLaO4lQT7jIjD6qdRb2U
         rK8w12k41vdd+OaVzmAbu05Yy3cU0055FOjyZ/mNNsRGLdLXeHCM0h+2AmfstuvkM2vb
         AcQuDouxK6E+/ci4jVIjhKZpAgHLKmIhw/TKGCKixMrtdExUigGEbli3cLaktj4Gh6i+
         VkSAK/eICcFu03i2wPdmJohTWLVWxOWeDW0sLWIhiAFG0HtlpT4PCHugQ7JWIxwiP5nl
         nJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=8nxdgRcKM19fcM+rPWLhG14M7DWM4NBsZlKsa3VM4rQ=;
        b=P1rqEJwaM1WBfDoU72Bgctq9tpk0VPSz2mbm4iDljsNm91v7Mmy1ijuCaYfTQsCv2I
         AVA2Kc7Ou2882Gwn7tDNE80MsRgOrwLaX9WGql014yFh9vzqh6c0UZmfODmViJaI1cSM
         JQL/pVJ9guJrjmwpul4DiVf2KDZgTQ6AdmyRSK73AXNc989thlsR/WIJse1ZeTlImA4t
         pLX799EEx5Ej8InYKw/3mnPks1pp1MNHxlhH9EJNWTTU3aDUg5UwRPzrfwTeXigrkMVl
         toOd2DIZh3BMYr5Oko3bdk1lQn9kmDNDZf/BELDLOALkl9afS7kWZf+Pu/jXvjZmxGtw
         CtLA==
X-Gm-Message-State: AGi0PuZ0ReeiDVc7bdeaUEYb1xdL28bRzPXNoD41ejA5bUbo04N16SDJ
        FZvI5N3xbY6KzNtp2OXr9RE=
X-Google-Smtp-Source: APiQypK5LOjONOgtSN7Kfyb6ZyzKPGT5cA7i5DMXu2tJahGLcetZuoftyFFTY62K/oFF+nq9PMYl/Q==
X-Received: by 2002:a17:90a:101:: with SMTP id b1mr5662598pjb.154.1587726452837;
        Fri, 24 Apr 2020 04:07:32 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.07.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:07:32 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 02/14] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Fri, 24 Apr 2020 19:15:21 +0800
Message-Id: <1587726933-31757-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
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

