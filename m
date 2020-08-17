Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46290246B58
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbgHQPxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387910AbgHQPxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:53:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6739F20888;
        Mon, 17 Aug 2020 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679595;
        bh=5jBy9Sbw6TZGfmZD9NAK0ySdYA0L+padKW5xd+QSurk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1sjrypCjeyUlOcIOkdMfTyRpOe6KG+WYI2w+IHqR01bY40is3A3DeIj3RHs4ovOv
         sM94DMENLx3pg7kMk8wA6rku8Fg4cC9KRznQ1qHpZxZWreXBZI2uEmednqNx2BQeyu
         giB7ZCGqe1ZpYWt8dMu2BThxE+fG9o0u3OWbsdMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 269/393] nvmem: sprd: Fix return value of sprd_efuse_probe()
Date:   Mon, 17 Aug 2020 17:15:19 +0200
Message-Id: <20200817143832.668352549@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit bcd14bb7a68520bf88e45e91d354e43535624f82 ]

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Fixes: 096030e7f449 ("nvmem: sprd: Add Spreadtrum SoCs eFuse support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200722100705.7772-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/sprd-efuse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/sprd-efuse.c b/drivers/nvmem/sprd-efuse.c
index 925feb21d5adf..59523245db8a5 100644
--- a/drivers/nvmem/sprd-efuse.c
+++ b/drivers/nvmem/sprd-efuse.c
@@ -378,8 +378,8 @@ static int sprd_efuse_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	efuse->base = devm_platform_ioremap_resource(pdev, 0);
-	if (!efuse->base)
-		return -ENOMEM;
+	if (IS_ERR(efuse->base))
+		return PTR_ERR(efuse->base);
 
 	ret = of_hwspin_lock_get_id(np, 0);
 	if (ret < 0) {
-- 
2.25.1



