Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F04FD3CE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbiDLHWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350872AbiDLHMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC164AE29;
        Mon, 11 Apr 2022 23:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F24DE61045;
        Tue, 12 Apr 2022 06:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D138C385A1;
        Tue, 12 Apr 2022 06:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746207;
        bh=zZFhWFitkae8Zm3UMN7Hy6Ny2tFQ0Om1OfTnnOfRHos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSkocZlAi1jitvUuyK8F5rTa2jqZZe3kAXdk4nZoL16S/QyPrOLWzn+9ZA4buVvM4
         p985G9J/8VXd+jKONJAy4pvtLYTVTU3vN6O1pmnl/c7EfMa8SAzB1OvEXF3yPDreUR
         BF0m9V5tVeFn+9HEwdlGUYXt1n6jYLlL2zp9r9BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/277] ice: Do not skip not enabled queues in ice_vc_dis_qs_msg
Date:   Tue, 12 Apr 2022 08:29:45 +0200
Message-Id: <20220412062947.302934363@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

[ Upstream commit 05ef6813b234db3196f083b91db3963f040b65bb ]

Disable check for queue being enabled in ice_vc_dis_qs_msg, because
there could be a case when queues were created, but were not enabled.
We still need to delete those queues.

Normal workflow for VF looks like:
Enable path:
VIRTCHNL_OP_ADD_ETH_ADDR (opcode 10)
VIRTCHNL_OP_CONFIG_VSI_QUEUES (opcode 6)
VIRTCHNL_OP_ENABLE_QUEUES (opcode 8)

Disable path:
VIRTCHNL_OP_DISABLE_QUEUES (opcode 9)
VIRTCHNL_OP_DEL_ETH_ADDR (opcode 11)

The issue appears only in stress conditions when VF is enabled and
disabled very fast.
Eventually there will be a case, when queues are created by
VIRTCHNL_OP_CONFIG_VSI_QUEUES, but are not enabled by
VIRTCHNL_OP_ENABLE_QUEUES.
In turn, these queues are not deleted by VIRTCHNL_OP_DISABLE_QUEUES,
because there is a check whether queues are enabled in
ice_vc_dis_qs_msg.

When we bring up the VF again, we will see the "Failed to set LAN Tx queue
context" error during VIRTCHNL_OP_CONFIG_VSI_QUEUES step. This
happens because old 16 queues were not deleted and VF requests to create
16 more, but ice_sched_get_free_qparent in ice_ena_vsi_txq would fail to
find a parent node for first newly requested queue (because all nodes
are allocated to 16 old queues).

Testing Hints:

Just enable and disable VF fast enough, so it would be disabled before
reaching VIRTCHNL_OP_ENABLE_QUEUES.

while true; do
        ip link set dev ens785f0v0 up
        sleep 0.065 # adjust delay value for you machine
        ip link set dev ens785f0v0 down
done

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 4338e4ff7e85..9d4d58757e04 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3335,9 +3335,9 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 				goto error_param;
 			}
 
-			/* Skip queue if not enabled */
 			if (!test_bit(vf_q_id, vf->txq_ena))
-				continue;
+				dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
+					vf_q_id, vsi->vsi_num);
 
 			ice_fill_txq_meta(vsi, ring, &txq_meta);
 
-- 
2.35.1



