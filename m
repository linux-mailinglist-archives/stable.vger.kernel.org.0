Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA74D28938
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391847AbfEWTbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403841AbfEWTbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:31:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B642186A;
        Thu, 23 May 2019 19:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639882;
        bh=bazesv1zlSbhV7hBl7cRwPHNDrdniWGCiApnCNuxURc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAepko/joRL5VIrpsCpIZqZ37DhZdU/80iezQtMendrw9IrxfVDYkUt/pJiRdBfHB
         JJDYPpNz3uYcuo0XNNUszrbVMD+ax0scZIMugW07uTiLd/dSbeIYJP7cv3Bpddf2EI
         JUxdi+NuPIZ+iwNceiFU3nAIlkDXp/W60ThZLJjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joseph Myers <joseph@codesourcery.com>,
        libc-alpha@sourceware.org, linux-api@vger.kernel.org,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Lukasz Majewski <lukma@denx.de>,
        Stepan Golosunov <stepan@golosunov.pp.ru>
Subject: [PATCH 5.1 119/122] y2038: Make CONFIG_64BIT_TIME unconditional
Date:   Thu, 23 May 2019 21:07:21 +0200
Message-Id: <20190523181721.342941070@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f3d964673b2f1c5d5c68c77273efcf7103eed03b upstream.

As Stepan Golosunov points out, there is a small mistake in the
get_timespec64() function in the kernel. It was originally added under the
assumption that CONFIG_64BIT_TIME would get enabled on all 32-bit and
64-bit architectures, but when the conversion was done, it was only turned
on for 32-bit ones.

The effect is that the get_timespec64() function never clears the upper
half of the tv_nsec field for 32-bit tasks in compat mode. Clearing this is
required for POSIX compliant behavior of functions that pass a 'timespec'
structure with a 64-bit tv_sec and a 32-bit tv_nsec, plus uninitialized
padding.

The easiest fix for linux-5.1 is to just make the Kconfig symbol
unconditional, as it was originally intended. As a follow-up, the #ifdef
CONFIG_64BIT_TIME can be removed completely..

Note: for native 32-bit mode, no change is needed, this works as
designed and user space should never need to clear the upper 32
bits of the tv_nsec field, in or out of the kernel.

Fixes: 00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Joseph Myers <joseph@codesourcery.com>
Cc: libc-alpha@sourceware.org
Cc: linux-api@vger.kernel.org
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Lukasz Majewski <lukma@denx.de>
Cc: Stepan Golosunov <stepan@golosunov.pp.ru>
Link: https://lore.kernel.org/lkml/20190422090710.bmxdhhankurhafxq@sghpc.golosunov.pp.ru/
Link: https://lkml.kernel.org/r/20190429131951.471701-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -764,7 +764,7 @@ config COMPAT_OLD_SIGACTION
 	bool
 
 config 64BIT_TIME
-	def_bool ARCH_HAS_64BIT_TIME
+	def_bool y
 	help
 	  This should be selected by all architectures that need to support
 	  new system calls with a 64-bit time_t. This is relevant on all 32-bit


