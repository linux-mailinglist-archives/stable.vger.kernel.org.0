Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAA024BD3C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgHTJkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgHTJkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A00F208E4;
        Thu, 20 Aug 2020 09:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916419;
        bh=WbXt8Ib5yN5cpTvhe/9oHmMjDtvq/mhODJSbnCMBbf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFpJ639qvDVvCG3skiLg1HiJAtLFCxkc/oKQxNuKWYDSXsfetldmNynZYg07dAyi0
         rWdVX0JtF7RuMCFj03nY5Tb1NB/DvV5ArAEGmh+EDgZlRiI2j6vh4KpWPoWMj2HezW
         S3bHtyH/4DsRShjMAeJbVV3y/XD9xbfozM8Wmch8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 120/204] crypto: af_alg - Fix regression on empty requests
Date:   Thu, 20 Aug 2020 11:20:17 +0200
Message-Id: <20200820091612.290554403@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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



