Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B16A6DEF2B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjDLIsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjDLIs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B816EB2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3B7E6313A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DE8C4339C;
        Wed, 12 Apr 2023 08:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289256;
        bh=73V4cx85YdzPEiFtSIurcrvZJKwWvzK8hSeikbGmDoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doSUK3wXxr5jkfkIVVr037+gMYhecglpzL17HECWecVJMl4ZlMm8csEOXcrbWwnz/
         XnVIeIbR2oRPZ5bgGnzv3QKhDnqDpfnOvEW3pa9rAVQk3nBk2DO5kA/rd75jPjptr1
         ulagkhNlS9FbUjUVHs56zfewhWaqbeCasTcDa71I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 022/173] net: stmmac: remove redundant fixup to support fixed-link mode
Date:   Wed, 12 Apr 2023 10:32:28 +0200
Message-Id: <20230412082838.984266080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

[ Upstream commit 6fc21a6ed5953b1dd3a41ce7be1ea57f5ef8c081 ]

Currently, intel_speed_mode_2500() will fix-up xpcs_an_inband
to 1 if the underlying controller has a max speed of 1000Mbps.
The value has been initialized and modified if it is
a fixed-linked setup earlier.

This patch removes the fix-up to allow for fixed-linked setup
support. In stmmac_phy_setup(), ovr_an_inband is set based on
the value of xpcs_an_inband. Which in turn will return an
error in phylink_parse_mode() where MLO_AN_FIXED and
ovr_an_inband are both set.

Fixes: c82386310d95 ("stmmac: intel: prepare to support 1000BASE-X phy interface setting")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 13aa919633b47..ab9f876b6df7e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -251,7 +251,6 @@ static void intel_speed_mode_2500(struct net_device *ndev, void *intel_data)
 		priv->plat->mdio_bus_data->xpcs_an_inband = false;
 	} else {
 		priv->plat->max_speed = 1000;
-		priv->plat->mdio_bus_data->xpcs_an_inband = true;
 	}
 }
 
-- 
2.39.2



