Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A01D34D774
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfFTSPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729561AbfFTSPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:15:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C062B205F4;
        Thu, 20 Jun 2019 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054516;
        bh=Bpe2oIicDkwZj51P8Zy0jF3Xpm0cXdZFcHkYKZ2DzI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZjYP0oECHj6IYt1Fu1LxmZ6RJbVZbMrvHOfagkuCH8N3yATCPN9pdb2NUXdMZdf3
         Q+GkJhjIfxoEwUV9i44uHso8Ij3cY6TNuUtMs4ub0my3FLO2P1nOZjySA1GVIQy/mO
         QbrrjTc7SIdFAXhTO1UVx3UbzmITsowmfiaCgs7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 56/98] dpaa2-eth: Fix potential spectre issue
Date:   Thu, 20 Jun 2019 19:57:23 +0200
Message-Id: <20190620174351.874553506@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5a20a093d965560f632b2ec325f8876918f78165 ]

Smatch reports a potential spectre vulnerability in the dpaa2-eth
driver, where the value of rxnfc->fs.location (which is provided
from user-space) is used as index in an array.

Add a call to array_index_nospec() to sanitize the access.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 591dfcf76adb..0610fc0bebc2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/net_tstamp.h>
+#include <linux/nospec.h>
 
 #include "dpni.h"	/* DPNI_LINK_OPT_* */
 #include "dpaa2-eth.h"
@@ -589,6 +590,8 @@ static int dpaa2_eth_get_rxnfc(struct net_device *net_dev,
 	case ETHTOOL_GRXCLSRULE:
 		if (rxnfc->fs.location >= max_rules)
 			return -EINVAL;
+		rxnfc->fs.location = array_index_nospec(rxnfc->fs.location,
+							max_rules);
 		if (!priv->cls_rules[rxnfc->fs.location].in_use)
 			return -EINVAL;
 		rxnfc->fs = priv->cls_rules[rxnfc->fs.location].fs;
-- 
2.20.1



