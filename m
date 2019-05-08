Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE331808D
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 21:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfEHTiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 15:38:05 -0400
Received: from pbmsgap01.intersil.com ([192.157.179.201]:35184 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfEHTiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 15:38:04 -0400
X-Greylist: delayed 2290 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 15:38:04 EDT
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.27/8.16.0.27) with SMTP id x48Ir5jJ025711
        for <stable@vger.kernel.org>; Wed, 8 May 2019 14:59:53 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 2s96903rr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 08 May 2019 14:59:53 -0400
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Wed, 8 May 2019 14:59:52 -0400
Received: from localhost.localdomain (132.158.202.108) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server id
 15.1.1531.3 via Frontend Transport; Wed, 8 May 2019 14:59:51 -0400
From:   Chris Brandt <chris.brandt@renesas.com>
To:     <stable@vger.kernel.org>
CC:     Chris Brandt <chris.brandt@renesas.com>
Subject: [PATCH] ARM: 8680/1: boot/compressed: fix inappropriate Thumb2 mnemonic for __nop
Date:   Wed, 8 May 2019 13:59:51 -0500
Message-ID: <20190508185951.41148-1-chris.brandt@renesas.com>
X-Mailer: git-send-email 2.16.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080115
X-Proofpoint-Spam-Reason: mlx
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 60ce2858514ed9ccaf00dc7e9f4dc219537e9855 ]

Commit 06a4b6d009a1 ("ARM: 8677/1: boot/compressed: fix decompressor
header layout for v7-M") fixed an issue in the layout of the header
of the compressed kernel image that was caused by the assembler
emitting narrow opcodes for 'mov r0, r0', and for this reason, the
mnemonic was updated to use the W() macro, which will append the .w
suffix (which forces a wide encoding) if required, i.e., when building
the kernel in Thumb2 mode.

However, this failed to take into account that on Thumb2 kernels built
for CPUs that are also ARM capable, the entry point is entered in ARM
mode, and so the instructions emitted here will be ARM instructions
that only exist in a wide encoding to begin with, which is why the
assembler rejects the .w suffix here and aborts the build with the
following message:

  head.S: Assembler messages:
  head.S:132: Error: width suffixes are invalid in ARM mode -- `mov.w r0,r0'

So replace the W(mov) with separate ARM and Thumb2 instructions, where
the latter will only be used for THUMB2_ONLY builds.

Fixes: 06a4b6d009a1 ("ARM: 8677/1: boot/compressed: fix decompressor ...")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
---

For the 4.9.x tree, commit 7b5407843691 was applied, but that caused
an issue for CONFIG_THUMB2 builds as you can see in the commit
message above.

Therefore, this upstream fix (that came 2 weeks later) is also required
in the 4.9.x tree to make it build again.
---
 arch/arm/boot/compressed/efi-header.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index 3f7d1b74c5e0..a17ca8d78656 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -17,7 +17,8 @@
 		@ there.
 		.inst	'M' | ('Z' << 8) | (0x1310 << 16)   @ tstne r0, #0x4d000
 #else
-		W(mov)	r0, r0
+ AR_CLASS(	mov	r0, r0		)
+  M_CLASS(	nop.w			)
 #endif
 		.endm
 
-- 
2.16.1

