Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C6667640
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbjALOa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjALO16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:27:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA758305
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1EA5B81DB2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BD8C433D2;
        Thu, 12 Jan 2023 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533136;
        bh=2s8+8v+kwfXxbFXzf6BDPF3hKKV7A9BpshUDpveIOhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJY6rBfarAqGkhukFst3ZIbQx4TDLQaUabWPgo8wDrU88Jt6T3g6dJu+2mSsO04pY
         WvfUXIQEn6MPnH1iQHYxkhhKZbfPPeRYqKSRZtEIiHSwgckLTOcgdYYZoYznSIy9Pp
         UgHXbmNVcpxf1ypJT2uMqjQWZeasY4tuGmtjgPwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/783] i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe
Date:   Thu, 12 Jan 2023 14:51:38 +0100
Message-Id: <20230112135542.004072856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index f614cade432b..30e38bc8b6db 100644
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



