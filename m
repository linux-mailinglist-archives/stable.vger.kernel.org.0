Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D9966C78F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjAPQb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjAPQbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:31:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B151A2F7A7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:19:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D2A2B80E93
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE61C433F0;
        Mon, 16 Jan 2023 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885985;
        bh=/SommzC+MzCCr7Wuu8teBOrT7fZnRCyG4DGmQ/rucm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLxVNsjJHvGmW71TU8iM0ydCHzwLR5luJ63MhQB+ZvPchUJbxf5VD3qdZnusNGok+
         1xk4kueiG4OfWTnKrXPi8B3HjTVtHfXgz2ZRoQ15UfNLpWQyoahRR2YGMBtPKekcm7
         pQI3v2OhfvEhaG4sIAxsubtRtD449G8YogvvLSYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/658] crypto: ccree - Remove debugfs when platform_driver_register failed
Date:   Mon, 16 Jan 2023 16:45:39 +0100
Message-Id: <20230116154921.038059198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 4f1c596df706c9aca662b6c214fad84047ae2a97 ]

When platform_driver_register failed, we need to remove debugfs,
which will caused a resource leak, fix it.

Failed logs as follows:
[   32.606488] debugfs: Directory 'ccree' with parent '/' already present!

Fixes: 4c3f97276e15 ("crypto: ccree - introduce CryptoCell driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 58ca59af0b2e..3d59fef1fbee 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -653,9 +653,17 @@ static struct platform_driver ccree_driver = {
 
 static int __init ccree_init(void)
 {
+	int rc;
+
 	cc_debugfs_global_init();
 
-	return platform_driver_register(&ccree_driver);
+	rc = platform_driver_register(&ccree_driver);
+	if (rc) {
+		cc_debugfs_global_fini();
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ccree_init);
 
-- 
2.35.1



