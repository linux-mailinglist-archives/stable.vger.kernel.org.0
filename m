Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8D96C663
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403906AbfGRDPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391972AbfGRDPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:12 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B668821851;
        Thu, 18 Jul 2019 03:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419712;
        bh=jY1uNb29JuAHey2oC14DUoyYA1XrOaBi+7fcKeyogOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybvrKRAAlQEE84ERjiBbdM7ahJZqgBc47hi+UY5bBVrP82HwtfKRbIvrcNvDfEnfZ
         z00nQfqkx3AjgJkYX0dVvp7sojUfreNiz86SvhLVmjl3wfSACfrpO9w0tHyy+DGL0c
         FkWtWvg/dsgT7FFVm1fecpNgeUGp5sqlIDRWDDAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 4.4 37/40] s390: fix stfle zero padding
Date:   Thu, 18 Jul 2019 12:02:33 +0900
Message-Id: <20190718030050.315217243@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # v2.6.37+
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/facility.h |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -51,6 +51,18 @@ static inline int test_facility(unsigned
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
@@ -70,13 +82,8 @@ static inline void stfle(u64 *stfle_fac_
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


