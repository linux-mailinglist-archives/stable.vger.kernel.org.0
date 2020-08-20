Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E5824B274
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgHTJaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbgHTJ36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A547422CA1;
        Thu, 20 Aug 2020 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915798;
        bh=WbXt8Ib5yN5cpTvhe/9oHmMjDtvq/mhODJSbnCMBbf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSSLjHSdgznU75octr1s+1JRBd78A6F1dgBBtgIwcvfbVg77MsOnhEzkneXkbEb5j
         +9Nv+cRwTc5hxYw34i/AbukMvkFYSYH+KHeV8sPGMQz6FxNLTjmyErPWfyO3xaJ6R7
         8dl0PdjxjUMKP1z92yWYn4mEHm84IuGriyDPcuYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 138/232] crypto: af_alg - Fix regression on empty requests
Date:   Thu, 20 Aug 2020 11:19:49 +0200
Message-Id: <20200820091619.509042985@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 662bb52f50bca16a74fe92b487a14d7dccb85e1a ]

Some user-space programs rely on crypto requests that have no
control metadata.  This broke when a check was added to require
the presence of control metadata with the ctx->init flag.

This patch fixes the regression by setting ctx->init as long as
one sendmsg(2) has been made, with or without a control message.

Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 9fcb91ea10c41..5882ed46f1adb 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -851,6 +851,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		err = -EINVAL;
 		goto unlock;
 	}
+	ctx->init = true;
 
 	if (init) {
 		ctx->enc = enc;
@@ -858,7 +859,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
 		ctx->aead_assoclen = con.aead_assoclen;
-		ctx->init = true;
 	}
 
 	while (size) {
-- 
2.25.1



