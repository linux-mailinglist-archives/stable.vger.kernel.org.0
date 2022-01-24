Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB11499260
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344786AbiAXUTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:19:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41546 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380669AbiAXUQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:16:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26C01613FB;
        Mon, 24 Jan 2022 20:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA1C340E7;
        Mon, 24 Jan 2022 20:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055401;
        bh=mt0KdQ610w0e3Y/eYKlgO6C5fSV+AQItylCNXXm/KYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkgCLwvacuxflqq+4rKMuwwSfJLIWb7GpIc6TZH1Mk9dangRlm/uOXgQDWEz0Gl/+
         +uxuCKbtTE5eGNHRvHq1TCJjcKvoq5dvsf7pBfv6hiVp5mgcV+Mb8PVbaDl+u8EICo
         gw7lsRL7O7BgjPBuk0Rtg6I41l4jEtEMTUXkTDME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/846] crypto: qce - fix uaf on qce_ahash_register_one
Date:   Mon, 24 Jan 2022 19:34:16 +0100
Message-Id: <20220124184105.788252936@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 8e6fcf2c21cc0..59159f5e64e52 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -498,8 +498,8 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 
 	ret = crypto_register_ahash(alg);
 	if (ret) {
-		kfree(tmpl);
 		dev_err(qce->dev, "%s registration failed\n", base->cra_name);
+		kfree(tmpl);
 		return ret;
 	}
 
-- 
2.34.1



