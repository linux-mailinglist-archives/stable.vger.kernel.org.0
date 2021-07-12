Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C563C521F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349857AbhGLHot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347829AbhGLHkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EADC61580;
        Mon, 12 Jul 2021 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075386;
        bh=PSs5cy0RCkRQ16C5q7tq+WiiFC2xtuPb+rvXojn2J8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/eYH3BOA2p1AkXMcURRA++IkKj8kcv+eSOxwUrdu0e8xoXSpjR/1lG1rUzIMKQY1
         yBg99ryhyUcuGbTMamuIWxJeNMP+7r9xShkKdP9Og0hu731VyRiP8iURUPwm4lxHYJ
         +wfnDUFOLffaMNfc1VhN9XStXAgy3AMkS3iL9pjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 160/800] crypto: ecdh - fix ecdh_init
Date:   Mon, 12 Jul 2021 08:03:03 +0200
Message-Id: <20210712060935.497811883@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 8fd28fa5046b377039d5bbc0ab2f625dec703980 ]

NIST P192 is not unregistered if failed to register NIST P256,
actually it need to unregister the algorithms already registered.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdh.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 4227d35f5485..e2c480859024 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -183,7 +183,16 @@ static int ecdh_init(void)
 	ret = crypto_register_kpp(&ecdh_nist_p192);
 	ecdh_nist_p192_registered = ret == 0;
 
-	return crypto_register_kpp(&ecdh_nist_p256);
+	ret = crypto_register_kpp(&ecdh_nist_p256);
+	if (ret)
+		goto nist_p256_error;
+
+	return 0;
+
+nist_p256_error:
+	if (ecdh_nist_p192_registered)
+		crypto_unregister_kpp(&ecdh_nist_p192);
+	return ret;
 }
 
 static void ecdh_exit(void)
-- 
2.30.2



