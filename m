Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7B547FFA4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbhL0Pj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbhL0Phx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:37:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1686EC061759;
        Mon, 27 Dec 2021 07:37:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8522FCE10AF;
        Mon, 27 Dec 2021 15:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78374C36AEA;
        Mon, 27 Dec 2021 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619438;
        bh=3bELCSOYN5JdcH6fbxiuyoFk2x1jGY3BEgxliGvI5Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NA1lF5rwihTOQ/roajpFNfMAL7+1lFLSiB2JMYw8RLO2yLv/aUUxgz/vaMvGzJMRh
         CE6KhCPMhqC+189Gnkabg1kW94o0MykhdBeXxEfEflt6t3G9ifoeZkXR6OjSygVlYR
         6ry7JdPEN33DM8ZgbFkoXb+nGE+Nl72BwHFhGnDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/76] fjes: Check for error irq
Date:   Mon, 27 Dec 2021 16:30:38 +0100
Message-Id: <20211227151325.491786053@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit db6d6afe382de5a65d6ccf51253ab48b8e8336c3 ]

I find that platform_get_irq() will not always succeed.
It will return error irq in case of the failure.
Therefore, it might be better to check it if order to avoid the use of
error irq.

Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fjes/fjes_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index e449d94661225..2a569eea4ee8f 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1269,6 +1269,11 @@ static int fjes_probe(struct platform_device *plat_dev)
 	hw->hw_res.start = res->start;
 	hw->hw_res.size = resource_size(res);
 	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
+	if (hw->hw_res.irq < 0) {
+		err = hw->hw_res.irq;
+		goto err_free_control_wq;
+	}
+
 	err = fjes_hw_init(&adapter->hw);
 	if (err)
 		goto err_free_control_wq;
-- 
2.34.1



