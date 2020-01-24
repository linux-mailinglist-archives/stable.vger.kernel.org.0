Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E57147E39
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbgAXKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbgAXKHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:07:13 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4FBD20709;
        Fri, 24 Jan 2020 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860433;
        bh=vQ+uH/cOpmr1AdzpkBSN4ch2fbW/9SWdayHvKdMzYHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpfYSksOJ5loFjfqxfdVndYQOb5cqWYsVTjFnYdiHQJAED5yKdwgq2MCs/s5En4L6
         YLS0xrahGXRYkrz8Wg+7OQzQWaiFQP9oD6IL3NdkSJz89kc+jFbkNXFc3T4o/X4oRG
         VvMK+PeZKTrKs9tRF9YnVx7GnNqkNTkSl+1rjQcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 312/343] net: axienet: fix a signedness bug in probe
Date:   Fri, 24 Jan 2020 10:32:10 +0100
Message-Id: <20200124093000.921837913@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 73e211e11be86715d66bd3c9d38b3c34b05fca9a ]

The "lp->phy_mode" is an enum but in this context GCC treats it as an
unsigned int so the error handling is never triggered.

Fixes: ee06b1728b95 ("net: axienet: add support for standard phy-mode binding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9ccd08a051f6a..1152d74433f6e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1574,7 +1574,7 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 	} else {
 		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-		if (lp->phy_mode < 0) {
+		if ((int)lp->phy_mode < 0) {
 			ret = -EINVAL;
 			goto free_netdev;
 		}
-- 
2.20.1



