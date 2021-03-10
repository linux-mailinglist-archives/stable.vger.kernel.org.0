Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB505333DB3
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhCJNYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhCJNYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8227D64FDA;
        Wed, 10 Mar 2021 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382657;
        bh=cfD1P8CGtyw8lKVkpK4hcIzouL4RqZsCpWZlx6d2iTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlZk1W0MlmRpp2cDcIncdQaMJ62ZKa7QTeW2KXUN+oJ9uqKc7BfOr8iuE7KPejzBp
         tFYkX+j6hYNFpcnBccmpGnb7XV5cDKadXvaUJCL9cn+86pLp++bKwdQP8DRjK1bcZZ
         fCkwU6ZzExEuWKSWvhrVANTEQcN4pLcmFzRSE+zo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.11 13/36] parisc: Enable -mlong-calls gcc option with CONFIG_COMPILE_TEST
Date:   Wed, 10 Mar 2021 14:23:26 +0100
Message-Id: <20210310132320.937139154@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Helge Deller <deller@gmx.de>

commit 778e45d7720d663811352943dd515b41f6849637 upstream

The kernel test robot reported multiple linkage problems like this:

    hppa64-linux-ld: init/main.o(.init.text+0x56c): cannot reach printk
    init/main.o: in function `unknown_bootoption':
    (.init.text+0x56c): relocation truncated to fit: R_PARISC_PCREL22F against
	symbol `printk' defined in .text.unlikely section in kernel/printk/printk.o

There are two ways to solve it:
a) Enable the -mlong-call compiler option (CONFIG_MLONGCALLS),
b) Add long branch stub support in 64-bit linker.

While b) is the long-term solution, this patch works around the issue by
automatically enabling the CONFIG_MLONGCALLS option when
CONFIG_COMPILE_TEST is set, which indicates that a non-production kernel
(e.g. 0-day kernel) is built.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 00e35f2b0e8a ("parisc: Enable -mlong-calls gcc option by default when !CONFIG_MODULES")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -201,9 +201,12 @@ config PREFETCH
 	def_bool y
 	depends on PA8X00 || PA7200
 
+config PARISC_HUGE_KERNEL
+	def_bool y if !MODULES || UBSAN || FTRACE || COMPILE_TEST
+
 config MLONGCALLS
-	def_bool y if !MODULES || UBSAN || FTRACE
-	bool "Enable the -mlong-calls compiler option for big kernels" if MODULES && !UBSAN && !FTRACE
+	def_bool y if PARISC_HUGE_KERNEL
+	bool "Enable the -mlong-calls compiler option for big kernels" if !PARISC_HUGE_KERNEL
 	depends on PA8X00
 	help
 	  If you configure the kernel to include many drivers built-in instead


