Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552A7635708
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbiKWJfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbiKWJfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:35:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F441A05E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D10B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12104C433D6;
        Wed, 23 Nov 2022 09:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195967;
        bh=oWLJndOzwjiugowe/Wj30r1OPtapHzRVjjKoZsOvRYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNwwy9sZiRoWlqtlMmSAjBjLpJBJVqVqTIIcuxk/cU/fwFTgAxVr0Ogr7hhljd3ze
         CjXni8HpWajtRDzwhvmC0dgBWHCGm7FwBFHeJZ1xg53v2lFczD8g4oclPUhdO9+AKY
         S1SvU5k/FhJOBSGoYyLTNl76YmNTaP/q2RwURr68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/181] net: stmmac: ensure tx function is not running in stmmac_xdp_release()
Date:   Wed, 23 Nov 2022 09:50:45 +0100
Message-Id: <20221123084605.868835180@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index 6f579f498993..8590249d4468 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6494,6 +6494,9 @@ void stmmac_xdp_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	/* Ensure tx function is not running */
+	netif_tx_disable(dev);
+
 	/* Disable NAPI process */
 	stmmac_disable_all_queues(priv);
 
-- 
2.35.1



