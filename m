Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B707A2B62D4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732248AbgKQNcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbgKQNcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC5F21534;
        Tue, 17 Nov 2020 13:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619929;
        bh=5uCGPv3l1JQ83xg8vVMmx7zJvAr2bwHRiYAwhVTU/vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raZ+1buI4Q84Tf5zD4K2DC8giSjpMNItJGBosNelDWuvakgzLbfLc9p5s6Pta0a5z
         0Qcy4tAHfK1yuH1dT6SJOqsw7pOxv/pSSGidx8fVpRNxQLHEzhsCPLAjY2aktymcaQ
         5WER5S8CcPs5rh9ASNfhCLGQHNbhxGSny2vXwZe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 051/255] can: ti_hecc: ti_hecc_probe(): add missed clk_disable_unprepare() in error path
Date:   Tue, 17 Nov 2020 14:03:11 +0100
Message-Id: <20201117122141.436117069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit e002103b36a695f7cb6048b96da73e66c86ddffb ]

The driver forgets to call clk_disable_unprepare() in error path after
a success calling for clk_prepare_enable().

Fix it by adding a clk_disable_unprepare() in error path.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1594973079-27743-1-git-send-email-zhangchangzhong@huawei.com
Fixes: befa60113ce7 ("can: ti_hecc: add missing prepare and unprepare of the clock")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/ti_hecc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 94b1491b569f3..228ecd45ca6c1 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -950,7 +950,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	err = clk_prepare_enable(priv->clk);
 	if (err) {
 		dev_err(&pdev->dev, "clk_prepare_enable() failed\n");
-		goto probe_exit_clk;
+		goto probe_exit_release_clk;
 	}
 
 	priv->offload.mailbox_read = ti_hecc_mailbox_read;
@@ -959,7 +959,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	err = can_rx_offload_add_timestamp(ndev, &priv->offload);
 	if (err) {
 		dev_err(&pdev->dev, "can_rx_offload_add_timestamp() failed\n");
-		goto probe_exit_clk;
+		goto probe_exit_disable_clk;
 	}
 
 	err = register_candev(ndev);
@@ -977,7 +977,9 @@ static int ti_hecc_probe(struct platform_device *pdev)
 
 probe_exit_offload:
 	can_rx_offload_del(&priv->offload);
-probe_exit_clk:
+probe_exit_disable_clk:
+	clk_disable_unprepare(priv->clk);
+probe_exit_release_clk:
 	clk_put(priv->clk);
 probe_exit_candev:
 	free_candev(ndev);
-- 
2.27.0



