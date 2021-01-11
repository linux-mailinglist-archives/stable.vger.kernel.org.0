Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FF62F1512
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbhAKNfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbhAKNOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4923321973;
        Mon, 11 Jan 2021 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370811;
        bh=pVjPnRGRrkyfNhyw85E2fzo6fGHo0T+GKH8Jl29FUw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8b70L9OQw9ZeVCQt8Iya43Q3+dyKZIsEm9YmnUUcucXDMK7DXSkihWeofoUSDF/P
         lZJXh5Z9RzTFctYnRTlaxW//1aL7j90QhIhRVq5IBXrF57jouWatZPw1CoSEOa8crU
         Rp6/W4JxDxbxj47yz7gxCATzq7yNBCsEWYIN8faQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 015/145] net: ethernet: mvneta: Fix error handling in mvneta_probe
Date:   Mon, 11 Jan 2021 14:00:39 +0100
Message-Id: <20210111130049.245602301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -5232,7 +5232,7 @@ static int mvneta_probe(struct platform_
 	err = mvneta_port_power_up(pp, pp->phy_interface);
 	if (err < 0) {
 		dev_err(&pdev->dev, "can't power up port\n");
-		return err;
+		goto err_netdev;
 	}
 
 	/* Armada3700 network controller does not support per-cpu


