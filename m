Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA2603CE3
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiJSIx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiJSIwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:52:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520A06612E;
        Wed, 19 Oct 2022 01:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF44E61841;
        Wed, 19 Oct 2022 08:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E4EC433D6;
        Wed, 19 Oct 2022 08:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169352;
        bh=bxtpQ4/L1xjeH5XzKzquZqmtyjODMESCyeL/P6ddsBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLmLx3Ef95mqG9SJIxpYQfXouo6+Bznom2M9G8h7h9mXVhGwbONB4O7c+MPGV2bGa
         IAJPU1pXFHhXGG0mJGMWK4OmTEgU7Em/xWYJoIW9ODBt8oy6r3kQ9OQbi5xhZQDzIJ
         IsQgPPnFwgKO/aYZ7UROS1j8zNqthqDdodZ6ZNg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 6.0 245/862] ice: set tx_tstamps when creating new Tx rings via ethtool
Date:   Wed, 19 Oct 2022 10:25:32 +0200
Message-Id: <20221019083300.840724575@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit b3b173745c8cab1e24d6821488b60abed3acb24d ]

When the user changes the number of queues via ethtool, the driver
allocates new rings. This allocation did not initialize tx_tstamps. This
results in the tx_tstamps field being zero (due to kcalloc allocation), and
would result in a NULL pointer dereference when attempting a transmit
timestamp on the new ring.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: fc5ae5b44eb2 ("Bluetooth: L2CAP: Fix build errors in some archs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a6fff8ebaf9d..bbf6a300078e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2826,6 +2826,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		tx_rings[i].count = new_tx_cnt;
 		tx_rings[i].desc = NULL;
 		tx_rings[i].tx_buf = NULL;
+		tx_rings[i].tx_tstamps = &pf->ptp.port.tx;
 		err = ice_setup_tx_ring(&tx_rings[i]);
 		if (err) {
 			while (i--)
-- 
2.35.1



