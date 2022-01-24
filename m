Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A573498E0C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349375AbiAXTi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353006AbiAXTbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:31:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE94C0604CC;
        Mon, 24 Jan 2022 11:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A58360B86;
        Mon, 24 Jan 2022 19:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C3C340E5;
        Mon, 24 Jan 2022 19:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051692;
        bh=2GBRf5isI7WxVEFzBNAez1QtihJLzttbdylD85HipyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tvp2kzAwL+AStvF+Bz2CyJFxHGPmFQJ4eMwL8B7BFfANagOBGNh9MWBKa7zo37eSZ
         Kkxk9ifQWrBBJE+zvsUbhRTklJ1AkaJHRKist6ph9/4SG1ok7ZvH0tMuEftnqBRh/R
         OG6BIjzcYyRkoq5qnq2/W2vG9EU3KUJYWioOw+mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/239] crypto: qce - fix uaf on qce_ahash_register_one
Date:   Mon, 24 Jan 2022 19:41:34 +0100
Message-Id: <20220124183944.913708574@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit b4cb4d31631912842eb7dce02b4350cbb7562d5e ]

Pointer base points to sub field of tmpl, it
is dereferenced after tmpl is freed. Fix
this by accessing base before free tmpl.

Fixes: ec8f5d8f ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Acked-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qce/sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index d8a5db11b7ea1..bffd4d15145d9 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -521,8 +521,8 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 
 	ret = crypto_register_ahash(alg);
 	if (ret) {
-		kfree(tmpl);
 		dev_err(qce->dev, "%s registration failed\n", base->cra_name);
+		kfree(tmpl);
 		return ret;
 	}
 
-- 
2.34.1



