Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511721D8336
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgERSC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbgERSCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32E2B207D3;
        Mon, 18 May 2020 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824973;
        bh=eFQQvsJSP8uxgMOZ03eQ+NJeSwU57IPsCyxr1Z5fU5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwvlO635+yFOlZv0xsG30MZPhKG+xeeP4ipWeC2fuow/EEqJYCr3TdNC8nWo6ndj/
         42H2FTPFnXhfRG5O65aYcKE7RQy81CH9tkB46Xxw/PGMTkjewQZjKafoY7hFKHH8MF
         D3X5bEIPIdnQQe9plKnM5Xl2QWDLeIg3RBqvoKTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.6 041/194] dpaa2-eth: prevent array underflow in update_cls_rule()
Date:   Mon, 18 May 2020 19:35:31 +0200
Message-Id: <20200518173535.175349187@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
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
@@ -625,7 +625,7 @@ static int num_rules(struct dpaa2_eth_pr
 
 static int update_cls_rule(struct net_device *net_dev,
 			   struct ethtool_rx_flow_spec *new_fs,
-			   int location)
+			   unsigned int location)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpaa2_eth_cls_rule *rule;


