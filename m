Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7E411CAC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347243AbhITRLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347038AbhITRJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C6A561351;
        Mon, 20 Sep 2021 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156989;
        bh=gwTZgU+vh4/6zPGmspWYrNE48AW3an6I9W51d8OLlSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+kdfOxGMgFPbXwNoGxzyDmaRyJABtn/PTaKHvuqe7f5iVNS9/5GF4k5X0BHFNPVY
         +lNvtmIlMRA0pLtpSFSOa4p6SkNASVthiqLMcfubTazC+LXZAXENLFfDI5uz4SYcD7
         SsqWFbpKpHvx57mzF3hyqndlEy2SDDq1z2pa39Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 147/175] net: w5100: check return value after calling platform_get_resource()
Date:   Mon, 20 Sep 2021 18:43:16 +0200
Message-Id: <20210920163922.881672740@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index d2349a1bc6ba..ae357aecb1eb 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1060,6 +1060,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
-- 
2.30.2



