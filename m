Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAC288A1
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390968AbfEWT1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391266AbfEWT1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67882054F;
        Thu, 23 May 2019 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639659;
        bh=2C2QQ3bMoLYNqfonrJ8jPSLJoDzjfVJiXseepizVle8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeQ+JpKAFuk6XoL1OrR/+ylGCKAgk+Fhh96Xx70e/37UnvZd637Y7JnX2BY/4q4jb
         20njbi7qypjlFLBg9vHL8zfVBwupX102envTD1VwLTeixiPukGcRcI5bDKhXJGexBR
         X2Xk3Rfs14QZ/gFCzIQ76jYFO5Ub8Gfp6YrwjYCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.1 031/122] parisc: Use PA_ASM_LEVEL in boot code
Date:   Thu, 23 May 2019 21:05:53 +0200
Message-Id: <20190523181708.990957374@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit bdca5d64ee92abeacd6dada0bc6f6f8e6350dd67 upstream.

The LEVEL define clashed with the DRBD code.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/boot/compressed/head.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/boot/compressed/head.S
+++ b/arch/parisc/boot/compressed/head.S
@@ -22,7 +22,7 @@
 	__HEAD
 
 ENTRY(startup)
-	 .level LEVEL
+	 .level PA_ASM_LEVEL
 
 #define PSW_W_SM	0x200
 #define PSW_W_BIT       36
@@ -63,7 +63,7 @@ $bss_loop:
 	load32	BOOTADDR(decompress_kernel),%r3
 
 #ifdef CONFIG_64BIT
-	.level LEVEL
+	.level PA_ASM_LEVEL
 	ssm	PSW_W_SM, %r0		/* set W-bit */
 	depdi	0, 31, 32, %r3
 #endif
@@ -72,7 +72,7 @@ $bss_loop:
 
 startup_continue:
 #ifdef CONFIG_64BIT
-	.level LEVEL
+	.level PA_ASM_LEVEL
 	rsm	PSW_W_SM, %r0		/* clear W-bit */
 #endif
 


