Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB63CAA3F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243469AbhGOTMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243785AbhGOTKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B27BF613D1;
        Thu, 15 Jul 2021 19:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375989;
        bh=lxynscbsCQDk1myZDrdth+KqETVGa5AjuevgsM1C6+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMBL5xpuEm1JTCpVtahCXYY6HDMIyEIWiEU4nrfFxi+FEmn2rbvmB+uYblw8A844Y
         81FkVToBn68HQktdL/Ph/Ri98WWWqGLttjUINn8+ePcvYKCy8VQbLHK7GNpJgV+AKM
         iJ6p8YAOHDOr8W6GxYzkjmDn5ZZG0xqBEsne5ZtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/266] net: micrel: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:15 +0200
Message-Id: <20210715182628.294380721@linuxfoundation.org>
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
index caa251d0e381..b27713906d3a 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1135,6 +1135,10 @@ static int ks8842_probe(struct platform_device *pdev)
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



