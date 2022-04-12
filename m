Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0768A4FD481
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiDLHbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353625AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B1E2716C;
        Tue, 12 Apr 2022 00:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA9D2615B4;
        Tue, 12 Apr 2022 07:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4CAC385A1;
        Tue, 12 Apr 2022 07:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746940;
        bh=J8HwPpsqumg+1mHTdrOY+zzpUgTQ4iz9NwwZIOIHLhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR5LUET6OVTwLNkRRKrLCQo9EE2jl8D2DdNEeOO2QQdDm+/kJLiYH+E36gyIdAJEC
         Msrr9Otez8nmymkIplMw6oMi9aGUxtgVcVUPRb9MHhGcxGy4Q9mkgxnoKLu9d+MJyg
         a529Ar/5xqfBcvReeLFvZbL/vB66GM0DsIPHX8zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 185/285] ice: Set txq_teid to ICE_INVAL_TEID on ring creation
Date:   Tue, 12 Apr 2022 08:30:42 +0200
Message-Id: <20220412062949.003047728@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

[ Upstream commit ccfee1822042b87e5135d33cad8ea353e64612d2 ]

When VF is freshly created, but not brought up, ring->txq_teid
value is by default set to 0.
But 0 is a valid TEID. On some platforms the Root Node of
Tx scheduler has a TEID = 0. This can cause issues as shown below.

The proper way is to set ring->txq_teid to ICE_INVAL_TEID (0xFFFFFFFF).

Testing Hints:
echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
ip link set dev ens785f0v0 up
ip link set dev ens785f0v0 down

If we have freshly created VF and quickly turn it on and off, so there
would be no time to reach VIRTCHNL_OP_CONFIG_VSI_QUEUES stage, then
VIRTCHNL_OP_DISABLE_QUEUES stage will fail with error:
[  639.531454] disable queue 89 failed 14
[  639.532233] Failed to disable LAN Tx queues, error: ICE_ERR_AQ_ERROR
[  639.533107] ice 0000:02:00.0: Failed to stop Tx ring 0 on VSI 5

The reason for the fail is that we are trying to send AQ command to
delete queue 89, which has never been created and receive an "invalid
argument" error from firmware.

As this queue has never been created, it's teid and ring->txq_teid
have default value 0.
ice_dis_vsi_txq has a check against non-existent queues:

node = ice_sched_find_node_by_teid(pi->root, q_teids[i]);
if (!node)
	continue;

But on some platforms the Root Node of Tx scheduler has a teid = 0.
Hence, ice_sched_find_node_by_teid finds a node with teid = 0 (it is
pi->root), and we go further to submit an erroneous request to firmware.

Fixes: 37bb83901286 ("ice: Move common functions out of ice_main.c part 7/7")
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e39e299e79a4..a3514a5e067a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1409,6 +1409,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->tx_tstamps = &pf->ptp.port.tx;
 		ring->dev = dev;
 		ring->count = vsi->num_tx_desc;
+		ring->txq_teid = ICE_INVAL_TEID;
 		WRITE_ONCE(vsi->tx_rings[i], ring);
 	}
 
-- 
2.35.1



