Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4441F0E7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbfEOLXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbfEOLXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 156A520862;
        Wed, 15 May 2019 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919422;
        bh=sArjO93LdjXnGm7f5fCgwScBap13y8eJduemGfPgfn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GG6THTIzDABEUTvVGbftWogPaBzTNhibcZzq7e4AqEl7ZWHHkGFDtbCzjE+cbquLz
         iUoiIkCjfwZ3Z8AwQAn09jc4BWAWaS6OdRH9zPc8/ILaweZPFWVmZoHqhamJCcsm3G
         qALKnliX7s9id0lx/6zCYZDO42khRZaMQY7SErAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/113] ocelot: Dont sleep in atomic context (irqs_disabled())
Date:   Wed, 15 May 2019 12:55:33 +0200
Message-Id: <20190515090656.813206864@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8fd48b50deaa20808bbf0f6685f6f1acba6a64c ]

Preemption disabled at:
 [<ffff000008cabd54>] dev_set_rx_mode+0x1c/0x38
 Call trace:
 [<ffff00000808a5c0>] dump_backtrace+0x0/0x3d0
 [<ffff00000808a9a4>] show_stack+0x14/0x20
 [<ffff000008e6c0c0>] dump_stack+0xac/0xe4
 [<ffff0000080fe76c>] ___might_sleep+0x164/0x238
 [<ffff0000080fe890>] __might_sleep+0x50/0x88
 [<ffff0000082261e4>] kmem_cache_alloc+0x17c/0x1d0
 [<ffff000000ea0ae8>] ocelot_set_rx_mode+0x108/0x188 [mscc_ocelot_common]
 [<ffff000008cabcf0>] __dev_set_rx_mode+0x58/0xa0
 [<ffff000008cabd5c>] dev_set_rx_mode+0x24/0x38

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0bdd3c400c92f..10291198decd6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -605,7 +605,7 @@ static int ocelot_mact_mc_add(struct ocelot_port *port,
 			      struct netdev_hw_addr *hw_addr)
 {
 	struct ocelot *ocelot = port->ocelot;
-	struct netdev_hw_addr *ha = kzalloc(sizeof(*ha), GFP_KERNEL);
+	struct netdev_hw_addr *ha = kzalloc(sizeof(*ha), GFP_ATOMIC);
 
 	if (!ha)
 		return -ENOMEM;
-- 
2.20.1



