Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381B2EC476
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 21:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbhAFUJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 15:09:00 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:50666 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbhAFUI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 15:08:59 -0500
Date:   Wed, 06 Jan 2021 20:08:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609963697; bh=hjIccLTNrNOzUNrqAIbTw81FXVcf6wB+LAQsEABOGxY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=i5a6TJtch6Od01ozZrBiV73uviXZxXdQfPmCCKjPgtoZjLBFlLr4uVJz8CWfOwXVJ
         1kA9sw2VpQ5ZM52dVlUsQWtGwJ9vjW3SxqmHdmWoISKy8k1v0M9B9d261QKbXcxnSy
         PGBo+whYEUl/Ph+Txmsf15Yfn7aaqJwn0in1qoHpN22fwRnDg9yMk15FkiMQfpIJ2o
         DDNYqwel+FAKjcmoTk1yfKI2OEo/9NT+uoQvJ3ozEpsmvUzktyia6N6w3Fs1BuiL5T
         yaf2+yyy2mNzbOkVljPxvQxPq/biuNwF0Mc0tQdm4/dFHmiw9oiwMC7pKHb+VuLJxK
         kcMyDawmaFVsg==
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
Subject: [PATCH v2 mips-next 1/4] MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
Message-ID: <20210106200801.31993-1-alobakin@pm.me>
In-Reply-To: <20210106200713.31840-1-alobakin@pm.me>
References: <20210106200713.31840-1-alobakin@pm.me>
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

MIPS uses its own declaration of rwdata, and thus it should be kept
in sync with the asm-generic one. Currently PAGE_ALIGNED_DATA() is
missing from the linker script, which emits the following ld
warnings:

mips-alpine-linux-musl-ld: warning: orphan section
`.data..page_aligned' from `arch/mips/kernel/vdso.o' being placed
in section `.data..page_aligned'
mips-alpine-linux-musl-ld: warning: orphan section
`.data..page_aligned' from `arch/mips/vdso/vdso-image.o' being placed
in section `.data..page_aligned'

Add the necessary declaration, so the mentioned structures will be
placed in vmlinux as intended:

ffffffff80630580 D __end_once
ffffffff80630580 D __start___dyndbg
ffffffff80630580 D __start_once
ffffffff80630580 D __stop___dyndbg
ffffffff80634000 d mips_vdso_data
ffffffff80638000 d vdso_data
ffffffff80638580 D _gp
ffffffff8063c000 T __init_begin
ffffffff8063c000 D _edata
ffffffff8063c000 T _sinittext

->

ffffffff805a4000 D __end_init_task
ffffffff805a4000 D __nosave_begin
ffffffff805a4000 D __nosave_end
ffffffff805a4000 d mips_vdso_data
ffffffff805a8000 d vdso_data
ffffffff805ac000 D mmlist_lock
ffffffff805ac080 D tasklist_lock

Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 5e97e9d02f98..83e27a181206 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -90,6 +90,7 @@ SECTIONS
=20
 =09=09INIT_TASK_DATA(THREAD_SIZE)
 =09=09NOSAVE_DATA
+=09=09PAGE_ALIGNED_DATA(PAGE_SIZE)
 =09=09CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 =09=09READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 =09=09DATA_DATA
--=20
2.30.0


