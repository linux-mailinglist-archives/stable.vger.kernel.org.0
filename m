Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF869134BB5
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgAHTqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43660 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730450AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oo-Bx; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnA-Cb; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ard Biesheuvel" <ard.biesheuvel@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Catalin Marinas" <catalin.marinas@arm.com>
Date:   Wed, 08 Jan 2020 19:43:32 +0000
Message-ID: <lsq.1578512578.835847224@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 34/63] arm64/kernel: fix incorrect EL0 check in
 inv_entry macro
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit b660950c60a7278f9d8deb7c32a162031207c758 upstream.

The implementation of macro inv_entry refers to its 'el' argument without
the required leading backslash, which results in an undefined symbol
'el' to be passed into the kernel_entry macro rather than the index of
the exception level as intended.

This undefined symbol strangely enough does not result in build failures,
although it is visible in vmlinux:

     $ nm -n vmlinux |head
                      U el
     0000000000000000 A _kernel_flags_le_hi32
     0000000000000000 A _kernel_offset_le_hi32
     0000000000000000 A _kernel_size_le_hi32
     000000000000000a A _kernel_flags_le_lo32
     .....

However, it does result in incorrect code being generated for invalid
exceptions taken from EL0, since the argument check in kernel_entry
assumes EL1 if its argument does not equal '0'.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -187,7 +187,7 @@ END(vectors)
  * Invalid mode handlers
  */
 	.macro	inv_entry, el, reason, regsize = 64
-	kernel_entry el, \regsize
+	kernel_entry \el, \regsize
 	mov	x0, sp
 	mov	x1, #\reason
 	mrs	x2, esr_el1

