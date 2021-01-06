Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988342EC47E
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 21:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbhAFUJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 15:09:52 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:57576 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbhAFUJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 15:09:51 -0500
Date:   Wed, 06 Jan 2021 20:08:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609963703; bh=gVx8E+xZ9lrHiS0GOCboaARCIQvynUD7BXGkbX/mth4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=D5BR4ONH0+Jq/LU0r/+wUjKpN7kzcWdAhFr9x7aMgFdq26mi41Ql2zYLn3g4AuR7y
         /LrjwC+6fobtndVgofP13pV8AsRd5qvnyTf/EMj71FnmDVTDO7MDk1O3T+Y4BNnyxo
         CSh1T5hd9CvPzhYWfS37WM829VOabqEnMxuz4ROjYgyG7ovyA3bp/6B1LB4rvxOKet
         UlyHGyu9IXcwWAqczIjrmR9pVtNTCzL1Qs4SuMN8kSiMgRm4yCX5FeCgufBxYrZIrp
         AfpxXUy5EWWVVuO24Qqga4QaKpYiWWbWYUzF89n+Cht+IGJn/tNQeKSn+XZeEDNz5+
         v+0bgIMZtAblg==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alex Smith <alex.smith@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 mips-next 2/4] MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
Message-ID: <20210106200801.31993-2-alobakin@pm.me>
In-Reply-To: <20210106200801.31993-1-alobakin@pm.me>
References: <20210106200713.31840-1-alobakin@pm.me> <20210106200801.31993-1-alobakin@pm.me>
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

Discard GNU attributes at link time as kernel doesn't use it at all.
Solves a dozen of the following ld warnings (one per every file):

mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
from `arch/mips/kernel/head.o' being placed in section
`.gnu.attributes'
mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
from `init/main.o' being placed in section `.gnu.attributes'

Misc: sort DISCARDS section entries alphabetically.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 83e27a181206..5d6563970ab2 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -221,9 +221,10 @@ SECTIONS
 =09=09/* ABI crap starts here */
 =09=09*(.MIPS.abiflags)
 =09=09*(.MIPS.options)
+=09=09*(.eh_frame)
+=09=09*(.gnu.attributes)
 =09=09*(.options)
 =09=09*(.pdr)
 =09=09*(.reginfo)
-=09=09*(.eh_frame)
 =09}
 }
--=20
2.30.0


