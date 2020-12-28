Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B132E3B01
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404605AbgL1Noh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404597AbgL1Nog (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75A420715;
        Mon, 28 Dec 2020 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163035;
        bh=dfkWJpZfplISCTJBEALmGj372CmMoqnsoVwIYcrFsUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uj3ivVF1TIwEsrZoWxr7wIJ+c77pXpRl8rRPoFuCFguQ8KihNjnpDH9vEiMbSivx
         gbNRsEqKa7gRYLB26Lc9hZBUZklZYw5H2XcFBf8DIu1kTsnmheSUPvFkxxrqFf/4jt
         gm0jvMqz5CKlZdtjxHGEsbFb731uh/jdoWWD9Tjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/453] selftests/bpf: Fix broken riscv build
Date:   Mon, 28 Dec 2020 13:46:23 +0100
Message-Id: <20201228124944.276123975@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@gmail.com>

[ Upstream commit 6016df8fe874e1cf36f6357d71438b384198ce06 ]

The selftests/bpf Makefile includes system include directories from
the host, when building BPF programs. On RISC-V glibc requires that
__riscv_xlen is defined. This is not the case for "clang -target bpf",
which messes up __WORDSIZE (errno.h -> ... -> wordsize.h) and breaks
the build.

By explicitly defining __risc_xlen correctly for riscv, we can
workaround this.

Fixes: 167381f3eac0 ("selftests/bpf: Makefile fix "missing" headers on build with -idirafter")
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Luke Nelson <luke.r.nels@gmail.com>
Link: https://lore.kernel.org/bpf/20201118071640.83773-2-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6889c19a628c2..544bd1028baee 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -144,7 +144,8 @@ endif
 # build would have failed anyways.
 define get_sys_includes
 $(shell $(1) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' | sed 's/#define /-D/' | sed 's/ /=/')
 endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -I. -I./include/uapi -I../../../include/uapi \
-- 
2.27.0



