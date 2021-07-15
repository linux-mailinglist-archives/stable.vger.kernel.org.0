Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C24B3CA62B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhGOSq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238109AbhGOSq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:46:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26718613CC;
        Thu, 15 Jul 2021 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374612;
        bh=iQuNtrz8wjlsTe62AYtmmRArf0A0Q00ObZJPInEUwrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jApr3yNCh67eW5ka6QOkLXjEYndcorHHlxaQiCFyKiXY1ob9R1ubsDFBgZRDLZLPc
         /RV9VsCAAVFXGN+PIWVpX7uXrqAiwUtgK8xxNFKiiHSzss/0Pei7be8hvKYCnuo9S3
         RJ6iKFs0hd2OUpAyOoDBlNcvD0JmctMu6EOEoZRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/122] net: micrel: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:57 +0200
Message-Id: <20210715182456.684693889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 20f1932e2282c58cb5ac59517585206cf5b385ae ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8842.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index da329ca115cc..fb838e29d52d 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1136,6 +1136,10 @@ static int ks8842_probe(struct platform_device *pdev)
 	unsigned i;
 
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	if (!request_mem_region(iomem->start, resource_size(iomem), DRV_NAME))
 		goto err_mem_region;
 
-- 
2.30.2



