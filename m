Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F871499FC1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842112AbiAXXAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836498AbiAXWjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4448BC054879;
        Mon, 24 Jan 2022 13:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D81E860E8D;
        Mon, 24 Jan 2022 21:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C93C340E5;
        Mon, 24 Jan 2022 21:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058136;
        bh=KSy15URbnYdQ2MDCfeKbuVXx50REXtYPVx5KWVcdnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StZNNdUgOtJ6Xnr/PZy9tjy8qpYIVwvP9aBuK2s18Pr+aDOMlIhFMFL2C2PgEkJ1i
         r/NzgOZYcqH1BlEjsUi7t1R2erYD9wH0AB7JG0lIENvnB54bOOYo0xvDnBNKWwaf2i
         +qbXMxI5JD1EvVdVnvBWuIXKoSkNo02WLF/GOmKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0159/1039] crypto: qce - fix uaf on qce_aead_register_one
Date:   Mon, 24 Jan 2022 19:32:28 +0100
Message-Id: <20220124184130.541004389@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit 4a9dbd021970ffe1b92521328377b699acba7c52 ]

Pointer alg points to sub field of tmpl, it
is dereferenced after tmpl is freed. Fix
this by accessing alg before free tmpl.

Fixes: 9363efb4 ("crypto: qce - Add support for AEAD algorithms")
Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Acked-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qce/aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 290e2446a2f35..97a530171f07a 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -802,8 +802,8 @@ static int qce_aead_register_one(const struct qce_aead_def *def, struct qce_devi
 
 	ret = crypto_register_aead(alg);
 	if (ret) {
-		kfree(tmpl);
 		dev_err(qce->dev, "%s registration failed\n", alg->base.cra_name);
+		kfree(tmpl);
 		return ret;
 	}
 
-- 
2.34.1



