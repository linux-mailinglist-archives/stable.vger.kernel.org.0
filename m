Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5437CE94
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345022AbhELRFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234792AbhELQq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98DAA61E7D;
        Wed, 12 May 2021 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836116;
        bh=5/ncMbpgCY+TRWUjToufXs5WDeDGMn8rE0mi7Gjxl8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPlnJX2Z8n4gRi5tChmqqBNT7m2fRuJ2oql0eqaNqHlxWIOMDRri8G7DCaPYIxYV3
         yxdKT1vtBOFP5SShlIGHX0muGNKg0RUDlV2cD3FIQIzsJiT1/+zRuKPRarOBP0v87+
         bm7y/zbILWQfQLx4EcBg39iMwnulml2mGNSqll4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 617/677] nfp: devlink: initialize the devlink port attribute "lanes"
Date:   Wed, 12 May 2021 16:51:03 +0200
Message-Id: <20210512144857.871362913@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 713ee3041d49..bea978df7713 100644
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



