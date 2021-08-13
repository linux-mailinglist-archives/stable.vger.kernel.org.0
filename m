Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5523EB809
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbhHMPKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241522AbhHMPKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E26F6112F;
        Fri, 13 Aug 2021 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867393;
        bh=KIz3KZERk00/VUrFyp6E9O2ygsPMZz2rCEzrJMPj+oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pyh+e2l5Fopbvpxp192ZebumuXYZloUeN/dKEEPkLGLF16VLp0RjB8kqNyZgAlWn+
         yS1VXAOfkvBX975YONIJJOQaGDzlf7OGhzmAbXidmRLx5SLOISC0x27tQ7WtFqS+SP
         iYP/lvOP1X4zfG4dibivzCTyNDnyEq3+rrOsCNwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/30] mips: Fix non-POSIX regexp
Date:   Fri, 13 Aug 2021 17:06:33 +0200
Message-Id: <20210813150522.615538452@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 28bbbb9875a35975904e46f9b06fa689d051b290 ]

When cross compiling a MIPS kernel on a BSD based HOSTCC leads
to errors like

  SYNC    include/config/auto.conf.cmd - due to: .config
egrep: empty (sub)expression
  UPD     include/config/kernel.release
  HOSTCC  scripts/dtc/dtc.o - due to target missing

It turns out that egrep uses this egrep pattern:

		(|MINOR_|PATCHLEVEL_)

This is not valid syntax or gives undefined results according
to POSIX 9.5.3 ERE Grammar

	https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html

It seems to be silently accepted by the Linux egrep implementation
while a BSD host complains.

Such patterns can be replaced by a transformation like

	"(|p1|p2)" -> "(p1|p2)?"

Fixes: 48c35b2d245f ("[MIPS] There is no __GNUC_MAJOR__")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 25f3bfef9b39..af4eff7d22ec 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -286,7 +286,7 @@ LDFLAGS			+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
+	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 ifdef CONFIG_64BIT
 CHECKFLAGS		+= -m64
-- 
2.30.2



