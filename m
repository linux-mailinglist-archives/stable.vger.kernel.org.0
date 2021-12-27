Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4970447FE8C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbhL0PaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34732 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237803AbhL0P3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 478BBB810BF;
        Mon, 27 Dec 2021 15:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666CDC36AE7;
        Mon, 27 Dec 2021 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618976;
        bh=K2Ods+oq2wv6X794eF4GcT61PEHwtcVtk2f+yKyh+ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEd4KzsOCdfT+nrSINYahUTA3oGW4lunPdnGVq9ME/w4axqhoz/0gF76Dr21Lb0Oy
         zgrxppoDRGh+f/KtOc+1q0dBqcAC04zQekOugXE1vuwNi1pFxHcTK7K8RTdGDJmecy
         P0PLaWFdagYwCWq0uJ4VJ+IoS8+8mAGsykkK4iBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/29] fjes: Check for error irq
Date:   Mon, 27 Dec 2021 16:27:21 +0100
Message-Id: <20211227151318.839578917@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
index 26d3051591dac..9e8add3d93adc 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1284,6 +1284,11 @@ static int fjes_probe(struct platform_device *plat_dev)
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



