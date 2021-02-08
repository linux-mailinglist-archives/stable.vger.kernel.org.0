Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EE7313C34
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhBHSEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235264AbhBHSAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC4164EB8;
        Mon,  8 Feb 2021 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807126;
        bh=Sg1viS9T1qX7q/DGhQ1LBwL/pdHKMdZ+oy6b1PRCgVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWIEdkzSrYmxlYrSz10QRG0AQuyi/C4rhI6yQynwf8ZpYDI/CORo1vadCnPjHifId
         JD/ixVHYnudPE1niQuSn9PWkeO1Ld/eecFfWjqQNH1qHP8Tcj2g4+BdUWcNOiBGsJL
         mP1XIewk63lBMt5sQsCMYWhQITQv/zTWKZt2u1Z9GOmFzqaVl8nB5jtdXn86X9LAgh
         Om66bjWm3ZdBEKTWkZwE49L8GcP97SIlSm5YniQ4M/qUnkaV9DNN1msXDvTAj/FCjd
         lRN5grSUK3bnwtTdtISj1yETVqx+jRzJALBmHUdF8icsS5Tb2YXrjrZjWq0shPcQA7
         0TvJxLs8L9wgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 29/36] kallsyms: fix nonconverging kallsyms table with lld
Date:   Mon,  8 Feb 2021 12:57:59 -0500
Message-Id: <20210208175806.2091668-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit efe6e3068067212b85c2d0474b5ee3b2d0c7adab ]

ARM randconfig builds with lld sometimes show a build failure
from kallsyms:

  Inconsistent kallsyms data
  Try make KALLSYMS_EXTRA_PASS=1 as a workaround

The problem is the veneers/thunks getting added by the linker extend
the symbol table, which in turn leads to more veneers being needed,
so it may take a few extra iterations to converge.

This bug has been fixed multiple times before, but comes back every time
a new symbol name is used. lld uses a different set of identifiers from
ld.bfd, so the additional ones need to be added as well.

I looked through the sources and found that arm64 and mips define similar
prefixes, so I'm adding those as well, aside from the ones I observed. I'm
not sure about powerpc64, which seems to already be handled through a
section match, but if it comes back, the "__long_branch_" and "__plt_"
prefixes would have to get added as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kallsyms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 7ecd2ccba531b..54ad86d137849 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -112,6 +112,12 @@ static bool is_ignored_symbol(const char *name, char type)
 		"__crc_",		/* modversions */
 		"__efistub_",		/* arm64 EFI stub namespace */
 		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
+		"__AArch64ADRPThunk_",	/* arm64 lld */
+		"__ARMV5PILongThunk_",	/* arm lld */
+		"__ARMV7PILongThunk_",
+		"__ThumbV7PILongThunk_",
+		"__LA25Thunk_",		/* mips lld */
+		"__microLA25Thunk_",
 		NULL
 	};
 
-- 
2.27.0

