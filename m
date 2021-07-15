Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C4D3CA868
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbhGOTBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242701AbhGOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF4C610C7;
        Thu, 15 Jul 2021 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375419;
        bh=KZaRLMtRE0FWoJ0aN/q7uQVN7VWE0e1ynuofh4g/AEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVnIU08qL/B74nKqc7tVZq7SptYCHXikDStjnSa+W8XDqg2suLf+9l+OAUzrxgm/2
         QzGNkrroxw6j+aAEtRVGtOakMQZPNuiWRSMIb2Vv8mTQ16FJgiOKeSazCUPQLdSJpQ
         DMvm1wO1qQLLapn/Rced3a/BQFCIUEqSNWZQO8RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 080/242] fjes: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:22 +0200
Message-Id: <20210715182607.074549182@linuxfoundation.org>
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

[ Upstream commit f18c11812c949553d2b2481ecaa274dd51bed1e7 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fjes/fjes_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 466622664424..e449d9466122 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1262,6 +1262,10 @@ static int fjes_probe(struct platform_device *plat_dev)
 	adapter->interrupt_watch_enable = false;
 
 	res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		goto err_free_control_wq;
+	}
 	hw->hw_res.start = res->start;
 	hw->hw_res.size = resource_size(res);
 	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
-- 
2.30.2



