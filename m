Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A4437C63F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhELPty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235262AbhELPn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:43:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525FD61C89;
        Wed, 12 May 2021 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832944;
        bh=nYdm/1Foq3zpi5pSmv6cBeYEM0UPepIDimfFb/6Wdd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ie1J/802xWGo0eY7Bq30SIJSYaYoy+PgZzaaM1IBO7TDk+MehD4vSv+vXxE2S8eba
         JYA5qalUOOo1fIlJ4aXklATTcWgOdS71IBnA914oS299CnHhI/6zFLa+FoDDi2F5hk
         o3BvHk73LQuhdW/WdVr2PGsrOckrbRD5G71XPGn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/530] nfp: devlink: initialize the devlink port attribute "lanes"
Date:   Wed, 12 May 2021 16:49:49 +0200
Message-Id: <20210512144835.499815048@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit 90b669d65d99a3ee6965275269967cdee4da106e ]

The number of lanes of devlink port should be correctly initialized
when registering the port, so that the input check when running
"devlink port split <port> count <N>" can pass.

Fixes: a21cf0a8330b ("devlink: Add a new devlink port lanes attribute and pass to netlink")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 97d2b03208de..7a8187458724 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -364,6 +364,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 
 	attrs.split = eth_port.is_split;
 	attrs.splittable = !attrs.split;
+	attrs.lanes = eth_port.port_lanes;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
 	attrs.phys.split_subport_number = eth_port.label_subport;
-- 
2.30.2



