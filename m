Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44622F15ED
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbhAKNq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbhAKNKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CCCD2250F;
        Mon, 11 Jan 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370611;
        bh=QvmCKY8dUPY2jKimtVqqmR5Ges0Ofd9MXp7WqARN9WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0onDa6eVhctpvBcmYnXkoAC2o7eKLcM1gBx58ZiW9gsFJMhwc4yngE3r/8xqISzF
         2iRv+5EhwIhmCKSdopsVUMjSfmX0PjiznnLWlY7tNn0SSADYfpKxOxl2JCTS6FiOvk
         mdC98tP3kKFk4fFtA2ZzjOtJRfu3Q/GtU5nhgxYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 20/92] net: ethernet: mvneta: Fix error handling in mvneta_probe
Date:   Mon, 11 Jan 2021 14:01:24 +0100
Message-Id: <20210111130040.128418421@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 58f60329a6be35a5653edb3fd2023ccef9eb9943 ]

When mvneta_port_power_up() fails, we should execute
cleanup functions after label err_netdev to avoid memleak.

Fixes: 41c2b6b4f0f80 ("net: ethernet: mvneta: Add back interface mode validation")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20201220082930.21623-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4694,7 +4694,7 @@ static int mvneta_probe(struct platform_
 	err = mvneta_port_power_up(pp, pp->phy_interface);
 	if (err < 0) {
 		dev_err(&pdev->dev, "can't power up port\n");
-		return err;
+		goto err_netdev;
 	}
 
 	/* Armada3700 network controller does not support per-cpu


