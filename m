Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F074FD5F4
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345457AbiDLH6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358769AbiDLHmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB812ADB;
        Tue, 12 Apr 2022 00:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B7BBB81B62;
        Tue, 12 Apr 2022 07:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0592CC385A1;
        Tue, 12 Apr 2022 07:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747951;
        bh=xQWayGB+6f6hpATCzHMRRQ/8HztQFzBaPi4TXBjj1bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mV40kF5JrxJ39W8b0qg3mp0BK0/wQLUo02iXEuPFxlioswdT/jIZzo2Njk9dxx8vR
         MnI6XQW5JjSVhltKwzVX6TifCd1LrBftUB/y2FxsxqxNvxWkQhGkM1taCNvLjC2CEO
         yssuOQ8TX/8KXcdE0WzdXycAxiEdVCGlAo6nrOMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Shwetha Nagaraju <shwetha.nagaraju@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 238/343] ice: clear cmd_type_offset_bsz for TX rings
Date:   Tue, 12 Apr 2022 08:30:56 +0200
Message-Id: <20220412062958.203119397@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit e19778e6c911691856447c3bf9617f00b3e1347f ]

Currently when XDP rings are created, each descriptor gets its DD bit
set, which turns out to be the wrong approach as it can lead to a
situation where more descriptors get cleaned than it was supposed to,
e.g. when AF_XDP busy poll is run with a large batch size. In this
situation, the driver would request for more buffers than it is able to
handle.

Fix this by not setting the DD bits in ice_xdp_alloc_setup_rings(). They
should be initialized to zero instead.

Fixes: 9610bd988df9 ("ice: optimize XDP_TX workloads")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Shwetha Nagaraju <shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5229bce1a4ab..db2e02e673a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2546,7 +2546,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		spin_lock_init(&xdp_ring->tx_lock);
 		for (j = 0; j < xdp_ring->count; j++) {
 			tx_desc = ICE_TX_DESC(xdp_ring, j);
-			tx_desc->cmd_type_offset_bsz = cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE);
+			tx_desc->cmd_type_offset_bsz = 0;
 		}
 	}
 
-- 
2.35.1



