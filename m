Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8FF6D46FB
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbjDCOQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbjDCOQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:16:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8185F4ECB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBE6F61CCA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14A4C4339C;
        Mon,  3 Apr 2023 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531358;
        bh=92GICywkouLg2emm+HvUVT8CLvMrHOUz7WCID7Z+PRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8Frwzvyrv4W11F16UcK6UXq9vJS+MihDwbtVCy4HuTerzknEw4GNoBzhXWFkMJSD
         jqyhQvzpVCYCqkKMt76Uw32ivcEA0UtT8mnT4r43cwglUUzTmKOhskpeSypyMPVhuk
         j/8PgzFLOk8NZ0FUjhVEystML/ULpx+YD1ZIEzeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/84] iavf: fix inverted Rx hash condition leading to disabled hash
Date:   Mon,  3 Apr 2023 16:08:06 +0200
Message-Id: <20230403140353.597405439@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 32d57f667f871bc5a8babbe27ea4c5e668ee0ea8 ]

Condition, which checks whether the netdev has hashing enabled is
inverted. Basically, the tagged commit effectively disabled passing flow
hash from descriptor to skb, unless user *disables* it via Ethtool.
Commit a876c3ba59a6 ("i40e/i40evf: properly report Rx packet hash")
fixed this problem, but only for i40e.
Invert the condition now in iavf and unblock passing hash to skbs again.

Fixes: 857942fd1aa1 ("i40e: Fix Rx hash reported to the stack by our driver")
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/i40e_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/i40e_txrx.c b/drivers/net/ethernet/intel/iavf/i40e_txrx.c
index 1bf9734ae9cf0..d4bd06adc1453 100644
--- a/drivers/net/ethernet/intel/iavf/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/i40e_txrx.c
@@ -1062,7 +1062,7 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
 		cpu_to_le64((u64)I40E_RX_DESC_FLTSTAT_RSS_HASH <<
 			    I40E_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
-- 
2.39.2



