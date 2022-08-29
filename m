Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE965A487A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiH2LKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiH2LKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7936BD69;
        Mon, 29 Aug 2022 04:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62FEDB80F2B;
        Mon, 29 Aug 2022 11:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC08C433C1;
        Mon, 29 Aug 2022 11:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771113;
        bh=+4r3UTh/FQZrfa0D6k8HNCbCbuz+D5Brv71ASRXX8q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGnBSUqf+iWByJ7dehRyqkWLimVdSCTMuglcEet7W/GLv6+oW6W2JSRsziOwMwTVz
         CDBONJjpSXjl7ZmpaQ788L5c62CIu0sMWAF9tP/B5r15Uqin0a9KqoUBkpKThbI3sP
         7b+WCC5oJGFCsqsi5s5gm4JuGBZefSUS/JGxb1Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/86] ice: xsk: Force rings to be sized to power of 2
Date:   Mon, 29 Aug 2022 12:58:49 +0200
Message-Id: <20220829105757.479967257@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 296f13ff3854535009a185aaf8e3603266d39d94 ]

With the upcoming introduction of batching to XSK data path,
performance wise it will be the best to have the ring descriptor count
to be aligned to power of 2.

Check if ring sizes that user is going to attach the XSK socket fulfill
the condition above. For Tx side, although check is being done against
the Tx queue and in the end the socket will be attached to the XDP
queue, it is fine since XDP queues get the ring->count setting from Tx
queues.

Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220125160446.78976-3-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 5733526fa245c..4bb62950d92de 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -371,6 +371,13 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	bool if_running, pool_present = !!pool;
 	int ret = 0, pool_failure = 0;
 
+	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
+	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
+		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
+		pool_failure = -EINVAL;
+		goto failure;
+	}
+
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
@@ -393,6 +400,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
+failure:
 	if (pool_failure) {
 		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
 			   pool_present ? "en" : "dis", pool_failure);
-- 
2.35.1



