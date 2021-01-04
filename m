Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70562E94B6
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbhADMWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:22:24 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:56026 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADMWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:22:23 -0500
Date:   Mon, 04 Jan 2021 12:20:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609762853; bh=SIcv4XaKrE3sjxZfC8U6t0751adTjmCuETpzD6NuSCs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=bPMmaBiAOhYlDJK/WP/HejMz608GEwc4rUQd3zhL6wzuyuY7BGoviLNtY/TRG/QQj
         1Lnm8VO6jaYUmvQ5BukLRA3Vgto2s225dVo/Fl/MiYpv5SLQCn0KFpJPOFuk2Pnk5K
         VHt/G6EpflXQo3uLKWn3FCgetsywnCUs43v4X7Nn/cbODlUwyFk/TAHUrTZxClz21S
         S9GzydYwIHrYfY79v/ECshGODjFcK034OAOPbp09euD4AEW09WryoI8RAecgCpNY6T
         77E4PkMd3S41J9sz9k02re5tp/UwsYms57WlZOn0V11NIDhmlSiqfTTLMu61PBFs49
         L+kNdYA80BOZA==
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
Subject: [PATCH mips-next 3/4] MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
Message-ID: <20210104122016.47308-3-alobakin@pm.me>
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

Discard GNU attributes at link time as kernel doesn't use it at all.
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
index 1c3c2e903062..8ac95269124a 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -222,6 +222,7 @@ SECTIONS
 =09=09*(.MIPS.abiflags)
 =09=09*(.MIPS.options)
 =09=09*(.eh_frame)
+=09=09*(.gnu.attributes)
 =09=09*(.options)
 =09=09*(.pdr)
 =09=09*(.reginfo)
--=20
2.30.0


