Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB7B1A6392
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgDMHWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 03:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbgDMHWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 03:22:51 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC15C008651;
        Mon, 13 Apr 2020 00:22:49 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kx8so3478797pjb.5;
        Mon, 13 Apr 2020 00:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TZhgT5gzN/QhZfE1otKiPDej1lzfZYbOzbi8m9YCzNk=;
        b=msz8u4rnm9qloVBXtsffUI8FKe2tlKM+2hEuS45XjwHEz+dCvQHSQ7PdkCU8J9piN1
         3JvsDMJor8tnwIMkln5CN+Pa7AlPwBEjUTpBVIWCna1HZjItxG7ACje3wFcktp5e8tkD
         Kk0eY6ZdyNJ3lfzJ0c+r5Ccm4+ZO3xfZ3QTxoph9DQScR54Vkge4xoT10Fe2RDG+P0VB
         9Rv74/DzrAge9B1F/XCGuTOEmDOA3xb1+ktX3RK1VHaz0A0tjixOBqApknXcYiST4eGI
         CtT6oZS+UsGeR6471krMaDkC7MIFPuSCOX+ElkDp5r1/0cjb1yAvCfvBMdHPQ9Q6x4ta
         NG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=TZhgT5gzN/QhZfE1otKiPDej1lzfZYbOzbi8m9YCzNk=;
        b=poq7el+195+cVXGCmUeEq5wNyXG3KXqpTTxNvitTb4PWDj6tpD/Csl7m4f0lr7OjiP
         s/t3t6tSroq3IjzueVbfHn+4rvbCpOMaRRJ2Ec/PtRdKuBacWv5msTsYdBdlHRRxFw+D
         TERYLkFsB4+DLHOC2eryidLXPmQpTzdKv6CBfc/DcJPM6W6Q3p4uSqolUdgfM+NM/Cla
         odDhx/1oJEJw09lb+KmI4z3aHZAPK1cLuR3nHvhP1pDq7aikpR2Anjzd1itaP3/t7oXh
         RF9nC6bTlZ5pWmvyEeZPHmpDcmTf6SCkYI+ULJCv8mLY6z1XJJnLhvC7EnhavP//royF
         DAmw==
X-Gm-Message-State: AGi0PuYst33zbKoh2wiIrxQQtWDjHxssqAxk5kiD1tjQPYhHX+vJGOhX
        OrOlURGgJHBJulQVO1mei54=
X-Google-Smtp-Source: APiQypI2Dw4REaEH3isPk9kUjxH01Os9b6g4OioUqeQskNSG8c/c8x97XaoId95X7kvG/IQrU79kDw==
X-Received: by 2002:a17:90a:ee90:: with SMTP id i16mr3079047pjz.165.1586762568561;
        Mon, 13 Apr 2020 00:22:48 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.22.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:22:48 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 03/15] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
Date:   Mon, 13 Apr 2020 15:30:12 +0800
Message-Id: <1586763024-12197-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
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
index 5794584..7b47a32 100644
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

