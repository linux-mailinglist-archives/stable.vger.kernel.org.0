Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011676E3074
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 12:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDOKME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 06:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDOKMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 06:12:03 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E352D4A;
        Sat, 15 Apr 2023 03:12:01 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pz8CV1cCLz17SYJ;
        Sat, 15 Apr 2023 18:08:22 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 18:11:59 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 5.10 3/4] crypto: api - Export crypto_boot_test_finished
Date:   Sat, 15 Apr 2023 18:11:57 +0800
Message-ID: <20230415101158.1648486-4-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
References: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

We need to export crypto_boot_test_finished in case api.c is
built-in while algapi.c is built as a module.

Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au> # ppc32 build
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/api.c b/crypto/api.c
index 0e7a255252ca..7ddfe946dd56 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -32,6 +32,7 @@ BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
 DEFINE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+EXPORT_SYMBOL_GPL(crypto_boot_test_finished);
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
 
-- 
2.25.1

