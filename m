Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE53044160C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhKAJV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhKAJV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED89610A2;
        Mon,  1 Nov 2021 09:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758336;
        bh=RMhknKR+MnZX1z2g3wT+ecbzpg5j0QCQpcLX/edj4ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2g6T4wOgL73E3mLdsxve3jPmkBXaAjamzjbFE9TiTXGLDnvd1RFyn2FOjgWvOUMX
         rG4vJ8u1jkcSnTs+M62Nm9e1YkG2q1QTzzJhmnc2h24X3RP6/GOZCSYe1XJvyWtdCF
         g5YCMj6cre/ok2CZIpElFdnmATc11LQG/fFJ2K7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.4 03/17] ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype
Date:   Mon,  1 Nov 2021 10:17:06 +0100
Message-Id: <20211101082441.446779610@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
References: <20211101082440.664392327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 1f323127cab086e4fd618981b1e5edc396eaf0f4 upstream.

With extra warnings enabled, gcc complains about this function
definition:

arch/arm/probes/kprobes/core.c: In function 'arch_init_kprobes':
arch/arm/probes/kprobes/core.c:465:12: warning: old-style function definition [-Wold-style-definition]
  465 | int __init arch_init_kprobes()

Link: https://lore.kernel.org/all/20201027093057.c685a14b386acacb3c449e3d@kernel.org/

Fixes: 24ba613c9d6c ("ARM kprobes: core code")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/probes/kprobes/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -666,7 +666,7 @@ static struct undef_hook kprobes_arm_bre
 
 #endif /* !CONFIG_THUMB2_KERNEL */
 
-int __init arch_init_kprobes()
+int __init arch_init_kprobes(void)
 {
 	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL


