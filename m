Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8580A499FC9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842158AbiAXXBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836502AbiAXWjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D35C05487B;
        Mon, 24 Jan 2022 13:02:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FF8DB81057;
        Mon, 24 Jan 2022 21:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43410C340E5;
        Mon, 24 Jan 2022 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058142;
        bh=bCeEhGuG5ikUYPFJUmhaGVS1E5RTYSCU4SD7VpkViHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMmMU0O/o/nxPIbqAKYMsYj9DgMDX5MdLuKrj6zaWatfUV8xcV95c3tUp5zposPTg
         PlZUy3rvhSzGDBVeMDQ3pIeTzxNLSlzoBXLJDj2A0KF5FBQqv6Stz32OgtF95Zd3VV
         LwoTkt7Q54ZTPKueXuKUc21oFYjw/DIwVDv0bofw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0161/1039] crypto: qce - fix uaf on qce_skcipher_register_one
Date:   Mon, 24 Jan 2022 19:32:30 +0100
Message-Id: <20220124184130.616224478@linuxfoundation.org>
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

[ Upstream commit e9c195aaeed1b45c9012adbe29dedb6031e85aa8 ]

Pointer alg points to sub field of tmpl, it
is dereferenced after tmpl is freed. Fix
this by accessing alg before free tmpl.

Fixes: ec8f5d8f ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Acked-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qce/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 8ff10928f581d..3d27cd5210ef5 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -484,8 +484,8 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 
 	ret = crypto_register_skcipher(alg);
 	if (ret) {
-		kfree(tmpl);
 		dev_err(qce->dev, "%s registration failed\n", alg->base.cra_name);
+		kfree(tmpl);
 		return ret;
 	}
 
-- 
2.34.1



