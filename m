Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5966CACC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbjAPRHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjAPRHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:07:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E86C442F5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55776B81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AC8C433D2;
        Mon, 16 Jan 2023 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887684;
        bh=v/pGXbZDkN0N23YljSBK1cflGxJAOE2ONWuMpJwE6Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2goFhHU/1TiVEqZx9r3g8UjnS2L9KMY0LUxm9HjDDS0+xVXft4EnPX0cA0NKby5Zb
         x1k++6hdmUtGJ6ViQg21xKlEfNc5FxnA9fIpLrOAzzGexWJJnUBhY1oMeecxr5gKGN
         B+e9+15M/dhvZ4nkFX1ZRhjrNDK9h2/6dIBu5WJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/521] i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe
Date:   Mon, 16 Jan 2023 16:48:25 +0100
Message-Id: <20230116154858.015186781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit d78a167332e1ca8113268ed922c1212fd71b73ad ]

Using pcim_enable_device() to avoid missing pci_disable_device().

Fixes: 7e94dd154e93 ("i2c-pxa2xx: Add PCI support for PXA I2C controller")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa-pci.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
index 72ea8f4c61aa..883937c8408b 100644
--- a/drivers/i2c/busses/i2c-pxa-pci.c
+++ b/drivers/i2c/busses/i2c-pxa-pci.c
@@ -105,7 +105,7 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 	int i;
 	struct ce4100_devices *sds;
 
-	ret = pci_enable_device_mem(dev);
+	ret = pcim_enable_device(dev);
 	if (ret)
 		return ret;
 
@@ -114,10 +114,8 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 		return -EINVAL;
 	}
 	sds = kzalloc(sizeof(*sds), GFP_KERNEL);
-	if (!sds) {
-		ret = -ENOMEM;
-		goto err_mem;
-	}
+	if (!sds)
+		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(sds->pdev); i++) {
 		sds->pdev[i] = add_i2c_device(dev, i);
@@ -133,8 +131,6 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 
 err_dev_add:
 	kfree(sds);
-err_mem:
-	pci_disable_device(dev);
 	return ret;
 }
 
-- 
2.35.1



