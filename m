Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988DE3CA84F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242145AbhGOTAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242326AbhGOS7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 167FE613F5;
        Thu, 15 Jul 2021 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375391;
        bh=lBjcw4sOunxgl3Hqp9I4bME8z73756FTDxGKXLgCxdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xz7j2Zbq9fyJAsk4Fv3fWaAA5OWffaSTNSLNxREjqtCyVLQXJpOFk4FYzdEX41iDO
         wJ/2KvpbQ5hMUYQRSyPzCmN/mrc5Qdest4xLJHXOISqDoryhI40u+Ooq30zf2y0LBz
         rGPIwAhCLS/ijfFoz72thQksvvI6xT4TKSxVSyqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 065/242] net: mscc: ocelot: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:07 +0200
Message-Id: <20210715182603.977559478@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f1fe19c2cb3fdc92a614cf330ced1613f8f1a681 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 84f93a874d50..deae923c8b7a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1206,6 +1206,11 @@ static int seville_probe(struct platform_device *pdev)
 	felix->info = &seville_info_vsc9953;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		dev_err(&pdev->dev, "Invalid resource\n");
+		goto err_alloc_felix;
+	}
 	felix->switch_base = res->start;
 
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
-- 
2.30.2



