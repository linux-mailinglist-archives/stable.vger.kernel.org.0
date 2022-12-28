Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90F5658047
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiL1QQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiL1QQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BFB1A82D;
        Wed, 28 Dec 2022 08:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9B05B81707;
        Wed, 28 Dec 2022 16:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E4C433EF;
        Wed, 28 Dec 2022 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244008;
        bh=DjK8F8iE3Z01tKYaGE96lJvosdA9ktOtD+1ozokc7oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUnKDKZMya5hDm5nSYJjBlPGcODC5Brf9sVeNiua3gQMag3aqq98/5ZmX7xlbJgE+
         Ekm8P3h+ETGukr4GuZS61pevm9xbuOBF7FVwDV40JzNGVzg4cbf7mgkl9MmgX91Ivg
         yybbG9pWyPc0k428A+CMmtcnqaOxYOwhhNhfwlk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0594/1146] fortify: Do not cast to "unsigned char"
Date:   Wed, 28 Dec 2022 15:35:33 +0100
Message-Id: <20221228144346.305005394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e9a40e1585d792751d3a122392695e5a53032809 ]

Do not cast to "unsigned char", as this needlessly creates type problems
when attempting builds without -Wno-pointer-sign[1]. The intent of the
cast is to drop possible "const" types.

[1] https://lore.kernel.org/lkml/CAHk-=wgz3Uba8w7kdXhsqR1qvfemYL+OFQdefJnkeqXG8qZ_pA@mail.gmail.com/

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 3009f891bb9f ("fortify: Allow strlen() and strnlen() to pass compile-time known lengths")
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 1067a8450826..5001a11258e4 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -18,7 +18,7 @@ void __write_overflow_field(size_t avail, size_t wanted) __compiletime_warning("
 
 #define __compiletime_strlen(p)					\
 ({								\
-	unsigned char *__p = (unsigned char *)(p);		\
+	char *__p = (char *)(p);				\
 	size_t __ret = SIZE_MAX;				\
 	size_t __p_size = __member_size(p);			\
 	if (__p_size != SIZE_MAX &&				\
-- 
2.35.1



