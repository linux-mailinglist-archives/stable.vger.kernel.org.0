Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E305551A71
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243593AbiFTNA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243792AbiFTM6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:58:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767731BE91;
        Mon, 20 Jun 2022 05:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89921B811A0;
        Mon, 20 Jun 2022 12:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C11C3411B;
        Mon, 20 Jun 2022 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729747;
        bh=yIYtRfu76ISBMbAAz5Ej0mo7PqRgJKMWfOg+qBi6yK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO3a5E+X8RajqRY3xtDyzubb2eydYJ/cvIyBV2p2N32Le0QDxlGu/VtmLcgU0viFm
         3glHzIxvwB0376czP4lJQ/U+e9GGGSEAxR1m05ftQCsie2nImMe1fE2XlE4MOCSOgo
         a4V09AcB3icoz5jQRxPNC5du15HoDIiIGBl408s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 061/141] iavf: Fix issue with MAC address of VF shown as zero
Date:   Mon, 20 Jun 2022 14:49:59 +0200
Message-Id: <20220620124731.343986611@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

[ Upstream commit 645603844270b69175899268be68b871295764fe ]

After reinitialization of iavf, ice driver gets VIRTCHNL_OP_ADD_ETH_ADDR
message with incorrectly set type of MAC address. Hardware address should
have is_primary flag set as true. This way ice driver knows what it has
to set as a MAC address.

Check if the address is primary in iavf_add_filter function and set flag
accordingly.

To test set all-zero MAC on a VF. This triggers iavf re-initialization
and VIRTCHNL_OP_ADD_ETH_ADDR message gets sent to PF.
For example:

ip link set dev ens785 vf 0 mac 00:00:00:00:00:00

This triggers re-initialization of iavf. New MAC should be assigned.
Now check if MAC is non-zero:

ip link show dev ens785

Fixes: a3e839d539e0 ("iavf: Add usage of new virtchnl format to set default MAC")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7dfcf78b57fb..f3ecb3bca33d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -984,7 +984,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
 		f->is_new_mac = true;
-		f->is_primary = false;
+		f->is_primary = ether_addr_equal(macaddr, adapter->hw.mac.addr);
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
 	} else {
 		f->remove = false;
-- 
2.35.1



