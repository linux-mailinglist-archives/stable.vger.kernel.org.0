Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BD7529186
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346935AbiEPUFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348890AbiEPT7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8423D396;
        Mon, 16 May 2022 12:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E3E8B80EB1;
        Mon, 16 May 2022 19:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C9C385AA;
        Mon, 16 May 2022 19:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730719;
        bh=n/zyVESSluDMEBpLn3+mn6KO/3lgO+C5pJ5rg7/Nzto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5JRSF8pQcjpC6jdr2lfKd+yLWfKXEutQjyGI1iYI4tiS+Nn0VqqIeMIApV+sfUNw
         3ZKkXa7wtZOcbjZPJuFL5W9vk3IvHKe3K52gyaw8y0XOot2GUFW7eFATfMstPQrz2u
         +18c1NTqVWOfP+9DuRZTKIRjOO9xHAWahdgo9wxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 086/102] i40e: i40e_main: fix a missing check on list iterator
Date:   Mon, 16 May 2022 21:37:00 +0200
Message-Id: <20220516193626.464751876@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 3f95a7472d14abef284d8968734fe2ae7ff4845f upstream.

The bug is here:
	ret = i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr, &aq_err);

The list iterator 'ch' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will
lead to a invalid memory access.

To fix this bug, use a new variable 'iter' as the list iterator,
while use the origin variable 'ch' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 1d8d80b4e4ff6 ("i40e: Add macvlan support on i40e")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20220510204846.2166999-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7535,42 +7535,43 @@ static void i40e_free_macvlan_channels(s
 static int i40e_fwd_ring_up(struct i40e_vsi *vsi, struct net_device *vdev,
 			    struct i40e_fwd_adapter *fwd)
 {
+	struct i40e_channel *ch = NULL, *ch_tmp, *iter;
 	int ret = 0, num_tc = 1,  i, aq_err;
-	struct i40e_channel *ch, *ch_tmp;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_hw *hw = &pf->hw;
 
-	if (list_empty(&vsi->macvlan_list))
-		return -EINVAL;
-
 	/* Go through the list and find an available channel */
-	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
-		if (!i40e_is_channel_macvlan(ch)) {
-			ch->fwd = fwd;
+	list_for_each_entry_safe(iter, ch_tmp, &vsi->macvlan_list, list) {
+		if (!i40e_is_channel_macvlan(iter)) {
+			iter->fwd = fwd;
 			/* record configuration for macvlan interface in vdev */
 			for (i = 0; i < num_tc; i++)
 				netdev_bind_sb_channel_queue(vsi->netdev, vdev,
 							     i,
-							     ch->num_queue_pairs,
-							     ch->base_queue);
-			for (i = 0; i < ch->num_queue_pairs; i++) {
+							     iter->num_queue_pairs,
+							     iter->base_queue);
+			for (i = 0; i < iter->num_queue_pairs; i++) {
 				struct i40e_ring *tx_ring, *rx_ring;
 				u16 pf_q;
 
-				pf_q = ch->base_queue + i;
+				pf_q = iter->base_queue + i;
 
 				/* Get to TX ring ptr */
 				tx_ring = vsi->tx_rings[pf_q];
-				tx_ring->ch = ch;
+				tx_ring->ch = iter;
 
 				/* Get the RX ring ptr */
 				rx_ring = vsi->rx_rings[pf_q];
-				rx_ring->ch = ch;
+				rx_ring->ch = iter;
 			}
+			ch = iter;
 			break;
 		}
 	}
 
+	if (!ch)
+		return -EINVAL;
+
 	/* Guarantee all rings are updated before we update the
 	 * MAC address filter.
 	 */


