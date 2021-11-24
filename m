Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5709445C59C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350574AbhKXN73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348094AbhKXN44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB8EA633A7;
        Wed, 24 Nov 2021 13:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759245;
        bh=7MfvccHvStwXIO+y/zcEgLya9zDyqyQcbIxwLo+2MPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQBgM/Q3ZC2Ao4mnuoOk2DTBS6DvX8AIzKdfgY0H/Q6pWPQtMfDIXRYzGO8Ittxt3
         ml71oTWKlLhb2fGv3E+20qc2DevjsGqSAhJd194ZUJPBO3SZiWhvmOCpMeSHV9Cngx
         Xm1rl1iEAylfyqbBZzA7WPewClcY4vy0F9Mn5+x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/279] powerpc: clean vdso32 and vdso64 directories
Date:   Wed, 24 Nov 2021 12:57:44 +0100
Message-Id: <20211124115724.861547819@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 964c33cd0be621b291b5d253d8731eb2680082cb ]

Since commit bce74491c300 ("powerpc/vdso: fix unnecessary rebuilds of
vgettimeofday.o"), "make ARCH=powerpc clean" does not clean up the
arch/powerpc/kernel/{vdso32,vdso64} directories.

Use the subdir- trick to let "make clean" descend into them.

Fixes: bce74491c300 ("powerpc/vdso: fix unnecessary rebuilds of vgettimeofday.o")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211109185015.615517-1-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 7be36c1e1db6d..86e40db2dec56 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -196,3 +196,6 @@ clean-files := vmlinux.lds
 # Force dependency (incbin is bad)
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32/vdso32.so.dbg
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64/vdso64.so.dbg
+
+# for cleaning
+subdir- += vdso32 vdso64
-- 
2.33.0



