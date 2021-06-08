Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07323A01C9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhFHS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236474AbhFHSyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:54:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CDA56157F;
        Tue,  8 Jun 2021 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177660;
        bh=Dm/mlbZyX2ExMxM+PpnXu4dT0jhOZNabyYsq3fzpN5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAlSB5dgt0HbkZxzA124YnMPRkyNIaWZHBv4+sFPBdRweNhjPZ43qGKDt5+aU984D
         /PpoDcbhPcFUDfhniuLC1vgSjvxKWUkmpHLsK3NNltLwyxflrAiuCNGZ9Gfq5tyX3D
         3HUcpqFTfLDoYjIhpAI7mQy0/wGElWAJ1Qg613Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/137] ice: simplify ice_run_xdp
Date:   Tue,  8 Jun 2021 20:26:34 +0200
Message-Id: <20210608175944.223304246@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 59c97d1b51b119eace6b1e61a6f820701f5a8299 ]

There's no need for 'result' variable, we can directly return the
internal status based on action returned by xdp prog.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1510091a63e8..5cc2854a5d48 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -537,22 +537,20 @@ static int
 ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog)
 {
-	int err, result = ICE_XDP_PASS;
 	struct ice_ring *xdp_ring;
+	int err;
 	u32 act;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		break;
+		return ICE_XDP_PASS;
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		result = ice_xmit_xdp_buff(xdp, xdp_ring);
-		break;
+		return ice_xmit_xdp_buff(xdp, xdp_ring);
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
-		break;
+		return !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -560,11 +558,8 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		result = ICE_XDP_CONSUMED;
-		break;
+		return ICE_XDP_CONSUMED;
 	}
-
-	return result;
 }
 
 /**
-- 
2.30.2



