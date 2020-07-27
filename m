Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801CC22EEE9
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgG0OLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbgG0OLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C2721775;
        Mon, 27 Jul 2020 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859105;
        bh=g/k/+eebFLLg+bq8uWIyE9YLJLGd/5lTSjMBtr8d9EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dz/FFmjuJtS7LHYwHKsexp2a4fUFSX9/tq4ST7l4WNyp4GFt3k3RgDYAEWa3McqbK
         6CiIiXSBpet5Smrf9KxP+SFkNE2tZcJuwsHx2BhqobovWelgt6st8HpZeLidw3inGu
         lbc4qMhsYi38y06wvDVZAhr8ZRiavVj89jD2cB/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/86] net: ethernet: ave: Fix error returns in ave_init
Date:   Mon, 27 Jul 2020 16:04:11 +0200
Message-Id: <20200727134916.293591334@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 1264d7fa3a64d8bea7aebb77253f917947ffda25 ]

When regmap_update_bits failed in ave_init(), calls of the functions
reset_control_assert() and clk_disable_unprepare() were missed.
Add goto out_reset_assert to do this.

Fixes: 57878f2f4697 ("net: ethernet: ave: add support for phy-mode setting of system controller")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/sni_ave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index c309accc6797e..01cde5f27eade 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1196,7 +1196,7 @@ static int ave_init(struct net_device *ndev)
 	ret = regmap_update_bits(priv->regmap, SG_ETPINMODE,
 				 priv->pinmode_mask, priv->pinmode_val);
 	if (ret)
-		return ret;
+		goto out_reset_assert;
 
 	ave_global_reset(ndev);
 
-- 
2.25.1



