Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EAD419C45
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhI0R0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237227AbhI0RYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F949613E6;
        Mon, 27 Sep 2021 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762949;
        bh=toEXuD3DkAOe0xVPXl8rapK3oRk2eBv0iGd4qQNivug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnWwIOETgRKRrB1/f/5KPDwQ8fADQBRhbpYJCJVCeKLwKRfL8QHH+32C9Vlmp+KoN
         41hNt3rUT+rPliDE0S+eC1/aovQOKnlrIFq+JsKjJmuj/f2eDggyv3QanteER7NFYN
         hPnqWFw9euclS9KYNmHkSFfUIIpCimZLnVGHEv8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 111/162] x86/asm: Fix SETZ size enqcmds() build failure
Date:   Mon, 27 Sep 2021 19:02:37 +0200
Message-Id: <20210927170237.290623887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index f3fbb84ff8a7..68c257a3de0d 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -275,7 +275,7 @@ static inline int enqcmds(void __iomem *dst, const void *src)
 {
 	const struct { char _[64]; } *__src = src;
 	struct { char _[64]; } __iomem *__dst = dst;
-	int zf;
+	bool zf;
 
 	/*
 	 * ENQCMDS %(rdx), rax
-- 
2.33.0



