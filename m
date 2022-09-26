Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E425EA137
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiIZKql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiIZKos (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:44:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE65E558F1;
        Mon, 26 Sep 2022 03:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1799B8055F;
        Mon, 26 Sep 2022 10:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24855C433C1;
        Mon, 26 Sep 2022 10:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187940;
        bh=/SjqnhXjwiyA/BeXgMhvlzWUvKoCyx+wh/zKjpb4Whw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ7+txg2yWYcz1uesyjsuoUXFYJicDMm/29IDncG/Mc+My0E6pRtjjkGIDmwU2vf2
         p2FPpZrrMCKzhklPbhmEGD/BuWHRuVMz+uEf3N6eRpdFEdY+GioEdqK6FZMIzsIuHK
         +FFIGO2xafq1uTtowRUcpxSQQEkkUMHyZOEE0Vgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Jaron <michalx.jaron@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/120] iavf: Fix set max MTU size with port VLAN and jumbo frames
Date:   Mon, 26 Sep 2022 12:11:51 +0200
Message-Id: <20220926100753.873784598@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

[ Upstream commit 399c98c4dc50b7eb7e9f24da7ffdda6f025676ef ]

After setting port VLAN and MTU to 9000 on VF with ice driver there
was an iavf error
"PF returned error -5 (IAVF_ERR_PARAM) to our request 6".

During queue configuration, VF's max packet size was set to
IAVF_MAX_RXBUFFER but on ice max frame size was smaller by VLAN_HLEN
due to making some space for port VLAN as VF is not aware whether it's
in a port VLAN. This mismatch in sizes caused ice to reject queue
configuration with ERR_PARAM error. Proper max_mtu is sent from ice PF
to VF with GET_VF_RESOURCES msg but VF does not look at this.

In iavf change max_frame from IAVF_MAX_RXBUFFER to max_mtu
received from pf with GET_VF_RESOURCES msg to make vf's
max_frame_size dependent from pf. Add check if received max_mtu is
not in eligible range then set it to IAVF_MAX_RXBUFFER.

Fixes: dab86afdbbd1 ("i40e/i40evf: Change the way we limit the maximum frame size for Rx")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 4d471a6f2946..7a17694b6a0b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -241,11 +241,14 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 void iavf_configure_queues(struct iavf_adapter *adapter)
 {
 	struct virtchnl_vsi_queue_config_info *vqci;
-	struct virtchnl_queue_pair_info *vqpi;
+	int i, max_frame = adapter->vf_res->max_mtu;
 	int pairs = adapter->num_active_queues;
-	int i, max_frame = IAVF_MAX_RXBUFFER;
+	struct virtchnl_queue_pair_info *vqpi;
 	size_t len;
 
+	if (max_frame > IAVF_MAX_RXBUFFER || !max_frame)
+		max_frame = IAVF_MAX_RXBUFFER;
+
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
 		dev_err(&adapter->pdev->dev, "Cannot configure queues, command %d pending\n",
-- 
2.35.1



