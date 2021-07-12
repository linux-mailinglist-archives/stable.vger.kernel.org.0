Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204693C4973
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhGLGpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238164AbhGLGni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0796B61165;
        Mon, 12 Jul 2021 06:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071983;
        bh=enbGr/bKT6wnHYn7Kf73fmZILOU/Yp7VesL4rRc8mf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JzMphVo6Z81KihUYhZ2IesrBAIVoqiMkQNinHD7tUAGn3niWERbgOgA3uMYS8ozo
         Zz0zYxZeBy1WwgHnUWgUR71tYKQmwvZJCGdMtz317KDknhlnWFPZHiE3L6fwLC9wY7
         cZVpO/owXwV5c8GxjWSbQu8TklYIo/1NCiBNjgs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/593] net: mvpp2: Put fwnode in error case during ->probe()
Date:   Mon, 12 Jul 2021 08:07:45 +0200
Message-Id: <20210712060918.562240269@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 6aa13c9f9fc9..a9f65d667761 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7045,6 +7045,8 @@ static int mvpp2_probe(struct platform_device *pdev)
 	return 0;
 
 err_port_probe:
+	fwnode_handle_put(port_fwnode);
+
 	i = 0;
 	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
 		if (priv->port_list[i])
-- 
2.30.2



