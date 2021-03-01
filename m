Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E22329127
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbhCAUUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242997AbhCAUNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E6065146;
        Mon,  1 Mar 2021 18:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621685;
        bh=hW9jx+tXgDRqClinkBqBIL1bxExMjasvygUxCycvrPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWfxxdu+BnCVX/EV0y3/X27GYWcwRT+cQzreWLisxgIjSKmG3UP3iXgETndtzFAPB
         YVkWN/e5oQqcLv4EdgMnq8uHCBNszTa7smAfLUEkenLp1jx5uPztNgHuSOoXcKgV9R
         ifOJ6CIpdSDpN4p2GHjsUUMjAduYp9Kq2UqvgmDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.11 607/775] MIPS: compressed: fix build with enabled UBSAN
Date:   Mon,  1 Mar 2021 17:12:55 +0100
Message-Id: <20210301161231.409683708@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit fc4cac4cfc437659ce445c3c47b807e1cc625b66 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -37,6 +37,7 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__AS
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT		:= n
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o


