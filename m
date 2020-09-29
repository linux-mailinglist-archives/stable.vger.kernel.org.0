Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3068827CAE1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbgI2MWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729796AbgI2LfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDB523C30;
        Tue, 29 Sep 2020 11:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378895;
        bh=NM+pV2xFne5voKMEuTRmE4BSRip2u7Hd2NQ0ApveeOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZlOFXGdDnmuCgUvdX+kuXY5pUQZ7Ou6eUt8GhMCIWZzCuRI8ql/DTi0whrnfWmRN
         IWOwbThScNbU8I2yZMX9OmGpOnMMSpAyHQxr6Jo/hqMF4y495z6CiQBQ5GfBYj4/Cp
         eQR1RT6jdhWM/ce7CDqiVX/PTU/cWSI3kepY8mtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/245] mm/kmemleak.c: use address-of operator on section symbols
Date:   Tue, 29 Sep 2020 12:59:49 +0200
Message-Id: <20200929105953.706085907@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b0d14fc43d39203ae025f20ef4d5d25d9ccf4be1 ]

Clang warns:

  mm/kmemleak.c:1955:28: warning: array comparison always evaluates to a constant [-Wtautological-compare]
        if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)
                                  ^
  mm/kmemleak.c:1955:60: warning: array comparison always evaluates to a constant [-Wtautological-compare]
        if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)

These are not true arrays, they are linker defined symbols, which are just
addresses.  Using the address of operator silences the warning and does
not change the resulting assembly with either clang/ld.lld or gcc/ld
(tested with diff + objdump -Dr).

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/895
Link: http://lkml.kernel.org/r/20200220051551.44000-1-natechancellor@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5eeabece0c178..f54734abf9466 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2039,7 +2039,7 @@ void __init kmemleak_init(void)
 	create_object((unsigned long)__bss_start, __bss_stop - __bss_start,
 		      KMEMLEAK_GREY, GFP_ATOMIC);
 	/* only register .data..ro_after_init if not within .data */
-	if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)
+	if (&__start_ro_after_init < &_sdata || &__end_ro_after_init > &_edata)
 		create_object((unsigned long)__start_ro_after_init,
 			      __end_ro_after_init - __start_ro_after_init,
 			      KMEMLEAK_GREY, GFP_ATOMIC);
-- 
2.25.1



