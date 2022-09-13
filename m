Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B8A5B70D4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiIMOZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiIMOYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D900067147;
        Tue, 13 Sep 2022 07:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53C42614A8;
        Tue, 13 Sep 2022 14:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE3DC433C1;
        Tue, 13 Sep 2022 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078569;
        bh=xrCHL+BLvlHDlXvusu0C3Y2fmAN2cpBtZ40KfBa73aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1S5t5ayw5LfXLIGTgOvErR+fkGz98CkkBpQn0yjPmQvWIG7i3Y7nIo3vP22CGdKrs
         bJbyTlDKrKJ7lhUb4qZ0inA/hariCKcPRP/KKUsc0e7aZGCNz999smHXWvjSAEvohs
         SFyjhsHMVoLZ9uYJTbbnn+6Jlh0kNhkoIbdhhhq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 165/192] i40e: Fix ADQ rate limiting for PF
Date:   Tue, 13 Sep 2022 16:04:31 +0200
Message-Id: <20220913140418.251010088@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit 45bb006d3c924b1201ed43c87a96b437662dcaa8 ]

Fix HW rate limiting for ADQ.
Fallback to kernel queue selection for ADQ, as it is network stack
that decides which queue to use for transmit with ADQ configured.
Reset PF after creation of VMDq2 VSIs required for ADQ, as to
reprogram TX queue contexts in i40e_configure_tx_ring.
Without this patch PF would limit TX rate only according to TC0.

Fixes: a9ce82f744dc ("i40e: Enable 'channel' mode in mqprio for TC configs")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 45c56832c14fd..1aaf0c5ddf6cf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6536,6 +6536,9 @@ static int i40e_configure_queue_channels(struct i40e_vsi *vsi)
 			vsi->tc_seid_map[i] = ch->seid;
 		}
 	}
+
+	/* reset to reconfigure TX queue contexts */
+	i40e_do_reset(vsi->back, I40E_PF_RESET_FLAG, true);
 	return ret;
 
 err_free:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index af69ccc6e8d2f..07f1e209d524d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3689,7 +3689,8 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 	u8 prio;
 
 	/* is DCB enabled at all? */
-	if (vsi->tc_config.numtc == 1)
+	if (vsi->tc_config.numtc == 1 ||
+	    i40e_is_tc_mqprio_enabled(vsi->back))
 		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
-- 
2.35.1



