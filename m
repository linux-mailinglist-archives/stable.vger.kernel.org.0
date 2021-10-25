Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE70E43A12E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhJYThb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236477AbhJYTeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D42A61183;
        Mon, 25 Oct 2021 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190259;
        bh=QLdomiPab7bNj93EK8crygkuf2I+GQfy0rAJsWNTMr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kk+hI3zmt7s0wPD+hvax6NUHa9YI9Je2z6wDKCMymYERSZh5+3CS1colEl66QL0k
         VNFzjOmP16s5mKdZTpDft+rrn4yeAqZTX89nT2NpfKUS+oZ4qB20gNMG9fix+A4ruc
         QjZSv9hupN71vtFxQ+SzpVywjrDuGZvV0qQufD1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/95] ice: fix getting UDP tunnel entry
Date:   Mon, 25 Oct 2021 21:14:12 +0200
Message-Id: <20211025190959.108069229@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit e4c2efa1393c6f1fbfabf91d1d83fcb4ae691ccb ]

Correct parameters order in call to ice_tunnel_idx_to_entry function.

Entry in sparse port table is correct when the idx is 0. For idx 1 one
correct entry should be skipped, for idx 2 two of them should be skipped
etc. Change if condition to be true when idx is 0, which means that
previous valid entry of this tunnel type were skipped.

Fixes: b20e6c17c468 ("ice: convert to new udp_tunnel infrastructure")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 9095b4d274ad..a81be917f653 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1669,7 +1669,7 @@ static u16 ice_tunnel_idx_to_entry(struct ice_hw *hw, enum ice_tunnel_type type,
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
 		if (hw->tnl.tbl[i].valid &&
 		    hw->tnl.tbl[i].type == type &&
-		    idx--)
+		    idx-- == 0)
 			return i;
 
 	WARN_ON_ONCE(1);
@@ -1829,7 +1829,7 @@ int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
 	u16 index;
 
 	tnl_type = ti->type == UDP_TUNNEL_TYPE_VXLAN ? TNL_VXLAN : TNL_GENEVE;
-	index = ice_tunnel_idx_to_entry(&pf->hw, idx, tnl_type);
+	index = ice_tunnel_idx_to_entry(&pf->hw, tnl_type, idx);
 
 	status = ice_create_tunnel(&pf->hw, index, tnl_type, ntohs(ti->port));
 	if (status) {
-- 
2.33.0



