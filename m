Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223612ECFEB
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 13:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbhAGMfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 07:35:40 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:23509 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbhAGMfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 07:35:40 -0500
Date:   Thu, 07 Jan 2021 12:34:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610022898; bh=012vDHOxvqVPo52Yrh8ZCe0PscXXJoRaQmC+Qol94bs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=SvZOZeHRjbzSSnW4dvfM9BrtRGjLLTvIhxnVV3QgsCdA69aUJroaV24Xk9SFhlx+u
         sHD65gs8WP+lrkH3PIpa/Epk4dVLI8R4mARZ+do02zCYBZU0l36zTPiCSCG7IxDvJl
         vfv/aRCcswEfBYznLPw+IM4hpYm15nOy4rJQYP3BUAiw7L/JXI44SysEpxSxHp3Ahn
         o9sVf29pNp0w/t/SsQ9D2o/j5lx5/WLvT8sjVIczhfyXYjdWhdevSc0Y02Kp8Ecb2H
         3GysfZh18+0wEbte2CXW9SSiFBSXXe2hFWip2eAR86tHqBY1ABt95QqvfCuSuoVA/P
         9FnpbO50thbVw==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 mips-next 2/7] MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
Message-ID: <20210107123428.354231-2-alobakin@pm.me>
In-Reply-To: <20210107123428.354231-1-alobakin@pm.me>
References: <20210107123331.354075-1-alobakin@pm.me> <20210107123428.354231-1-alobakin@pm.me>
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

Discard GNU attributes (MIPS FP type, GNU Hash etc.) at link time
as kernel doesn't use it at all.
Solves a dozen of the following ld warnings (one per every file):

mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
from `arch/mips/kernel/head.o' being placed in section
`.gnu.attributes'
mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
from `init/main.o' being placed in section `.gnu.attributes'

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 83e27a181206..16468957cba2 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -221,6 +221,7 @@ SECTIONS
 =09=09/* ABI crap starts here */
 =09=09*(.MIPS.abiflags)
 =09=09*(.MIPS.options)
+=09=09*(.gnu.attributes)
 =09=09*(.options)
 =09=09*(.pdr)
 =09=09*(.reginfo)
--=20
2.30.0


