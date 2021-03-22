Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6E344269
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhCVMl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhCVMjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 693D1619A8;
        Mon, 22 Mar 2021 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416709;
        bh=2VYa52osbzQu2YvZGVufAoYT2MTK455F0ufVCJ8pk+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+CGmQAVvsqeZJzipUO8ytNhXblZSLwt5FJPHJQ7uUza3eFnsnE9KQEXa5aX2+GrA
         P9ppj9Urt99oPR7mAejVDd6qXYCaZO7sF7ZMQCubxNbXlkwHh/lAgb3r9njrXvexOU
         9P9kdfSHlOo4CzuZ13s5ckgZnGiAnxwOK1QqL8ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/157] MIPS: compressed: fix build with enabled UBSAN
Date:   Mon, 22 Mar 2021 13:27:27 +0100
Message-Id: <20210322121936.636241778@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit fc4cac4cfc437659ce445c3c47b807e1cc625b66 ]

Commit 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer
UBSAN") added a possibility to build the entire kernel with UBSAN
instrumentation for MIPS, with the exception for VDSO.
However, self-extracting head wasn't been added to exceptions, so
this occurs:

mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
in function `FSE_buildDTable_wksp':
decompress.c:(.text.FSE_buildDTable_wksp+0x278): undefined reference
to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2a8):
undefined reference to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2c4):
undefined reference to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
decompress.c:(.text.FSE_buildDTable_raw+0x9c): more undefined references
to `__ubsan_handle_shift_out_of_bounds' follow

Add UBSAN_SANITIZE := n to mips/boot/compressed/Makefile to exclude
it from instrumentation scope and fix this issue.

Fixes: 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer UBSAN")
Cc: stable@vger.kernel.org # 5.0+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index d66511825fe1..337ab1d18cc1 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -36,6 +36,7 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT		:= n
+UBSAN_SANITIZE := n
 
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o
-- 
2.30.1



