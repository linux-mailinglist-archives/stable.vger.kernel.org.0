Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F163CA711
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbhGOSwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235390AbhGOSvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F61613D8;
        Thu, 15 Jul 2021 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374896;
        bh=KZaRLMtRE0FWoJ0aN/q7uQVN7VWE0e1ynuofh4g/AEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zS2umLkXCyuALu4aVo8V/rsnKNm6q8nMRqVi39TXmhuJSrupGx8NNYVjAQS+hRCIy
         3IBOzQHnXdG8CF6e3u+uq5FU+BHJ4XJG52R8vTxbRzqJ7yrCN8jqGrHGSNBLQzTygw
         BQejquY6Sr/Q1EW1G/mxfllhMiBn0e2rQ95iW0TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/215] fjes: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:25 +0200
Message-Id: <20210715182612.356171948@linuxfoundation.org>
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



