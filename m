Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB97E1D857D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgERRyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbgERRyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:54:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA110207F5;
        Mon, 18 May 2020 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824480;
        bh=I7ZALXXVOmBFTfZITXUzTD3CtqIk1G4NRb3LHdSXTvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pU87a98upJvZ8w6tik5pdbjtk1kwbinmKqO+RCoO5xw4lTzPw2m9X9/COzine+7R5
         FkZweyomjaQOo5dJZoeVjT9Ko5aaZPE2HY7cHGuNSIbJmEyrcH/rvKF+bsKcLcZ9dM
         wV47TEvvrO1NcUMFp0n81POfdTelj1wICH8iIynY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 028/147] dpaa2-eth: prevent array underflow in update_cls_rule()
Date:   Mon, 18 May 2020 19:35:51 +0200
Message-Id: <20200518173517.346460685@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6d32a5119811d2e9b5caa284181944c6f1f192ed ]

The "location" is controlled by the user via the ethtool_set_rxnfc()
function.  This update_cls_rule() function checks for array overflows
but it doesn't check if the value is negative.  I have changed the type
to unsigned to prevent array underflows.

Fixes: afb90dbb5f78 ("dpaa2-eth: Add ethtool support for flow classification")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -590,7 +590,7 @@ static int num_rules(struct dpaa2_eth_pr
 
 static int update_cls_rule(struct net_device *net_dev,
 			   struct ethtool_rx_flow_spec *new_fs,
-			   int location)
+			   unsigned int location)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpaa2_eth_cls_rule *rule;


