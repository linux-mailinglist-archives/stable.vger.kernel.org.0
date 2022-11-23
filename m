Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3AF635828
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbiKWJwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiKWJvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:51:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2316E541
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:48:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B04A361A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7251C433D6;
        Wed, 23 Nov 2022 09:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196889;
        bh=NcK/HYF5zVKL1UPy0hhsoZHe6zqmpWnoR9dwSxxFXsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfna0n4fS6mx/J5f5xNmtnY5PuzruCmVd48SGGKNIIWUUwlafx1eLJX2VSK7mWK/U
         H3tIyNIZ/x1o9yP6zrGPHBbc8dZdBnJa0ePj6+OfhxIlk1kQUMBubGxstKnTn7aM7w
         oOXiqUIOJ4/JvYb9yeCdsQ0EgV85/BYuSggs3z9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 152/314] net: stmmac: ensure tx function is not running in stmmac_xdp_release()
Date:   Wed, 23 Nov 2022 09:49:57 +0100
Message-Id: <20221123084632.457436351@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>

[ Upstream commit 77711683a50477de39757d67ab1a3638220d6860 ]

When stmmac_xdp_release() is called, there is a possibility that tx
function is still running on other queues which will lead to tx queue
timed out and reset adapter.

This commit ensure that tx function is not running xdp before release
flow continue to run.

Fixes: ac746c8520d9 ("net: stmmac: enhance XDP ZC driver level switching performance")
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Link: https://lore.kernel.org/r/20221110064552.22504-1-noor.azura.ahmad.tarmizi@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bc060ef558d3..02827829463f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6564,6 +6564,9 @@ void stmmac_xdp_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	/* Ensure tx function is not running */
+	netif_tx_disable(dev);
+
 	/* Disable NAPI process */
 	stmmac_disable_all_queues(priv);
 
-- 
2.35.1



