Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5756E2F0791
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 15:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbhAJOV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 09:21:58 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:53037 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJOV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 09:21:58 -0500
Date:   Sun, 10 Jan 2021 14:21:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610288470; bh=VGX0PRLKNwrqHDEXkOqUUZwUy5aJ1pV/tRE9+Arq0VI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=aCJf4p3jmFPCVY0b8/vbBTqZ3xWaHVQARclhn/7SqULUBNlcRd7YrCsEeII20qKic
         wyCP+tV9UrkXGFCCaIfsvE1RfjLMdPUnMDAMVR8e83vUpEDvTyaAqtH3Jzt8y4RxzH
         35Lz8H1AUueVhTYf5LUxfBuLOjUH9aFOwK5aNohrUoo2Gny26WlhEXNO/Y886SHa9I
         ukXhmKtx3bdiHyWgYlc5yb+YUzxyXxHfKQzoBCXpaXyrOCRsgKM61nBjBf3+3kJuJB
         tyHuyuq5vCQL9cMc5QHrRXGIDjOmBPppvwH5BuW87n41bpx4P8igHwH39LV3AzToXu
         +QqlU4nQ4rJyQ==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jinyang He <hejinyang@loongson.cn>,
        Alexander Lobakin <alobakin@pm.me>,
        Ralf Baechle <ralf@linux-mips.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH mips-fixes] MIPS: relocatable: fix possible boot hangup with KASLR enabled
Message-ID: <20210110142023.185275-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLVM-built Linux triggered a boot hangup with KASLR enabled.

arch/mips/kernel/relocate.c:get_random_boot() uses linux_banner,
which is a string constant, as a random seed, but accesses it
as an array of unsigned long (in rotate_xor()).
When the address of linux_banner is not aligned to sizeof(long),
such access emits unaligned access exception and hangs the kernel.

Use PTR_ALIGN() to align input address to sizeof(long) and also
align down the input length to prevent possible access-beyond-end.

Fixes: 405bc8fd12f5 ("MIPS: Kernel: Implement KASLR using CONFIG_RELOCATABL=
E")
Cc: stable@vger.kernel.org # 4.7+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/relocate.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 47aeb3350a76..0e365b7c742d 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -187,8 +187,14 @@ static int __init relocate_exception_table(long offset=
)
 static inline __init unsigned long rotate_xor(unsigned long hash,
 =09=09=09=09=09      const void *area, size_t size)
 {
-=09size_t i;
-=09unsigned long *ptr =3D (unsigned long *)area;
+=09const typeof(hash) *ptr =3D PTR_ALIGN(area, sizeof(hash));
+=09size_t diff, i;
+
+=09diff =3D (void *)ptr - area;
+=09if (unlikely(size < diff + sizeof(hash)))
+=09=09return hash;
+
+=09size =3D ALIGN_DOWN(size - diff, sizeof(hash));
=20
 =09for (i =3D 0; i < size / sizeof(hash); i++) {
 =09=09/* Rotate by odd number of bits and XOR. */
--=20
2.30.0


