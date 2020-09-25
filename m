Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B97278815
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgIYMwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgIYMv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B3B21741;
        Fri, 25 Sep 2020 12:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038319;
        bh=/BGLC5wKa1UuaYv394/oS8DzjMVji2z+8SKIu8l2KFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci5m1EqWqOOeAX+bXq0fPa0Ex0EyHUosZpEOf+zx2icjntcIVjVtBktyu9eWRFRVf
         /+z+zbAyoKuDXh4AavNBZilt0aSF8NpEqVXe1x7iRLhM04+Y2KxQlR7VsklV3Zrdxu
         DsKWsHEAtA40rRrg1wnghpCZ812XJDLTa02mE9nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 25/43] nfp: use correct define to return NONE fec
Date:   Fri, 25 Sep 2020 14:48:37 +0200
Message-Id: <20200925124727.398993012@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5f6857e808a8bd078296575b417c4b9d160b9779 ]

struct ethtool_fecparam carries bitmasks not bit numbers.
We want to return 1 (NONE), not 0.

Fixes: 0d0870938337 ("nfp: implement ethtool FEC mode settings")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -731,8 +731,8 @@ nfp_port_get_fecparam(struct net_device
 	struct nfp_eth_table_port *eth_port;
 	struct nfp_port *port;
 
-	param->active_fec = ETHTOOL_FEC_NONE_BIT;
-	param->fec = ETHTOOL_FEC_NONE_BIT;
+	param->active_fec = ETHTOOL_FEC_NONE;
+	param->fec = ETHTOOL_FEC_NONE;
 
 	port = nfp_port_from_netdev(netdev);
 	eth_port = nfp_port_get_eth_port(port);


