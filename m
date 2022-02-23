Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10164C06E9
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 02:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiBWBbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 20:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiBWBbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 20:31:00 -0500
Received: from mail-41104.protonmail.ch (mail-41104.protonmail.ch [185.70.41.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144C849FBD
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 17:30:33 -0800 (PST)
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41104.protonmail.ch (Postfix) with ESMTPS id 4K3JQ02khFz4x1HF
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 01:30:32 +0000 (UTC)
Authentication-Results: mail-41104.protonmail.ch;
        dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="mvo7jVeS"
Date:   Wed, 23 Feb 2022 01:30:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1645579827;
        bh=CQFxD1W39+Df70ddAmAdf4AQl7i9OvdeVhpyoh8lVhE=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=mvo7jVeSvzvjWXma7OZlSfTkGhoaZ9NX/KDBtfb+MAgm8/Kv8y6jQCkthz3aqmNVF
         6tIQ0maSDG4WHKhwEDovLCXJoqtwCwdyySTzqlIr9Wsg0d/qYIQ6iIliVRCXho8OyC
         y7/dsuj1YtNwC3Afgb3y/SeiaLNu3qtPz4bYoIZ4ABd9oEumVdgef3NaGtrVWa/9IL
         VeqI6O9htqh0m5t2MSjxd0f1MMV0AHHGFXQR+ld5J0tJBaWhxnEDIKySk67quOFveZ
         1lsL/FfGQ4/lLV1d2b0AuS9/sOLwg6hm6NQLBecphwvB4hCU+scszRgd2Dff9NRYSa
         cHvDSeYeVyKVA==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Rapoport <rppt@kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH mips-fixes] MIPS: fix fortify panic when copying asm exception handlers
Message-ID: <20220223012338.262041-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With KCFLAGS=3D"-O3", I was able to trigger a fortify-source
memcpy() overflow panic on set_vi_srs_handler().
Although O3 level is not supported in the mainline, under some
conditions that may've happened with any optimization settings,
it's just a matter of inlining luck. The panic itself is correct,
more precisely, 50/50 false-positive and not at the same time.
From the one side, no real overflow happens. Exception handler
defined in asm just gets copied to some reserved places in the
memory.
But the reason behind is that C code refers to that exception
handler declares it as `char`, i.e. something of 1 byte length.
It's obvious that the asm function itself is way more than 1 byte,
so fortify logics thought we are going to past the symbol declared.
The standard way to refer to asm symbols from C code which is not
supposed to be called from C is to declare them as
`extern const u8[]`. This is fully correct from any point of view,
as any code itself is just a bunch of bytes (including 0 as it is
for syms like _stext/_etext/etc.), and the exact size is not known
at the moment of compilation.
Adjust the type of the except_vec_vi_*() and related variables.
Make set_handler() take `const` as a second argument to avoid
cast-away warnings and give a little more room for optimization.

Fixes: e01402b115cc ("More AP / SP bits for the 34K, the Malta bits and thi=
ngs. Still wants")
Fixes: c65a5480ff29 ("[MIPS] Fix potential latency problem due to non-atomi=
c cpu_wait.")
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/include/asm/setup.h |  2 +-
 arch/mips/kernel/traps.c      | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
index bb36a400203d..8c56b862fd9c 100644
--- a/arch/mips/include/asm/setup.h
+++ b/arch/mips/include/asm/setup.h
@@ -16,7 +16,7 @@ static inline void setup_8250_early_printk_port(unsigned =
long base,
 =09unsigned int reg_shift, unsigned int timeout) {}
 #endif

-extern void set_handler(unsigned long offset, void *addr, unsigned long le=
n);
+void set_handler(unsigned long offset, const void *addr, unsigned long len=
);
 extern void set_uncached_handler(unsigned long offset, void *addr, unsigne=
d long len);

 typedef void (*vi_handler_t)(void);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index a486486b2355..246c6a6b0261 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2091,19 +2091,19 @@ static void *set_vi_srs_handler(int n, vi_handler_t=
 addr, int srs)
 =09=09 * If no shadow set is selected then use the default handler
 =09=09 * that does normal register saving and standard interrupt exit
 =09=09 */
-=09=09extern char except_vec_vi, except_vec_vi_lui;
-=09=09extern char except_vec_vi_ori, except_vec_vi_end;
-=09=09extern char rollback_except_vec_vi;
-=09=09char *vec_start =3D using_rollback_handler() ?
-=09=09=09&rollback_except_vec_vi : &except_vec_vi;
+=09=09extern const u8 except_vec_vi[], except_vec_vi_lui[];
+=09=09extern const u8 except_vec_vi_ori[], except_vec_vi_end[];
+=09=09extern const u8 rollback_except_vec_vi[];
+=09=09const u8 *vec_start =3D using_rollback_handler() ?
+=09=09=09=09      rollback_except_vec_vi : except_vec_vi;
 #if defined(CONFIG_CPU_MICROMIPS) || defined(CONFIG_CPU_BIG_ENDIAN)
-=09=09const int lui_offset =3D &except_vec_vi_lui - vec_start + 2;
-=09=09const int ori_offset =3D &except_vec_vi_ori - vec_start + 2;
+=09=09const int lui_offset =3D except_vec_vi_lui - vec_start + 2;
+=09=09const int ori_offset =3D except_vec_vi_ori - vec_start + 2;
 #else
-=09=09const int lui_offset =3D &except_vec_vi_lui - vec_start;
-=09=09const int ori_offset =3D &except_vec_vi_ori - vec_start;
+=09=09const int lui_offset =3D except_vec_vi_lui - vec_start;
+=09=09const int ori_offset =3D except_vec_vi_ori - vec_start;
 #endif
-=09=09const int handler_len =3D &except_vec_vi_end - vec_start;
+=09=09const int handler_len =3D except_vec_vi_end - vec_start;

 =09=09if (handler_len > VECTORSPACING) {
 =09=09=09/*
@@ -2311,7 +2311,7 @@ void per_cpu_trap_init(bool is_boot_cpu)
 }

 /* Install CPU exception handler */
-void set_handler(unsigned long offset, void *addr, unsigned long size)
+void set_handler(unsigned long offset, const void *addr, unsigned long siz=
e)
 {
 #ifdef CONFIG_CPU_MICROMIPS
 =09memcpy((void *)(ebase + offset), ((unsigned char *)addr - 1), size);
--
2.35.1


