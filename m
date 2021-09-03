Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA93FFB77
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 10:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348105AbhICICA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 04:02:00 -0400
Received: from mout.gmx.net ([212.227.17.21]:36817 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348069AbhICIB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 04:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1630656050;
        bh=kWncfL8ub8fyucS67Ie17YSILaF9USMducD/IDECB5s=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=eSlINVWBucKZn02pYRzSHVWh1duPLOmGnUlQFJqXoBRhU5hMr1fWtL0Io6vg987+b
         O78Y1ktitqKZIa0rz+QovcEoG/GhJ+N8Jvati9niL2pL3uRldBkOL2bqj6f4brk3gQ
         n803WA04f/sTK1+v0omKyXXNHWYRg1Jjp1Ms9o1U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530.fritz.box ([92.116.183.73]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MNKlu-1mbw3E2sZO-00OnI0; Fri, 03
 Sep 2021 10:00:50 +0200
From:   Helge Deller <deller@gmx.de>
To:     linux-parisc@vger.kernel.org
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        Arnd Bergmann <arnd@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] parisc: Fix unaligned-access crash in bootloader
Date:   Fri,  3 Sep 2021 10:00:45 +0200
Message-Id: <20210903080045.1048500-1-deller@gmx.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pG1Nvoo6oDHXdISfv6u1nerCh9rslBvUKNUgc9oUytx1xc5yTeh
 u3OdREPadsK7XDtqg5lWlydVajlEhIuLty/r9SamORcFiwgwUVlWwucqeS6xBIB6pIJ8Nkk
 vfy0kElrcOvjlfFUcbZlT16LfXNs1xyO70zuvV3OE92S/VPvVBTNNRdyftrXlVPdmBkHoaj
 GL0lHVeHMBnQFeM4ov66g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:70SGwaMbBkM=:9FmaDo1kuv9ZcRdPtSpm8P
 UzYRp91HKy8cjr+fdt8JSTvP9+TwGHwOXRbrWOgH90Zl5or4He8LbH+pVm09gqNtgekjl6Mdu
 2IqfMfOmQ31yXjgdQUe1nlft8J1wTQ1di1z74B4j/32Hnl2x8aZQb4mDs6z00GfIHCOq89jMx
 wqBUcu/yR0iwWHiwWg92/PsI44s/qqVnc+2V00uKIj1x1iblQTbh1bATl1uC3CYUERubJx3jJ
 9UsZROq55GjwQ5RmtJDmxq4eoA3lRLPrSBSWtjrfUvUR2AMtbznNEGD34FcmiqtdYjMywZ/NM
 Y+qJ/b5rbQu8UWvR6zTuWuoq9A6IwdqPsBjrdRW69I52BOzZ7E3AY3h53ybGJys3rMDXsKoEP
 HsyGuKudGauZmOU9MEsEj6lLyMsaCigLBKYe61mc1MB/O+r4t1BToebMq498FSw+XlJECu1M2
 Z5UzzHF1o+tOLZIfsHXf1wwVPKWunEz4Nh+tpciK49GqSAoHdyyuziIaJUBkNhXJDPx58Qsom
 d0P4rvMCftCICWz+L0lAQyDn3a8v7ffXo9isB5qo1CpaPdm/M3QZIGVyM/cf3F2mqTlb8JRQa
 yEQ+nd6eGIS94m26L9N4ZGVXtkPxd+lSElNHG/5LGVjf1RLAF5jK+e7mAobA1fXtaDQ2Z12/Z
 +NEQSFalEogOUehYqVzX+hCoL4hP3XLYdlZfVuDX7HRoTdrTCjf1BMp+xf50W9zt8d/YeDYAE
 3zsKbVxFffrkMxeOol4ciJt7OYTtOKCK4xHPLkDZM7G2BV0ikJvTTmKpeIZNMIl1iX4mwntNj
 7anXWPK5wR/RCJJvIFPV6djLc1xPJHOq+UPc2AYMmVCqOexTbwZvV/qAd0zZYb3R84bY29++I
 89HbsYKXSvkm/4kPGOsE20XNVzd0Gx+G4DJSBWbc/sKfoL7F7K+i30cipRzYn7iAFRAU2AUoR
 xm1/zlkfHZ+CpZK+TEYw33+fZvbqktvQzek6+o3KLHuNCO48c1Lg+/pNxwKBHl4PSJ0PFV5Rp
 MA5TTgA095nVs2rllMhGTfP060V/Umwir71t/CIluDiA5tyusewpsCSYAWQzk8x21cILUWyoX
 kZl735nxdksmmBtyquOPBscWPj3yREgzogX
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel v5.14 has various changes to optimize unaligned memory accesses,
e.g. commit 0652035a5794 ("asm-generic: unaligned: remove byteshift helper=
s").

Those changes triggered an unalignment-exception and thus crashed the
bootloader on parisc because the unaligned "output_len" variable now sudde=
nly
was read word-wise while it was read byte-wise in the past.

Fix this issue by declaring the external output_len variable as char which=
 then
forces the compiler to generate byte-accesses.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: John David Anglin <dave.anglin@bell.net>
Bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D102162
Fixes: 8c031ba63f8f ("parisc: Unbreak bootloader due to gcc-7 optimization=
s")
Fixes: 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers")
Cc: <stable@vger.kernel.org> # v5.14+
=2D--
 arch/parisc/boot/compressed/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/boot/compressed/misc.c b/arch/parisc/boot/compres=
sed/misc.c
index 2d395998f524..7ee49f5881d1 100644
=2D-- a/arch/parisc/boot/compressed/misc.c
+++ b/arch/parisc/boot/compressed/misc.c
@@ -26,7 +26,7 @@
 extern char input_data[];
 extern int input_len;
 /* output_len is inserted by the linker possibly at an unaligned address =
*/
-extern __le32 output_len __aligned(1);
+extern char output_len;
 extern char _text, _end;
 extern char _bss, _ebss;
 extern char _startcode_end;
=2D-
2.31.1

