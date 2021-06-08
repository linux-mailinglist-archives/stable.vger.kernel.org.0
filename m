Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57E93A01BB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhFHS4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236159AbhFHSyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:54:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D8D1614A5;
        Tue,  8 Jun 2021 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177655;
        bh=tfwXh65TX/NuuAbXQZ9fROnR2Ukr34mptSNUus2UxLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7L5yhSOQhuTKcf1j5K8xDHGGAJHLDe8uyH/O8H++umYxggyQZiEYjXSdPjxmub/k
         eWsK6ZwqbF1GNHn/8Z1QWbGc/Z5qCu7OAHne2BDFNTcDibDHh6CUsgLOtoUDM4ejo8
         SgK9gHBbzNrZsjE2gxQURPya8xh3renriDFrPvxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/137] i40e: optimize for XDP_REDIRECT in xsk path
Date:   Tue,  8 Jun 2021 20:26:32 +0200
Message-Id: <20210608175944.160682381@linuxfoundation.org>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 346497c78d15cdd5bdc3b642a895009359e5457f ]

Optimize i40e_run_xdp_zc() for the XDP program verdict being
XDP_REDIRECT in the xsk zero-copy path. This path is only used when
having AF_XDP zero-copy on and in that case most packets will be
directed to user space. This provides a little over 100k extra packets
in throughput on my server when running l2fwd in xdpsock.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 8557807b4171..18e8d4e456d6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -159,6 +159,13 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	if (likely(act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		rcu_read_unlock();
+		return result;
+	}
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -166,10 +173,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
 		break;
-	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
-- 
2.30.2



