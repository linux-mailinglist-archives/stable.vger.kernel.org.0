Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354EA48000C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhL0Pmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42534 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239001AbhL0PlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6757FCE10D7;
        Mon, 27 Dec 2021 15:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37998C36AEA;
        Mon, 27 Dec 2021 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619656;
        bh=OW61KWukwtypP4+5x7Y1dcPSI/TE5Ge9263wDQb1hss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPJshK46nPg3KwDfcjqMrWnzGH475LkGTDn/U8UeiMY5qLGfgfbalw6rAc0qSQwal
         zwU/EbQx5DOVjxRMAotMlx8ZM/yWxh1VC4HT1Mz7urBXl709QzkQr74YdyDqhYPh64
         KzRtdgGv41/rFsA4x+dfGf2YareI0vI1jZayqoOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/128] ice: xsk: return xsk buffers back to pool when cleaning the ring
Date:   Mon, 27 Dec 2021 16:29:59 +0100
Message-Id: <20211227151332.326048329@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit afe8a3ba85ec2a6b6849367e25c06a2f8e0ddd05 ]

Currently we only NULL the xdp_buff pointer in the internal SW ring but
we never give it back to the xsk buffer pool. This means that buffers
can be leaked out of the buff pool and never be used again.

Add missing xsk_buff_free() call to the routine that is supposed to
clean the entries that are left in the ring so that these buffers in the
umem can be used by other sockets.

Also, only go through the space that is actually left to be cleaned
instead of a whole ring.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index f4ab5259a56cc..37c7dc6b44a9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -810,14 +810,14 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
  */
 void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
 {
-	u16 i;
-
-	for (i = 0; i < rx_ring->count; i++) {
-		struct xdp_buff **xdp = &rx_ring->xdp_buf[i];
+	u16 count_mask = rx_ring->count - 1;
+	u16 ntc = rx_ring->next_to_clean;
+	u16 ntu = rx_ring->next_to_use;
 
-		if (!xdp)
-			continue;
+	for ( ; ntc != ntu; ntc = (ntc + 1) & count_mask) {
+		struct xdp_buff **xdp = &rx_ring->xdp_buf[ntc];
 
+		xsk_buff_free(*xdp);
 		*xdp = NULL;
 	}
 }
-- 
2.34.1



