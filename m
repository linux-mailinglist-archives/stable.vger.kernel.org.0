Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7492D3DD9F5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhHBOFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236432AbhHBOEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F4960F6D;
        Mon,  2 Aug 2021 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912666;
        bh=8zvqVIUxAYTQf9Rc1Ou8jx1vtmUSfXk5I0R+mY7D8R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVytvka4w/u7QT+eYeaBPNYpm/HdeZ73Z6lBRXWSZ/9yHwHgpKI1N87hfokfxAZ1f
         DneT7w5dAMrJ4PJ+ODvLFDyKCrX3Iwx8sYXIHVD6PuDTQ45AiJZC1k7vi2ULSxvo4f
         P9KWU6QYTc36wstAPJeSciwzFDXh7cz3Whe9wya4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 097/104] powerpc/vdso: Dont use r30 to avoid breaking Go lang
Date:   Mon,  2 Aug 2021 15:45:34 +0200
Message-Id: <20210802134347.193675104@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit a88603f4b92ecef9e2359e40bcb99ad399d85dd7 upstream.

The Go runtime uses r30 for some special value called 'g'. It assumes
that value will remain unchanged even when calling VDSO functions.
Although r30 is non-volatile across function calls, the callee is free
to use it, as long as the callee saves the value and restores it before
returning.

It used to be true by accident that the VDSO didn't use r30, because the
VDSO was hand-written asm. When we switched to building the VDSO from C
the compiler started using r30, at least in some builds, leading to
crashes in Go. eg:

  ~/go/src$ ./all.bash
  Building Go cmd/dist using /usr/lib/go-1.16. (go1.16.2 linux/ppc64le)
  Building Go toolchain1 using /usr/lib/go-1.16.
  go build os/exec: /usr/lib/go-1.16/pkg/tool/linux_ppc64le/compile: signal: segmentation fault
  go build reflect: /usr/lib/go-1.16/pkg/tool/linux_ppc64le/compile: signal: segmentation fault
  go tool dist: FAILED: /usr/lib/go-1.16/bin/go install -gcflags=-l -tags=math_big_pure_go compiler_bootstrap bootstrap/cmd/...: exit status 1

There are patches in flight to fix Go[1], but until they are released
and widely deployed we can workaround it in the VDSO by avoiding use of
r30.

Note this only works with GCC, clang does not support -ffixed-rN.

1: https://go-review.googlesource.com/c/go/+/328110

Fixes: ab037dd87a2f ("powerpc/vdso: Switch VDSO to generic C implementation.")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210729131244.2595519-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vdso64/Makefile |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/powerpc/kernel/vdso64/Makefile
+++ b/arch/powerpc/kernel/vdso64/Makefile
@@ -27,6 +27,13 @@ KASAN_SANITIZE := n
 
 ccflags-y := -shared -fno-common -fno-builtin -nostdlib \
 	-Wl,-soname=linux-vdso64.so.1 -Wl,--hash-style=both
+
+# Go prior to 1.16.x assumes r30 is not clobbered by any VDSO code. That used to be true
+# by accident when the VDSO was hand-written asm code, but may not be now that the VDSO is
+# compiler generated. To avoid breaking Go tell GCC not to use r30. Impact on code
+# generation is minimal, it will just use r29 instead.
+ccflags-y += $(call cc-option, -ffixed-r30)
+
 asflags-y := -D__VDSO64__ -s
 
 targets += vdso64.lds


