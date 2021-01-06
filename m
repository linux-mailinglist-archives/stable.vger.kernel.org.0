Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBBB2EC46F
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 21:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbhAFUIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 15:08:12 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:50360 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbhAFUIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 15:08:12 -0500
Date:   Wed, 06 Jan 2021 20:07:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609963650; bh=y++KTID87p0awo1xB/yYLOezpj3SKaTGHD5nqOFuw5Y=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ajaFlDaxXHQ/kzg8Z62QRL4gWmvnscFm/2xr9pZ2VlUqSwawmqJRc1A4zTtZyBUI+
         baiWpEgrPMT6nyubyOwJUf5KJOEZKhVlVXEJTZVSMtV+sNfS0OsgBI52OK7qZbWVv1
         VwTyplMFf0L6/01GcGHYyn8fts52MEh9Ojj/AwRIJZlD41vnX9ZPFvdRC7C4X58nhJ
         rkjsvAYHnfBVO1qQmEShAPxqtCoiMT6TJJpXoj/Y1CARUKPiJAA4fvHO5xklIVovQd
         yvgjQPNOLETD/rTOIHa7ROWPtze+oHfd5agrQFcPa+8TJkhm4rT5iLfpOXOPMZ5nym
         MuZxO7ikOsE5Q==
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
Subject: [PATCH v2 mips-next 0/4] MIPS: vmlinux.lds.S sections fix & cleanup
Message-ID: <20210106200713.31840-1-alobakin@pm.me>
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

This series hunts the problems discovered after manual enabling of
ARCH_WANT_LD_ORPHAN_WARN, notably the missing PAGE_ALIGNED_DATA()
section affecting VDSO placement (marked for stable).

Compile and runtime tested on MIPS32R2 CPS board with no issues.

Since v1 [0]:
 - catch .got entries too as LLD may produce it (Nathan);
 - check for unwanted sections to be zero-sized instead of
   discarding (Fangrui).

[0] https://lore.kernel.org/linux-mips/20210104121729.46981-1-alobakin@pm.m=
e

Alexander Lobakin (4):
  MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
  MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
  MIPS: vmlinux.lds.S: catch bad .got, .plt and .rel.dyn at link time
  MIPS: select ARCH_WANT_LD_ORPHAN_WARN

 arch/mips/Kconfig              |  1 +
 arch/mips/kernel/vmlinux.lds.S | 39 +++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

--=20
2.30.0


