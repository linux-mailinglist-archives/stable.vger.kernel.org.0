Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583A83CDE15
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345368AbhGSPBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344015AbhGSO71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D76A760FE9;
        Mon, 19 Jul 2021 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709100;
        bh=WtqPB5MKbb9f4Znuqs7cgBs3WXwdAkg9h1wOf5Br/vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzc5MhXiIt7HyS8BsGO7JEoAaEnuDhloRc2UOVOJ6bE1orq/lO6JbFFknwkLAdulO
         cs8R6j7gpvssWhF9s4jSu3OjVuN1mrSy8mAOm4BMVguVRxGCtxfLyde6uV6Za3o7iQ
         wfQYtEh6npM8K5kJOOeJ195XNfcEOv2gkMA2EA38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 251/421] net: micrel: check return value after calling platform_get_resource()
Date:   Mon, 19 Jul 2021 16:51:02 +0200
Message-Id: <20210719144955.103618720@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index e3d7c74d47bb..5282c5754ac1 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1150,6 +1150,10 @@ static int ks8842_probe(struct platform_device *pdev)
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



