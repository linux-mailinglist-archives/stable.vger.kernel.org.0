Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC873CAA01
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbhGOTLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242726AbhGOTIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6E8613E9;
        Thu, 15 Jul 2021 19:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375883;
        bh=ObAFjK18truRzozmZTUYHgyUs896X41mEoMJYQq6MB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtCL6lmoft7P0/VQgOL3Pxr6x6P23ZVPd0dLeDZAEryedOFUbmTeLoXwNdrY2EtqS
         fwvQz5Mn/goyIi1BjtTZXFFwS7BWhD698/0cF1wBUMXKgYRbI7NHqfAEQqky4ZC2C/
         uqNZBwngW8vphx1SAW+R/uP0RYh7ID2Gex2fNLT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 035/266] net: xilinx_emaclite: Do not print real IOMEM pointer
Date:   Thu, 15 Jul 2021 20:36:30 +0200
Message-Id: <20210715182620.521155229@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d0d62baa7f505bd4c59cd169692ff07ec49dde37 ]

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() warn:
 argument 4 to %08lX specifier is cast from pointer

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index d9d58a7dabee..b06377fe7293 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1189,9 +1189,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08lX mapped to 0x%08lX, irq=%d\n",
-		 (unsigned long __force)ndev->mem_start,
-		 (unsigned long __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08lX mapped to 0x%p, irq=%d\n",
+		 (unsigned long __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
 error:
-- 
2.30.2



