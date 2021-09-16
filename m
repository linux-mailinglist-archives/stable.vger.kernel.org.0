Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B2240E0DE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhIPQZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241777AbhIPQXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57456147F;
        Thu, 16 Sep 2021 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808937;
        bh=pfIM1sb5WYITdf6EuMAizbFU1tqBjQht/YjME59ikzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+cVeSNFtSvUTik+dqkyDn5AqW/GQ916XNl1RvAOeuRy14pa333IAcLEDGrHELn4h
         a/GQWX5LECZU95GgkwbjlHE8iHYeKeAdYToz8/0LjLuP1/K2BYiLjZOSgr9z+hKF4m
         o0I/HpZIxYffGLdb6ggBWugI2LwK4OZFEAWYKYLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/306] net: w5100: check return value after calling platform_get_resource()
Date:   Thu, 16 Sep 2021 18:00:21 +0200
Message-Id: <20210916155803.484331488@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a39ff4a47f3e1da3b036817ef436b1a9be10783a ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wiznet/w5100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index c0d181a7f83a..0b7135a3c585 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1052,6 +1052,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
-- 
2.30.2



