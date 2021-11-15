Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F6345107D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbhKOSta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242834AbhKOSqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:46:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 646B963296;
        Mon, 15 Nov 2021 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999617;
        bh=HH9kc9fwqHZsH064mu4Hat/FXGOl5tPVZ52znZXXso4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/spWJtiqnIoAl9Ih7rN7zmSMfdj7RVn/6tqMYuwOvYUbv34Tw3NUFawU/kccnaib
         Ow9PjNG72b55HjiIKuISHKW1vw/LqRRsTEYdFdw7JrAyKkPwMec/4rvEYC9j/+qkyn
         gz6/GHP0o60KPE0Yow0yZbri+cpMmNwqTZAAwIxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 363/849] fortify: Fix dropped strcpy() compile-time write overflow check
Date:   Mon, 15 Nov 2021 17:57:26 +0100
Message-Id: <20211115165432.513512798@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 072af0c638dc8a5c7db2edc4dddbd6d44bee3bdb ]

The implementation for intra-object overflow in str*-family functions
accidentally dropped compile-time write overflow checking in strcpy(),
leaving it entirely to run-time. Add back the intended check.

Fixes: 6a39e62abbaf ("lib: string.h: detect intra-object overflow in fortified string functions")
Cc: Daniel Axtens <dja@axtens.net>
Cc: Francis Laniel <laniel_francis@privacyrequired.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index c1be37437e778..0c70febd03e95 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -280,7 +280,10 @@ __FORTIFY_INLINE char *strcpy(char *p, const char *q)
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __underlying_strcpy(p, q);
 	size = strlen(q) + 1;
-	/* test here to use the more stringent object size */
+	/* Compile-time check for const size overflow. */
+	if (__builtin_constant_p(size) && p_size < size)
+		__write_overflow();
+	/* Run-time check for dynamic size overflow. */
 	if (p_size < size)
 		fortify_panic(__func__);
 	memcpy(p, q, size);
-- 
2.33.0



