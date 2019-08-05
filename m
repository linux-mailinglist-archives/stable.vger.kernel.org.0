Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9648B81CB0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfHEN0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731342AbfHEN0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:26:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D9D20644;
        Mon,  5 Aug 2019 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011559;
        bh=p9NISWgc3vG+Xuv8urSislGFgOzD+18Gd+8cTb9s/U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f69h7D1FoABWwZMnCCz7GEKJf/hKErEbgtWQFYPAmUfDn5yxpHyHn9Og/p6p54S9m
         p2B5MlLoVJVMyHvL9aykGTxMr6cm1Cc0rg3ZIcGIEUkEtnWJtRNkcossnEh08MqVgX
         XqJ/XKg/AcJzi3G1F5JtW9NXibd4YMxfdqbhWSxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.2 108/131] parisc: Add archclean Makefile target
Date:   Mon,  5 Aug 2019 15:03:15 +0200
Message-Id: <20190805124959.196052331@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit f2c5ed0dd5004c2cff5c0e3d430a107576fcc17f upstream.

Apparently we don't have an archclean target in our
arch/parisc/Makefile, so files in there never get cleaned out by make
mrproper.  This, in turn means that the sizes.h file in
arch/parisc/boot/compressed never gets removed and worse, when you
transition to an O=build/parisc[64] build model it overrides the
generated file.  The upshot being my bzImage was building with a SZ_end
that was too small.

I fixed it by making mrproper clean everything.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Makefile                 |    3 +++
 arch/parisc/boot/compressed/Makefile |    1 +
 2 files changed, 4 insertions(+)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -164,5 +164,8 @@ define archhelp
 	@echo  '  zinstall	- Install compressed vmlinuz kernel'
 endef
 
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/parisc/kernel/syscalls all
--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -12,6 +12,7 @@ UBSAN_SANITIZE := n
 targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2
 targets += vmlinux.bin.xz vmlinux.bin.lzma vmlinux.bin.lzo vmlinux.bin.lz4
 targets += misc.o piggy.o sizes.h head.o real2.o firmware.o
+targets += real2.S firmware.c
 
 KBUILD_CFLAGS := -D__KERNEL__ -O2 -DBOOTLOADER
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING


