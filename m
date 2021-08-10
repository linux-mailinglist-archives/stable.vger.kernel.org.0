Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305BD3E7EE3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhHJRfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233151AbhHJRew (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D32610A8;
        Tue, 10 Aug 2021 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616870;
        bh=hUNZlVuOy/RNHlH250TGXEh9nB8tVl29TK3jqQjXNIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNtGTFUKEQIxdu1BcRXRDj5lSFWJmjZ3P/Ez5PDVCMWMwavRa8jyNFy9or++wI6n4
         MdD+ENwnEQJr3sbjeYVqK60AqCgIWp875c0UmHcw3GJAyGrfHfW45JJ1bFjLZbAxM7
         Ljn9Ddc63qw4rt8lMbDqdbo0LrbGJj7Rmk6PzoFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/85] mips: Fix non-POSIX regexp
Date:   Tue, 10 Aug 2021 19:30:02 +0200
Message-Id: <20210810172949.191453405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
index 5403a91ce098..9ff2c70763a0 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -320,7 +320,7 @@ KBUILD_LDFLAGS		+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
+	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif
 
-- 
2.30.2



