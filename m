Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148713CA72A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhGOSwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238823AbhGOSwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B2E613DB;
        Thu, 15 Jul 2021 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374952;
        bh=pAh9sS9KTHjr0pvKpZxLQ/hvbf6Z1ptRKk+fyiUulUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebr3WefdCffb07R2AFHEC/LtwFBnZ9gMZcIspeu1hUPpjfeBLq7qr/K2Ea8YH+OBI
         mixeQWMel0yyTGnsjSSZdpaa2jTAfGZmE3fKtSVBh3wlWRyTiwJbnowzPctoE8ZnRQ
         ZKr1R4E9h+gRsQetcHj1AColbTelvVF+VvSg7vLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/215] net: mscc: ocelot: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:11 +0200
Message-Id: <20210715182609.888585912@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index ebbaf6817ec8..7026523f886c 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1214,6 +1214,11 @@ static int seville_probe(struct platform_device *pdev)
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



