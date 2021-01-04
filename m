Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2E52E94AF
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhADMVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:21:40 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:56319 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbhADMVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:21:40 -0500
Date:   Mon, 04 Jan 2021 12:20:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609762858; bh=qSKUMkjU5GlKT1yGdK7US3YKLfx4lwIL2x207qkS1m4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ZRS6F78XW6uvtedI4xk4g1iJ+rUb3117NOO/m3AJHy/9CxFxWNLx5gdwDKjyFWgI5
         MFCi/uk6pbz7c2TcxFopT9A4g2JobpjzcC2aHktcVT7/lV8qrhCNB5XI4IGqNdWMck
         X7nrz2ykcuQVR9gS8Uu1aUkShicCzBrDuFX3v7Mv3FKPnkYMd9ns5pxJOI2kRzYpbx
         yaiwJj1m8b5yPTNVQAKiS8ZP13dBr5DHEqmrJFm6ypmI1rnHjsK/LrsGH+5v0EMaHz
         O9v36XKIZmmD50PRH6fW4L1Y6JSdTIupjuazO0kN8AQepMLj+97mbm703b1mVIODO5
         kLVSIkBU9OQMQ==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alex Smith <alex.smith@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH mips-next 2/4] MIPS: vmlinux.lds.S: add ".rel.dyn" to DISCARDS
Message-ID: <20210104122016.47308-2-alobakin@pm.me>
In-Reply-To: <20210104122016.47308-1-alobakin@pm.me>
References: <20210104121729.46981-1-alobakin@pm.me> <20210104122016.47308-1-alobakin@pm.me>
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

GCC somehow manages to place some of the symbols from main.c into
.rel.dyn section:

mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
from `init/main.o' being placed in section `.rel.dyn'

I couldn't catch up the exact symbol, but seems like it's harmless
to discard it from the final vmlinux as kernel doesn't use or
support dynamic relocations.

Misc: sort DISCARDS section entries alphabetically.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 83e27a181206..1c3c2e903062 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -221,9 +221,10 @@ SECTIONS
 =09=09/* ABI crap starts here */
 =09=09*(.MIPS.abiflags)
 =09=09*(.MIPS.options)
+=09=09*(.eh_frame)
 =09=09*(.options)
 =09=09*(.pdr)
 =09=09*(.reginfo)
-=09=09*(.eh_frame)
+=09=09*(.rel.dyn)
 =09}
 }
--=20
2.30.0


