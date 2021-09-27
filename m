Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A37419B14
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhI0RPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236938AbhI0RNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3DB6120C;
        Mon, 27 Sep 2021 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762559;
        bh=czjirBWMOYc6UYeqMwKj/sEc3UEcLEP2zqBlbCFmIvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3G+BUvbJdCw9GKqhTgLxCz2/Aca84cc5CWzqA9mRLpQoP+WtBSD06Y9B53u1p254
         U80qqBGLF/rlBSbwZRcESr70gOhBYfUYtJjaVhWaMUHo4mtXD7Gahh1oW4q6QcZt7K
         FQzWy7QHMz+BZzUtPW3ztSYbYI4BmpjLrgXPM+as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/103] x86/asm: Fix SETZ size enqcmds() build failure
Date:   Mon, 27 Sep 2021 19:02:42 +0200
Message-Id: <20210927170228.191585938@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d81ff5fe14a950f53e2833cfa196e7bb3fd5d4e3 ]

When building under GCC 4.9 and 5.5:

  arch/x86/include/asm/special_insns.h: Assembler messages:
  arch/x86/include/asm/special_insns.h:286: Error: operand size mismatch for `setz'

Change the type to "bool" for condition code arguments, as documented.

Fixes: 7f5933f81bd8 ("x86/asm: Add an enqcmds() wrapper for the ENQCMDS instruction")
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210910223332.3224851-1-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/special_insns.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 0cf19684dd20..415693f5d909 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -287,7 +287,7 @@ static inline int enqcmds(void __iomem *dst, const void *src)
 {
 	const struct { char _[64]; } *__src = src;
 	struct { char _[64]; } __iomem *__dst = dst;
-	int zf;
+	bool zf;
 
 	/*
 	 * ENQCMDS %(rdx), rax
-- 
2.33.0



