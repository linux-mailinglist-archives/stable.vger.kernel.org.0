Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E5944F59C
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 23:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhKMWKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 17:10:10 -0500
Received: from mout.gmx.net ([212.227.15.19]:36933 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbhKMWKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 17:10:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1636841235;
        bh=ExFbZ5rar+b+dar4FNotrFLYrEbQbGRgAnAAcCvhm8I=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=fA42ZKaA7xG+Ln9iQfwUuzYHd4fQsDn+cYvyy3llF4s7t5t+csTNuUslyTdL88b/u
         axKbu8Ensyl+0AFZjXthSgaOSAe87NuhaujpcusBWUPGBcT9zqRhRwpZulTkiRF3Kj
         Icy8+WTJ2XgD1AomUifSr+ZmBr0jgxKRmxytCA98=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530 ([92.116.168.126]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqaxO-1mHJ470XoG-00md8y; Sat, 13
 Nov 2021 23:07:15 +0100
Date:   Sat, 13 Nov 2021 23:06:43 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH] parisc: Fix set_fixmap() on PA1.x CPUs
Message-ID: <YZA28xGM65x4H33o@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:hWhnlOr3eug2OuAsOs8kEu/6EPUL/lldp++Z1jGY9ERDUolD230
 urwyZJbxxlC0XBkPw4gsB0ob7Oe4/Hb+f1/VW6ZA0kPLQYKj2Ge8Nt3Ta9U9RX2zoY8/jbL
 +xFRFBA+S42vuVtasHPDuuJhDYPXhf/QqWyGkupE0+u6ig5QqA09c32LWXwvhq3rSIWxrWn
 LOaC9dLIADBr/ZQuEHGKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+1dGmOEWFEQ=:JQ+1RBzNLeIpdFeaEC1cdF
 itJop52Zz9HPo4k17h5tUq8N7tWQtwcVdMH7FU4dab+uNW3YP/K4sePYwB36G4xVIUVG+/me1
 8j/zoL80p5gjEWlS6+L4WRb8v1zP74hByThzuTAPDZgXMZ12ctimmE5c/jYvqXb6twwhY+23L
 Xly7pfKYvTpF3c6sCCX9uxC1pLoSJ01wrQ/RIB06U+sXdIUs/5eQ33nSePZhWXcaDplhRLsyT
 c+fKToClR5GwtKvRC5V0Wr10gZMSAzgIKLzTOiApdKnydafGKaXW8hEPH/BbveKRGpW+LQu6j
 WVsZfX+Z0KCJr9xR2anw4A+R0TX3sfnLgpPT246yeJJbnmHnnd1AKWkJQQF0vV+j/CY9dhZaZ
 1meuLWF2uW7JKk6Gy1qQmpgJOwr1Hexv5suXJOx/3SpfFWvPe/VVEU2jwsqM9Wul2SRqj9O30
 l9Cwls8QBcT2qUelg3T+zym2uA5aJ4sxnncOAukO5a2gXIvF7pyU322OXWUxEwuyhdQ00rMRl
 a0r9T1MrAp3D7J+wkQcfOL7TUVEkGvkS8our1+7q4h1BvmSdict1cMS/x0yOS1UVIElZzWz3x
 BR5cPDSM9+iW6sEFFXEjtzaiWMv3CyeL3/peRefd/HJ1IV0mBaQQFADGdvY856sauBKV2O3Sy
 pJRDBTDp5RWlnCc4CB6taQBWxLiXAMRcTTq31OsB7tneBv9/Ajw1FTQQXdrHoxXhfFQUrPGlg
 JRmjrZs+AaTI91rizAb7MQOxfs69chZgpqn5HZMA9kX2QVjqhk7h0STX2K0djlqF7iiMbL1UY
 wRhPCIJLxji5uL5dK/RQB4Czlg2LrmBB1Yy05PRT14DfX85TheTdZclM2J4jg2OTdn9Wd4hrG
 9lvXqPBFp6WU/9dnMk/04LgsoGqknHDCmHhgFN08TfBZvuBFB91oXGryNcIQn+R03IO+HOeqp
 uDVe4bLU28S3R788POcRdJb1h5GTUpmfyklwKQSKwXZZQnJy8UV9/x5eF8+QeQAAhPGnKyvZw
 fHNVPlfXUWLMAYK1plc1rIYVQFqO3N468eUXxOmmz7A1MFiTpJx0ANWYvcFAJn28p8ovWOONs
 /fZ85i7zu1k59k=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 6e866a462867b60841202e900f10936a0478608c failed to
apply to kernel v5.2 up to v5.4.
Below is the fixed backport patch.
Please apply to v5.2 up to v5.4.

Thanks,
Helge

=2D-------------------
From: Helge Deller <deller@gmx.de>
Date: Sun, 31 Oct 2021 21:58:12 +0100
Subject: [PATCH] parisc: Fix set_fixmap() on PA1.x CPUs

Upstream commit: 6e866a462867b60841202e900f10936a0478608c

Fix a kernel crash which happens on PA1.x CPUs while initializing the
FTRACE/KPROBE breakpoints.  The PTE table entries for the fixmap area
were not created correctly.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: ccfbc68d41c2 ("parisc: add set_fixmap()/clear_fixmap()")
Cc: stable@vger.kernel.org # v5.2+

diff --git a/arch/parisc/mm/fixmap.c b/arch/parisc/mm/fixmap.c
index 474cd241c150..02e19a32e6c5 100644
=2D-- a/arch/parisc/mm/fixmap.c
+++ b/arch/parisc/mm/fixmap.c
@@ -18,12 +18,9 @@ void notrace set_fixmap(enum fixed_addresses idx, phys_=
addr_t phys)
 	pte_t *pte;

 	if (pmd_none(*pmd))
-		pmd =3D pmd_alloc(NULL, pgd, vaddr);
-
-	pte =3D pte_offset_kernel(pmd, vaddr);
-	if (pte_none(*pte))
 		pte =3D pte_alloc_kernel(pmd, vaddr);

+	pte =3D pte_offset_kernel(pmd, vaddr);
 	set_pte_at(&init_mm, vaddr, pte, __mk_pte(phys, PAGE_KERNEL_RWX));
 	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }
