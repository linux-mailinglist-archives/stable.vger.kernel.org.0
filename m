Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC6847FE68
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhL0P2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbhL0P2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B82C061784;
        Mon, 27 Dec 2021 07:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6209F610A6;
        Mon, 27 Dec 2021 15:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D18C36AEB;
        Mon, 27 Dec 2021 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618911;
        bh=sCy5UTroEtnCKCLVeZa/SB2DDo6SeX8Am/dW5N+AiEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+ghzO74HmelLyf2nTVRpKBXMf68ZLDpDJsssZcjblcc/G3pvvrS97tRvjXCZxud9
         D6jkjMItOmxi/YYd5+2N0TeysyjJAyRfT+n2r7nxVc0DqMHdQ2SS4edEkXxHMWxfOJ
         UGAX1Gr4TuzECV5Nzea1rl0G6MPGxMujU//JUQ2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/19] fjes: Check for error irq
Date:   Mon, 27 Dec 2021 16:27:09 +0100
Message-Id: <20211227151316.792398775@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
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
index 440047a239f57..26bb43a675131 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1219,6 +1219,11 @@ static int fjes_probe(struct platform_device *plat_dev)
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



