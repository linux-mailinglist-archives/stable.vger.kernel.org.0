Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE61C13EF
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbgEANeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730531AbgEANeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF307208DB;
        Fri,  1 May 2020 13:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340053;
        bh=iyB7jYnakYPDqumcyEXSoel5QyTvyXki8tVZ+K2WuzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXcnLLuYL2IDLAMWSmqcupXt9xg46wrErx04ZixMgXB38sv7MbvMefrc0n8IfwgRE
         wS6TkvWjN3i+QAwxDM9N7KAgmB/oVRtcRfB9OcEblNVnR4PAunRcbRo94lLvoVWh+S
         7yAbWC8FWHwh+STmJ/xlycAhY36iToBeluTZS0a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yury Norov <yury.norov@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 087/117] include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap
Date:   Fri,  1 May 2020 15:22:03 +0200
Message-Id: <20200501131555.017804314@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 467d12f5c7842896d2de3ced74e4147ee29e97c8 upstream.

QEMU has a funny new build error message when I use the upstream kernel
headers:

      CC      block/file-posix.o
    In file included from /home/cborntra/REPOS/qemu/include/qemu/timer.h:4,
                     from /home/cborntra/REPOS/qemu/include/qemu/timed-average.h:29,
                     from /home/cborntra/REPOS/qemu/include/block/accounting.h:28,
                     from /home/cborntra/REPOS/qemu/include/block/block_int.h:27,
                     from /home/cborntra/REPOS/qemu/block/file-posix.c:30:
    /usr/include/linux/swab.h: In function `__swab':
    /home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:34: error: "sizeof" is not defined, evaluates to 0 [-Werror=undef]
       20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
          |                                  ^~~~~~
    /home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:41: error: missing binary operator before token "("
       20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
          |                                         ^
    cc1: all warnings being treated as errors
    make: *** [/home/cborntra/REPOS/qemu/rules.mak:69: block/file-posix.o] Error 1
    rm tests/qemu-iotests/socket_scm_helper.o

This was triggered by commit d5767057c9a ("uapi: rename ext2_swab() to
swab() and share globally in swab.h").  That patch is doing

  #include <asm/bitsperlong.h>

but it uses BITS_PER_LONG.

The kernel file asm/bitsperlong.h provide only __BITS_PER_LONG.

Let us use the __ variant in swap.h

Link: http://lkml.kernel.org/r/20200213142147.17604-1-borntraeger@de.ibm.com
Fixes: d5767057c9a ("uapi: rename ext2_swab() to swab() and share globally in swab.h")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/swab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -135,9 +135,9 @@ static inline __attribute_const__ __u32
 
 static __always_inline unsigned long __swab(const unsigned long y)
 {
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 	return __swab64(y);
-#else /* BITS_PER_LONG == 32 */
+#else /* __BITS_PER_LONG == 32 */
 	return __swab32(y);
 #endif
 }


