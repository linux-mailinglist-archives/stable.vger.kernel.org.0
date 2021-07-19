Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CC03CDDFD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345348AbhGSPBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344437AbhGSO7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C855961002;
        Mon, 19 Jul 2021 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709217;
        bh=Ev6q87NjZyTZuJ9GPbmdDzgZN7HeAbVldkXVmGDfPB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZwLmHklzqbHgtXJjpqYgu8eVww9UxacGbL1PTC1vabsyRkYRPSnfZgtg96d+SmPc
         mJgt8DlnUJvQEgaRqOnjNsGbgpf3+sjaR/emRMt6uyP/M+lFVaB3+T60tN+3d6cbhP
         NexmQOp3mtYchYAl1akMpLJunLZz+QLguAMeCDqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/421] fjes: check return value after calling platform_get_resource()
Date:   Mon, 19 Jul 2021 16:51:03 +0200
Message-Id: <20210719144955.133778269@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 1979f8f8dac7..778d3729f460 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1277,6 +1277,10 @@ static int fjes_probe(struct platform_device *plat_dev)
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



