Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F232C0BF1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgKWNdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKWMZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:25:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F0C2076E;
        Mon, 23 Nov 2020 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134334;
        bh=9TNSILEiZYYklOtuCxbobqHGVG427ZMFU/vmbkl3gqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxLUe7lMivdlRl/B7V3OHdQ/3TqQgyy+1zm82iNFtsPjpBS7sBsTi1snFY4ePkFke
         1JkGZGXfbp+Zui+41E9IdbwFABfCaykXO1Wb5zuVxx45wcJ0L2xGNodIptgZ3j9kaZ
         Kw9B1li1sPN7JXpyYfHh+sdQYodma/B0BTiRPJYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4.9 34/47] powerpc/uaccess-flush: fix missing includes in kup-radix.h
Date:   Mon, 23 Nov 2020 13:22:20 +0100
Message-Id: <20201123121807.210505651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

Guenter reports a build failure on cell_defconfig and maple_defconfg:

In file included from arch/powerpc/include/asm/kup.h:10:0,
		 from arch/powerpc/include/asm/uaccess.h:12,
		 from arch/powerpc/lib/checksum_wrappers.c:24:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean
‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
			      ^~~~~~~~~~~~~~~~~
			      do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors

This is because I failed to include linux/jump_label.h in kup-radix.h. Include it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H
 #define _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H
+#include <linux/jump_label.h>
 
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 


