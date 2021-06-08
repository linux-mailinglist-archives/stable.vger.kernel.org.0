Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0033A02F7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhFHTLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236406AbhFHTIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DAE16140D;
        Tue,  8 Jun 2021 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178064;
        bh=Xy7V8RpSkFJ/vI1m5rvzWUgGYbx7g9nPvDbYVd+oj9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8zoOBo2xZHUhlu4YD8JiV/bPHt9xGkqHizE2yrllJYYjj5o9iU8AB36qVW7A5sgj
         fMj9IrvlHU2XwNKUKLTyjvP2X/HZz6aLFK21x+potWNkmtg2XZw5q06/ODvslFNM7J
         OJdnbH6OknvF/G82j9fKnx7xzMTrM8ytm1/5vRkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 064/161] ixgbe: optimize for XDP_REDIRECT in xsk path
Date:   Tue,  8 Jun 2021 20:26:34 +0200
Message-Id: <20210608175947.631912099@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 7d52fe2eaddfa3d7255d43c3e89ebf2748b7ea7a ]

Optimize ixgbe_run_xdp_zc() for the XDP program verdict being
XDP_REDIRECT in the xsk zero-copy path. This path is only used when
having AF_XDP zero-copy on and in that case most packets will be
directed to user space. This provides a little under 100k extra
packets in throughput on my server when running l2fwd in xdpsock.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 3771857cf887..91ad5b902673 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -104,6 +104,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	if (likely(act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		rcu_read_unlock();
+		return result;
+	}
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -115,10 +122,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		}
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
 		break;
-	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
-- 
2.30.2



