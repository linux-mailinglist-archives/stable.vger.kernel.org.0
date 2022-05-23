Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA3E531CF3
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbiEWRjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbiEWRhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816B26FA1E;
        Mon, 23 May 2022 10:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C20FBB8121A;
        Mon, 23 May 2022 17:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D35C385A9;
        Mon, 23 May 2022 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326998;
        bh=23su02o+7aksN6p3FS7YDRxWi6rUQ/aMOIQEY1F9QY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWfqN58+W68llD0fiBLtWJJC7roo7rSrRtTKorXJ35zL3XzVNdZWK5ZhbAca0qD6W
         oDTB0KZqnl6P2p+gIMsC7shCLg21CSXTodZcpZXikx8c5bTGl/BREk0NGRdc3znoOn
         dwhn+b9D3WKS2GkdsCbOuHXLwlG/W2PFT+doEa1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Greenwalt <paul.greenwalt@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.17 097/158] ice: fix possible under reporting of ethtool Tx and Rx statistics
Date:   Mon, 23 May 2022 19:04:14 +0200
Message-Id: <20220523165847.535271104@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 31b6298fd8e29effe9ed6b77351ac5969be56ce0 ]

The hardware statistics counters are not cleared during resets so the
drivers first access is to initialize the baseline and then subsequent
reads are for reporting the counters. The statistics counters are read
during the watchdog subtask when the interface is up. If the baseline
is not initialized before the interface is up, then there can be a brief
window in which some traffic can be transmitted/received before the
initial baseline reading takes place.

Directly initialize ethtool statistics in driver open so the baseline will
be initialized when the interface is up, and any dropped packets
incremented before the interface is up won't be reported.

Fixes: 28dc1b86f8ea9 ("ice: ignore dropped packets during init")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7f6715eb862f..30f055e1a92a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5907,9 +5907,10 @@ static int ice_up_complete(struct ice_vsi *vsi)
 			ice_ptp_link_change(pf, pf->hw.pf_id, true);
 	}
 
-	/* clear this now, and the first stats read will be used as baseline */
-	vsi->stat_offsets_loaded = false;
-
+	/* Perform an initial read of the statistics registers now to
+	 * set the baseline so counters are ready when interface is up
+	 */
+	ice_update_eth_stats(vsi);
 	ice_service_task_schedule(pf);
 
 	return 0;
-- 
2.35.1



