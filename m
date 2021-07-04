Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997033BB034
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhGDXHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhGDXHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAF6F613F7;
        Sun,  4 Jul 2021 23:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439909;
        bh=PSs5cy0RCkRQ16C5q7tq+WiiFC2xtuPb+rvXojn2J8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hynFwRkKHyLikdoEC0kT9bold7R1vTZDv/4AQXgX6A2hfpVCwd6BcJMyJ/WPF5qk1
         vSyEvx+IngbZAdVS9gbt6ylXr2xJN2KB14xxDzllh+qstIvS2QNgaNQ89WvSCDXR4U
         oSRzLMn3MmvPBRPVmduTCJUkm+yaKh+Ve/okUm0bmM5+7ZMhd1T/7lK4i3gdPSPfZv
         VJhDOrt+ipxmtHhp3Mw8rSdn6lHc7lyrk89XHLTsTzVMgFhUGg49o4r2Ayqhu62rw/
         rIRyBBRhr2S7bO2V97jZWQD5mPvKWUw8GPBjq5bG3GziV9zQB9exBVYF2tS3WgYir9
         8cDWh/SAmcOiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 35/85] crypto: ecdh - fix 'ecdh_init'
Date:   Sun,  4 Jul 2021 19:03:30 -0400
Message-Id: <20210704230420.1488358-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

