Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFEE2EA13A
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 01:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbhAEAAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 19:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbhAEAAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 19:00:02 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF19CC061574;
        Mon,  4 Jan 2021 15:59:22 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id c7so25143675qke.1;
        Mon, 04 Jan 2021 15:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0deU4ENrLoy0KwklsESPgFxyWQtFjK1GDUDq1gySRsA=;
        b=BTViVEkrUqTtllVnsO10h/CjecoikEpshx6In+fY9q6WMvlZF3OS427DrfNlHm3A5F
         wdlgln+WMqHKePUMvDs/Sm8pXi3gikpZPy1t1rrkuYzWWdb7vksCVr7NPTyIA2qgROiJ
         U6kb/0bc+BL4pQDdGhvq+ag87Sha61speYCodnq4Pfh57f66HQzyj0YQulaNo66g8hl8
         GFAiVcICix1h8/6ZyE3M6zbNRaUd1q65L6kzFAo72UHMbHfdqvUcsJdflbjIctxS6Y0O
         +Sa1cyA+DTvY5Ix9Q/Ha3DUCkGjY2tbiaq2feGfrI9vBbvge8TTwJ0BmvFKAyP7dreA/
         6Upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0deU4ENrLoy0KwklsESPgFxyWQtFjK1GDUDq1gySRsA=;
        b=FCmX03n5SU42Ri8FHxrJOQAfOFFcHLoxPPA/U3Q/oREQdVOgXrvaJav95md6Un2HNH
         fsix4pXyrIIGkQFPWwPVRmqp0KYcFWmp2C4DptQnArc4GVrvgm3lvJDOFaA362tyD3Cs
         GN9fxaqMsCR19Ma5kaMLHwEbEYbrI2rnuMIgUtp2/miF2nSJD/Nl+oob3y3hC8FQ0Kr4
         /jybBFEgjpD663R9IpqCp92XsZmzm0jC2iGllDK/y9ENZVGiZgXOr7z3OdZp5URnpNiY
         CKoGqZX6SNxcWnZJFMohG31zukyronfGtTVykFiahG7qnzHseuGWkcEZnc/rqmu7D3Vz
         jSrQ==
X-Gm-Message-State: AOAM532sSnMMq7Yf9JXnimYLtpJ4vqDHn/yCfbkNpbAQWhiLqVyGb4No
        lehrMAg6cN2TMU3d9qPCZ+HAd8cbutU=
X-Google-Smtp-Source: ABdhPJxLhujl9v1O5kK81SPDwZg7ZK3IiWRfLmVVM45eg90+xFyPS7+k9HKJACZzfNwa615aZe29lA==
X-Received: by 2002:ac8:5956:: with SMTP id 22mr73233053qtz.63.1609793348136;
        Mon, 04 Jan 2021 12:49:08 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id c136sm27688101qkg.71.2021.01.04.12.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:49:07 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] powerpc: Handle .text.{hot,unlikely}.* in linker script
Date:   Mon,  4 Jan 2021 13:48:50 -0700
Message-Id: <20210104204850.990966-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.30.0
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

Cc: stable@vger.kernel.org
Fixes: 83a092cf95f2 ("powerpc: Link warning for orphan sections")
Link: https://github.com/ClangBuiltLinux/linux/issues/1218
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
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

