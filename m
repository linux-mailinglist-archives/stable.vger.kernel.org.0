Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF143E8135
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhHJR4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237409AbhHJRyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B876135F;
        Tue, 10 Aug 2021 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617460;
        bh=BzW9kdB/UJfQxAlwAdVRFHquQc/h6Mj94NDy4OuosIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE9OXNAyuXi4eA4IzU3YngC+6Y+a9kjszymRtqlclMYz8JOqnZhy+QNvuINSyUV5O
         gKG0CeLFSDed22+1TRFeogtjOIzOduwh/I6saeSxl9mHhKYOUMng23V/Ybqj1aVvt1
         466OqXeBqk/ELVKZF2iaUWq4mnxJycKx9npp7/SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 061/175] x86/tools/relocs: Fix non-POSIX regexp
Date:   Tue, 10 Aug 2021 19:29:29 +0200
Message-Id: <20210810173002.955707371@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit fa953adfad7cf9c7e30d9ea0e4ccfd38cfb5495d ]

Trying to run a cross-compiled x86 relocs tool on a BSD based
HOSTCC leads to errors like

  VOFFSET arch/x86/boot/compressed/../voffset.h - due to: vmlinux
  CC      arch/x86/boot/compressed/misc.o - due to: arch/x86/boot/compressed/../voffset.h
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin - due to: vmlinux
  RELOCS  arch/x86/boot/compressed/vmlinux.relocs - due to: vmlinux
empty (sub)expressionarch/x86/boot/compressed/Makefile:118: recipe for target 'arch/x86/boot/compressed/vmlinux.relocs' failed
make[3]: *** [arch/x86/boot/compressed/vmlinux.relocs] Error 1

It turns out that relocs.c uses patterns like

	"something(|_end)"

This is not valid syntax or gives undefined results according
to POSIX 9.5.3 ERE Grammar

	https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html

It seems to be silently accepted by the Linux regexp() implementation
while a BSD host complains.

Such patterns can be replaced by a transformation like

	"(|p1|p2)" -> "(p1|p2)?"

Fixes: fd952815307f ("x86-32, relocs: Whitelist more symbols for ld bug workaround")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/tools/relocs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 04c5a44b9682..9ba700dc47de 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -57,12 +57,12 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	[S_REL] =
 	"^(__init_(begin|end)|"
 	"__x86_cpu_dev_(start|end)|"
-	"(__parainstructions|__alt_instructions)(|_end)|"
-	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"(__parainstructions|__alt_instructions)(_end)?|"
+	"(__iommu_table|__apicdrivers|__smp_locks)(_end)?|"
 	"__(start|end)_pci_.*|"
 	"__(start|end)_builtin_fw|"
-	"__(start|stop)___ksymtab(|_gpl)|"
-	"__(start|stop)___kcrctab(|_gpl)|"
+	"__(start|stop)___ksymtab(_gpl)?|"
+	"__(start|stop)___kcrctab(_gpl)?|"
 	"__(start|stop)___param|"
 	"__(start|stop)___modver|"
 	"__(start|stop)___bug_table|"
-- 
2.30.2



