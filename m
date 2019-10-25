Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2894CE5319
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbfJYSHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46772 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731425AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0008Oe-9L; Fri, 25 Oct 2019 19:05:36 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001j6-Nj; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>
Date:   Fri, 25 Oct 2019 19:03:21 +0100
Message-ID: <lsq.1572026582.905866993@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 20/47] s390: fix stfle zero padding
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 4f18d869ffd056c7858f3d617c71345cf19be008 upstream.

The stfle inline assembly returns the number of double words written
(condition code 0) or the double words it would have written
(condition code 3), if the memory array it got as parameter would have
been large enough.

The current stfle implementation assumes that the array is always
large enough and clears those parts of the array that have not been
written to with a subsequent memset call.

If however the array is not large enough memset will get a negative
length parameter, which means that memset clears memory until it gets
an exception and the kernel crashes.

To fix this simply limit the maximum length. Move also the inline
assembly to an extra function to avoid clobbering of register 0, which
might happen because of the added min_t invocation together with code
instrumentation.

The bug was introduced with commit 14375bc4eb8d ("[S390] cleanup
facility list handling") but was rather harmless, since it would only
write to a rather large array. It became a potential problem with
commit 3ab121ab1866 ("[S390] kernel: Add z/VM LGR detection"). Since
then it writes to an array with only four double words, while some
machines already deliver three double words. As soon as machines have
a facility bit within the fifth double a crash on IPL would happen.

Fixes: 14375bc4eb8d ("[S390] cleanup facility list handling")
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/facility.h | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -33,6 +33,18 @@ static inline int test_facility(unsigned
 	return __test_facility(nr, &S390_lowcore.stfle_fac_list);
 }
 
+static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
+{
+	register unsigned long reg0 asm("0") = size - 1;
+
+	asm volatile(
+		".insn s,0xb2b00000,0(%1)" /* stfle */
+		: "+d" (reg0)
+		: "a" (stfle_fac_list)
+		: "memory", "cc");
+	return reg0;
+}
+
 /**
  * stfle - Store facility list extended
  * @stfle_fac_list: array where facility list can be stored
@@ -52,13 +64,8 @@ static inline void stfle(u64 *stfle_fac_
 	memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
 	if (S390_lowcore.stfl_fac_list & 0x01000000) {
 		/* More facility bits available with stfle */
-		register unsigned long reg0 asm("0") = size - 1;
-
-		asm volatile(".insn s,0xb2b00000,0(%1)" /* stfle */
-			     : "+d" (reg0)
-			     : "a" (stfle_fac_list)
-			     : "memory", "cc");
-		nr = (reg0 + 1) * 8; /* # bytes stored by stfle */
+		nr = __stfle_asm(stfle_fac_list, size);
+		nr = min_t(unsigned long, (nr + 1) * 8, size * 8);
 	}
 	memset((char *) stfle_fac_list + nr, 0, size * 8 - nr);
 	preempt_enable();

