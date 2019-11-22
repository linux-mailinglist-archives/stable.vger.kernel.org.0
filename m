Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9259106DDC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfKVLD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731478AbfKVLD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D90020659;
        Fri, 22 Nov 2019 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420638;
        bh=+cr+gRA2SshBODWMDln8Yq9d8VynUPdCUo4G0OSVzV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oj4joLBFDoPWalXV1qRw+YuQpuEfRpmHmYBUfjIBfZDsYM5r13CSRntaHdElwrVSF
         wXvwDDylMJMzG4rWLCm4vILtylH5kLPHqdeTmwa+9lJ352CGnEFY2lbJolOq0OgJAo
         YJUreaSnY1bsv4NhIBqBRn/SKjSFJzD9xmR6KsG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/220] s390/kasan: avoid instrumentation of early C code
Date:   Fri, 22 Nov 2019 11:28:53 +0100
Message-Id: <20191122100924.889563952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 0a9b40911baffac6fc9cc2d88e893585870a97f7 ]

Instrumented C code cannot run without the kasan shadow area. Exempt
source code files from kasan which are running before / used during
kasan initialization.

Reviewed-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/Makefile            | 1 +
 arch/s390/boot/compressed/Makefile | 1 +
 arch/s390/kernel/Makefile          | 2 ++
 drivers/s390/char/Makefile         | 1 +
 4 files changed, 5 insertions(+)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 9e6668ee93de8..f6a9b0c203553 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -6,6 +6,7 @@
 KCOV_INSTRUMENT := n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
+KASAN_SANITIZE := n
 
 KBUILD_AFLAGS := $(KBUILD_AFLAGS_DECOMPRESSOR)
 KBUILD_CFLAGS := $(KBUILD_CFLAGS_DECOMPRESSOR)
diff --git a/arch/s390/boot/compressed/Makefile b/arch/s390/boot/compressed/Makefile
index b375c6c5ae7b1..9b3d821e5b46e 100644
--- a/arch/s390/boot/compressed/Makefile
+++ b/arch/s390/boot/compressed/Makefile
@@ -8,6 +8,7 @@
 KCOV_INSTRUMENT := n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
+KASAN_SANITIZE := n
 
 obj-y	:= $(if $(CONFIG_KERNEL_UNCOMPRESSED),,head.o misc.o) piggy.o
 targets	:= vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index b205c0ff0b220..762fc45376ffd 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -23,6 +23,8 @@ KCOV_INSTRUMENT_early_nobss.o	:= n
 UBSAN_SANITIZE_early.o		:= n
 UBSAN_SANITIZE_early_nobss.o	:= n
 
+KASAN_SANITIZE_early_nobss.o	:= n
+
 #
 # Passing null pointers is ok for smp code, since we access the lowcore here.
 #
diff --git a/drivers/s390/char/Makefile b/drivers/s390/char/Makefile
index c6ab34f94b1b5..3072b89785ddf 100644
--- a/drivers/s390/char/Makefile
+++ b/drivers/s390/char/Makefile
@@ -11,6 +11,7 @@ endif
 GCOV_PROFILE_sclp_early_core.o		:= n
 KCOV_INSTRUMENT_sclp_early_core.o	:= n
 UBSAN_SANITIZE_sclp_early_core.o	:= n
+KASAN_SANITIZE_sclp_early_core.o	:= n
 
 CFLAGS_sclp_early_core.o		+= -D__NO_FORTIFY
 
-- 
2.20.1



