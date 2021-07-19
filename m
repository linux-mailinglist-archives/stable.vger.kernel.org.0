Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8333CDD09
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242604AbhGSOzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237763AbhGSOxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5CE66023D;
        Mon, 19 Jul 2021 15:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708759;
        bh=BWbovSeleP+13YKyyMF9Bk0Vz6wSOE/Oril6tgSYl68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcaBueU4KiLrYaQ5LcPkeLO+uM256sUlMckUih9wzPp7egRB1cndeL2om3CweiZsM
         TrjJVzqy+muBSFjQ5kv0YLnUwpULvHV6Ww8kgVMgz8GguGVH4W7sxKEGA6VwmnDuOo
         aCArVOUc/aTyav6pedhnLfvveTrTnUZtLpoChmLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/421] net: mvpp2: Put fwnode in error case during ->probe()
Date:   Mon, 19 Jul 2021 16:48:51 +0200
Message-Id: <20210719144950.713424689@linuxfoundation.org>
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

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 71f0891c84dfdc448736082ab0a00acd29853896 ]

In each iteration fwnode_for_each_available_child_node() bumps a reference
counting of a loop variable followed by dropping in on a next iteration,

Since in error case the loop is broken, we have to drop a reference count
by ourselves. Do it for port_fwnode in error case during ->probe().

Fixes: 248122212f68 ("net: mvpp2: use device_*/fwnode_* APIs instead of of_*")
Cc: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index bc5cfe062b10..e65750b3c44f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5314,6 +5314,8 @@ static int mvpp2_probe(struct platform_device *pdev)
 	return 0;
 
 err_port_probe:
+	fwnode_handle_put(port_fwnode);
+
 	i = 0;
 	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
 		if (priv->port_list[i])
-- 
2.30.2



