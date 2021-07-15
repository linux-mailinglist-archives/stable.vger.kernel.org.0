Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8853CAA4D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243802AbhGOTMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243871AbhGOTKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0EF561370;
        Thu, 15 Jul 2021 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376024;
        bh=OUttnZfZ2XueT8ypLeni7GSulhpsz4hmA/8lKqb26xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F93gk/Pc/92n22Ydj+96OTcPh+kxwuTWMh+8wagzahtXJKFE9L7nFhFDaZlVAfwbr
         wxxs9Y6N1oWvg8dtpyejQZLFfseu0AFPxxkMV3m5VeCeb06xoEvGNRy/kwZKukc+5e
         cStzU8XACIjsoaKpyoBqtLNT/EyPuz6UoCU64bRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 094/266] net: mido: mdio-mux-bcm-iproc: Use devm_platform_get_and_ioremap_resource()
Date:   Thu, 15 Jul 2021 20:37:29 +0200
Message-Id: <20210715182630.712084685@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8a55a73433e763c8aec4a3e8df5c28c821fc44b9 ]

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mux-bcm-iproc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 03261e6b9ceb..aa29d6bdbdf2 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -187,7 +187,9 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	md->dev = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	md->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(md->base))
+		return PTR_ERR(md->base);
 	if (res->start & 0xfff) {
 		/* For backward compatibility in case the
 		 * base address is specified with an offset.
@@ -196,9 +198,6 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		res->start &= ~0xfff;
 		res->end = res->start + MDIO_REG_ADDR_SPACE_SIZE - 1;
 	}
-	md->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(md->base))
-		return PTR_ERR(md->base);
 
 	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!md->mii_bus) {
-- 
2.30.2



