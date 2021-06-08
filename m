Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A926E3A02F8
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhFHTLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236445AbhFHTIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF44661407;
        Tue,  8 Jun 2021 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178069;
        bh=N23LkC4nZUBlK0xsWV8nXy3WsM0LHWaJsw/Vxa3SY00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhY0FJRmUc+VQepbnWQ4vbkTIz6eXFki+6Ln2wGQmPo3VNgNDCo9ScP1yvE29Wluo
         3+YZ1x9zGEcRc7tIWWYEMv7/MAsJKV9Ddb0z9ZP2E37wUhk83HVKuZ3zZChUe9Fpew
         mzcyXlGvPO0tXn//qKdKhr1hlSDuOvBu4bUoO+po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 065/161] ixgbe: add correct exception tracing for XDP
Date:   Tue,  8 Jun 2021 20:26:35 +0200
Message-Id: <20210608175947.664104533@linuxfoundation.org>
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

[ Upstream commit 8281356b1cab1cccc71412eb4cf28b99d6bb2c19 ]

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 ++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 14 ++++++++------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cffb95f8f632..c194158a421c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2213,23 +2213,23 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
+		if (unlikely(!xdpf))
+			goto out_failure;
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		if (result == IXGBE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (!err)
-			result = IXGBE_XDP_REDIR;
-		else
-			result = IXGBE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IXGBE_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 91ad5b902673..f72d2978263b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -106,9 +106,10 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
 		rcu_read_unlock();
-		return result;
+		return IXGBE_XDP_REDIR;
 	}
 
 	switch (act) {
@@ -116,16 +117,17 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
+		if (unlikely(!xdpf))
+			goto out_failure;
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		if (result == IXGBE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.30.2



