Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1234919105
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfEISwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbfEISwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B90217D7;
        Thu,  9 May 2019 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427920;
        bh=EJS7YmUdOqdLQveuIiW+PCJ+NsY51FD7U65FDriMI1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNtFWcv50XDoaYe67V1dRTJdTNvZ2V7dTo4+vis7ZNT6ohR9PRKG1kVDGeO9/CpUE
         xjmXPKD2DxCBxRTC1v1syDq9wOL3VLT5aQuGFECi4o9Zlqel8yf1a1Xwr4ri7bHaiL
         jZj0JuR7rBKKuLqW7NKqWPcl21NA19iSN9bqrhO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <David.Laight@aculab.com>,
        Denis Kenzior <denkenz@gmail.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <james.morris@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 53/95] KEYS: trusted: fix -Wvarags warning
Date:   Thu,  9 May 2019 20:42:10 +0200
Message-Id: <20190509181313.216685540@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit be24b37e22c20cbaa891971616784dd0f35211e8 ]

Fixes the warning reported by Clang:
security/keys/trusted.c:146:17: warning: passing an object that
undergoes default
      argument promotion to 'va_start' has undefined behavior [-Wvarargs]
        va_start(argp, h3);
                       ^
security/keys/trusted.c:126:37: note: parameter of type 'unsigned
char' is declared here
unsigned char *h2, unsigned char h3, ...)
                               ^
Specifically, it seems that both the C90 (4.8.1.1) and C11 (7.16.1.4)
standards explicitly call this out as undefined behavior:

The parameter parmN is the identifier of the rightmost parameter in
the variable parameter list in the function definition (the one just
before the ...). If the parameter parmN is declared with ... or with a
type that is not compatible with the type that results after
application of the default argument promotions, the behavior is
undefined.

Link: https://github.com/ClangBuiltLinux/linux/issues/41
Link: https://www.eskimo.com/~scs/cclass/int/sx11c.html
Suggested-by: David Laight <David.Laight@aculab.com>
Suggested-by: Denis Kenzior <denkenz@gmail.com>
Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: James Morris <james.morris@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/keys/trusted.h  | 2 +-
 security/keys/trusted.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/keys/trusted.h b/include/keys/trusted.h
index adbcb68178260..0071298b9b28e 100644
--- a/include/keys/trusted.h
+++ b/include/keys/trusted.h
@@ -38,7 +38,7 @@ enum {
 
 int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 			unsigned int keylen, unsigned char *h1,
-			unsigned char *h2, unsigned char h3, ...);
+			unsigned char *h2, unsigned int h3, ...);
 int TSS_checkhmac1(unsigned char *buffer,
 			  const uint32_t command,
 			  const unsigned char *ononce,
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 4d98f4f87236c..94d2b28c7c223 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -123,7 +123,7 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
  */
 int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 			unsigned int keylen, unsigned char *h1,
-			unsigned char *h2, unsigned char h3, ...)
+			unsigned char *h2, unsigned int h3, ...)
 {
 	unsigned char paramdigest[SHA1_DIGEST_SIZE];
 	struct sdesc *sdesc;
@@ -139,7 +139,7 @@ int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 		return PTR_ERR(sdesc);
 	}
 
-	c = h3;
+	c = !!h3;
 	ret = crypto_shash_init(&sdesc->shash);
 	if (ret < 0)
 		goto out;
-- 
2.20.1



