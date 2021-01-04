Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C662EA125
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbhADXw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhADXwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:52:25 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E22C061793;
        Mon,  4 Jan 2021 15:51:43 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id p12so13902773qvj.13;
        Mon, 04 Jan 2021 15:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2E48a8501cvft0YkWjvJEBQif0+UmPCQbs5NE+bNygg=;
        b=tXg34Bi0XOseVJr5UoJacS8ykQjH116YS2PcHbFf7A4BNICd57eoM9GkkMapVESLEM
         0qyYb5kNnMdStYO1SumzKK9/kO7TfDnTgvLZkFLqCZ8GAAQYPTinJdAFvSXIvuO9tQ+c
         fr+xBOLaSwuDD6MTs3thEIEP7yz/7sWFtyWDg6mYOrL5y0ICYC/jZIYwuO9vxA1MHOTG
         LZvdoqgmGBu4SzNdlYvUu00yDNcEV85RQK1TZEO9t/jjoJuj0RN/10GKzCtzZDXq5UsV
         KspcFYbezhp5H0e1I3PCjWcFD1KYB6RkWU1S6TgRkUVIgbv4kH84H+Awx0uVy7clx8RU
         btOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2E48a8501cvft0YkWjvJEBQif0+UmPCQbs5NE+bNygg=;
        b=t9u3MexjSRGuKK8L99mlllQkun/bgpo9Sdou31IiIEC2equRjjcoSAUiwmwar0ggrZ
         Rzg2e8lfIl3Nt+2U8Ls9ywSs15F0UfrfIol+x36mX3x01k3lkPTat+BPYd2LAq1l+GJr
         TE6h81fmzOBxgGyaUYrqfgpuFDW3Pkswv3vDLmRRy5+N0cCoWja/5uIrNU6jAG1TuMwI
         W7o6zD2+6WoWzWvOGD7LMMlbCLbOwLmxz5UjsGcmsqkC8oRQzgBMm0UlDePRwYs070K1
         tx1bQ9E04ciKv9d5hgLhKhVCdCqTYI6F4IixYEgdpOtPwI2P+Y1UlRCFG1OLqkPYsd9E
         cpCA==
X-Gm-Message-State: AOAM533F2VVwqX+H6Xey5Gm9QjZOD9M4t71SShJU57Cie0Wsmwl3Qcc2
        KZ+F/dV2MxGJFwvog0z9IxiAfh4NGig=
X-Google-Smtp-Source: ABdhPJya+ZmAK68T/hIsH/3E7ve05TqDM/FCR3w6bx5agpPHLJHEg/P1bFvdRXc0DgqkFSXXIQ/bhg==
X-Received: by 2002:ad4:4a70:: with SMTP id cn16mr77948768qvb.38.1609794013571;
        Mon, 04 Jan 2021 13:00:13 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id v145sm15509352qka.27.2021.01.04.13.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 13:00:12 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] powerpc: Handle .text.{hot,unlikely}.* in linker script
Date:   Mon,  4 Jan 2021 13:59:53 -0700
Message-Id: <20210104205952.1399409-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104204850.990966-1-natechancellor@gmail.com>
References: <20210104204850.990966-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
change [1].

After another LLVM change [2], these sections are seen in some PowerPC
builds, where there is a orphan section warning then build failure:

$ make -skj"$(nproc)" \
       ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 O=out \
       distclean powernv_defconfig zImage.epapr
ld.lld: warning: kernel/built-in.a(panic.o):(.text.unlikely.) is being placed in '.text.unlikely.'
...
ld.lld: warning: address (0xc000000000009314) of section .text is not a multiple of alignment (256)
...
ERROR: start_text address is c000000000009400, should be c000000000008000
ERROR: try to enable LD_HEAD_STUB_CATCH config option
ERROR: see comments in arch/powerpc/tools/head_check.sh
...

Explicitly handle these sections like in the main linker script so
there is no more build failure.

[1]: https://reviews.llvm.org/D79600
[2]: https://reviews.llvm.org/D92493

Cc: stable@vger.kernel.org
Fixes: 83a092cf95f2 ("powerpc: Link warning for orphan sections")
Link: https://github.com/ClangBuiltLinux/linux/issues/1218
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Add missing [1] and [2] references in commit message. Thanks to Sedat
  Dilek for pointing it out!

 arch/powerpc/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 0318ba436f34..8e0b1298bf19 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -85,7 +85,7 @@ SECTIONS
 		ALIGN_FUNCTION();
 #endif
 		/* careful! __ftr_alt_* sections need to be close to .text */
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely .fixup __ftr_alt_* .ref.text);
+		*(.text.hot .text.hot.* TEXT_MAIN .text.fixup .text.unlikely .text.unlikely.* .fixup __ftr_alt_* .ref.text);
 #ifdef CONFIG_PPC64
 		*(.tramp.ftrace.text);
 #endif

base-commit: d8a4f20584d5906093a8fc6aa06622102a501095
-- 
2.30.0

