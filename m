Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD17A1BC81A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgD1S3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728830AbgD1S32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B210E20BED;
        Tue, 28 Apr 2020 18:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098568;
        bh=xpwDsCfS3zIF5dfKKclGV4PJdtCcREpav8/rEli1pbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzjwOx6ENaAiVYc9v72TqI+bfWic41RF806QnpMF/82R2UoKL0x6RADAkcKmqhIjz
         PaJ90vXNQtKX4cFrVvYRUunx2tt0HpSNlpxR4kQo0dlNdTYg8x8IaMfDCUsfrx0tsp
         k9rwchKFZMDJTy55R7+5OUnp5je+NzVVUYIQFPTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 074/167] net: ethernet: ixp4xx: Add error handling in ixp4xx_eth_probe()
Date:   Tue, 28 Apr 2020 20:24:10 +0200
Message-Id: <20200428182234.302058926@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 6ed79cec3ced6e346a10a70120fcee5f03591bab ]

The function ixp4xx_eth_probe() does not perform sufficient error
checking after executing devm_ioremap_resource(), which can result
in crashes if a critical error path is encountered.

Fixes: f458ac479777 ("ARM/net: ixp4xx: Pass ethernet physical base as resource")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1387,6 +1387,8 @@ static int ixp4xx_eth_probe(struct platf
 		return -ENODEV;
 	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(port->regs))
+		return PTR_ERR(port->regs);
 
 	switch (port->id) {
 	case IXP4XX_ETH_NPEA:


