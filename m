Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B84F582E64
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiG0RMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbiG0RLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:11:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0580D5141D;
        Wed, 27 Jul 2022 09:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEAAAB821C5;
        Wed, 27 Jul 2022 16:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551A2C433C1;
        Wed, 27 Jul 2022 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940093;
        bh=xcRkLHyCPVW45pzjC+BD+ePo1H07buCXLbvYrUCnzl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmSMAQ2DQF3KXBOLaIAfUmngbOGgz3wY615vG7ByKzKjNxbdtQFYhfmJSwKQMwk9a
         5TSK0RGdjEDCvJolOEcdiTwSHXsKz/SQxKUN9kzkyg9tNPm6Z9ss2b5GDj94o8Um3+
         ELlgIzKJvQK/mC0Brtqyn2AcM7fnRFMpNolWHqgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/201] iavf: Fix handling of dummy receive descriptors
Date:   Wed, 27 Jul 2022 18:10:05 +0200
Message-Id: <20220727161031.924437707@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit a9f49e0060301a9bfebeca76739158d0cf91cdf6 ]

Fix memory leak caused by not handling dummy receive descriptor properly.
iavf_get_rx_buffer now sets the rx_buffer return value for dummy receive
descriptors. Without this patch, when the hardware writes a dummy
descriptor, iavf would not free the page allocated for the previous receive
buffer. This is an unlikely event but can still happen.

[Jesse: massaged commit message]

Fixes: efa14c398582 ("iavf: allow null RX descriptors")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 3525eab8e9f9..5448ed0e0357 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1250,11 +1250,10 @@ static struct iavf_rx_buffer *iavf_get_rx_buffer(struct iavf_ring *rx_ring,
 {
 	struct iavf_rx_buffer *rx_buffer;
 
-	if (!size)
-		return NULL;
-
 	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
 	prefetchw(rx_buffer->page);
+	if (!size)
+		return rx_buffer;
 
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev,
-- 
2.35.1



