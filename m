Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD62498F50
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346909AbiAXTv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346328AbiAXT07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37559B81235;
        Mon, 24 Jan 2022 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C950C340E5;
        Mon, 24 Jan 2022 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052417;
        bh=N32OVYcY/f1gbuRqAcysnzXSOICorRmIH14nLnx0rl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1OKTi7ZbxR3sWSY+dB0fVAvhP0XcrlN2efKLy6wXuZ+r9ExGPaDcBWz6DIsM0ePHk
         VXIuShcuMfbit6KZHlj7i3twmNylCrGGrZ/g7M4pW//sLl/VYpRO314JzcsFVTJDwy
         4xo3Z1seZpBWhZu4aB3pLw21CEQN7qreHyieAqW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/320] crypto: qce - fix uaf on qce_ahash_register_one
Date:   Mon, 24 Jan 2022 19:40:35 +0100
Message-Id: <20220124183955.475962978@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 0853e74583ade..29b0bad2507b1 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -512,8 +512,8 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 
 	ret = crypto_register_ahash(alg);
 	if (ret) {
-		kfree(tmpl);
 		dev_err(qce->dev, "%s registration failed\n", base->cra_name);
+		kfree(tmpl);
 		return ret;
 	}
 
-- 
2.34.1



