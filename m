Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497AF134C09
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgAHTtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43582 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730436AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006od-V3; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dmh-4L; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Catalin Marinas" <catalin.marinas@arm.com>
Date:   Wed, 08 Jan 2020 19:43:26 +0000
Message-ID: <lsq.1578512578.849336066@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 28/63] asm-generic: Fix local variable shadow in
 __set_fixmap_offset
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

From: Mark Rutland <mark.rutland@arm.com>

commit 3694bd76781b76c4f8d2ecd85018feeb1609f0e5 upstream.

Currently __set_fixmap_offset is a macro function which has a local
variable called 'addr'. If a caller passes a 'phys' parameter which is
derived from a variable also called 'addr', the local variable will
shadow this, and the compiler will complain about the use of an
uninitialized variable. To avoid the issue with namespace clashes,
'addr' is prefixed with a liberal sprinkling of underscores.

Turning __set_fixmap_offset into a static inline breaks the build for
several architectures. Fixing this properly requires updates to a number
of architectures to make them agree on the prototype of __set_fixmap (it
could be done as a subsequent patch series).

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
[catalin.marinas@arm.com: squashed the original function patch and macro fixup]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/asm-generic/fixmap.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -67,12 +67,12 @@ static inline unsigned long virt_to_fix(
 #endif
 
 /* Return a pointer with offset calculated */
-#define __set_fixmap_offset(idx, phys, flags)		      \
-({							      \
-	unsigned long addr;				      \
-	__set_fixmap(idx, phys, flags);			      \
-	addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1)); \
-	addr;						      \
+#define __set_fixmap_offset(idx, phys, flags)				\
+({									\
+	unsigned long ________addr;					\
+	__set_fixmap(idx, phys, flags);					\
+	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
+	________addr;							\
 })
 
 #define set_fixmap_offset(idx, phys) \

