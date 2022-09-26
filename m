Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06625EA4E5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbiIZL4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238941AbiIZLyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8305357E21;
        Mon, 26 Sep 2022 03:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A3EB80782;
        Mon, 26 Sep 2022 10:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B707C433C1;
        Mon, 26 Sep 2022 10:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189329;
        bh=lvpX7YPeNPwuSs6jKx97XhMPdwGu8NHyaJz9o3M1oV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJD5MNFhFvqGe0+jB66e63TJMA6b1d+Sy5HcaZcUkPyI3lVqoteah4Zgupdxv8P+h
         Yy/g6VDByaiyU4Oh7dX27Irs6hmhUtG9V042YGQNHTGe4IEzr0XDi2rWDY7ppmkqWt
         7w9/ZvQ8s9P6ZH4ngkodwcNEl3W+gsnn6KGGXM38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 151/207] ice: Fix ice_xdp_xmit() when XDP TX queue number is not sufficient
Date:   Mon, 26 Sep 2022 12:12:20 +0200
Message-Id: <20220926100813.412342615@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 114f398d48c571bb628187a7b2dd42695156781f ]

The original patch added the static branch to handle the situation,
when assigning an XDP TX queue to every CPU is not possible,
so they have to be shared.

However, in the XDP transmit handler ice_xdp_xmit(), an error was
returned in such cases even before static condition was checked,
thus making queue sharing still impossible.

Fixes: 22bf877e528f ("ice: introduce XDP_TX fallback path")
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/r/20220919134346.25030-1-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 836dce840712..97453d1dfafe 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -610,7 +610,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
-	if (!ice_is_xdp_ena_vsi(vsi) || queue_index >= vsi->num_xdp_txq)
+	if (!ice_is_xdp_ena_vsi(vsi))
 		return -ENXIO;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
@@ -621,6 +621,9 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdp_ring = vsi->xdp_rings[queue_index];
 		spin_lock(&xdp_ring->tx_lock);
 	} else {
+		/* Generally, should not happen */
+		if (unlikely(queue_index >= vsi->num_xdp_txq))
+			return -ENXIO;
 		xdp_ring = vsi->xdp_rings[queue_index];
 	}
 
-- 
2.35.1



