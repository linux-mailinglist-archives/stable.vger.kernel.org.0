Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC66F4BBA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfKHMgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKHMgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:14 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76603222D1;
        Fri,  8 Nov 2019 12:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216573;
        bh=nYbH7ai0svh3IJ+d+tWPxdVI70VLpcJYJy041VKCj5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2jwbfUNBojKtgp1anSTCzXjtNYa+g9hC9cXYjj2USLTY2XtQxXpJWmx1Hz4WjgWs
         isrSVqKak7XbqxDXJ6wHHV740/w2zF4MJoo6NseIbEOCn462BuHqG8bzHMdbR6Vzdt
         9npIOaMg1HoA9vAGkUG7io6ExAGimW/u4QZe5PLM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 01/50] ARM: 8051/1: put_user: fix possible data corruption in put_user
Date:   Fri,  8 Nov 2019 13:35:05 +0100
Message-Id: <20191108123554.29004-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <a.ryabinin@samsung.com>

Commit 537094b64b229bf3ad146042f83e74cf6abe59df upstream.

According to arm procedure call standart r2 register is call-cloberred.
So after the result of x expression was put into r2 any following
function call in p may overwrite r2. To fix this, the result of p
expression must be saved to the temporary variable before the
assigment x expression to __r2.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index cd8b589111ba..35c9db857ebe 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -251,7 +251,7 @@ extern int __put_user_8(void *, unsigned long long);
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		const typeof(*(p)) __user *__tmp_p = (p);		\
-		register typeof(*(p)) __r2 asm("r2") = (x);	\
+		register const typeof(*(p)) __r2 asm("r2") = (x);	\
 		register const typeof(*(p)) __user *__p asm("r0") = __tmp_p; \
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
-- 
2.20.1

