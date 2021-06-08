Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E83A02FF
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhFHTLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237403AbhFHTJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E6C61422;
        Tue,  8 Jun 2021 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178097;
        bh=NjUIkDNRZJfZZBR5QpB1Xc3b5bVAfAPPcUHdQFoV2Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtpcdAlUYCiWOHz+B21OeTZnGvBIUV/E2jdM+JwOsjJSeEMh1dsM72lO/Q5GHg+yj
         FTOWZerwoFb+mirph1AndD/EXn7KQg0nrR7xrxY8yDiQ7E5wTd3zLI0+AFSDk1CX+X
         CjZ9fqvUp8LcPsHOAd/AhSFEkfAlsgiftOE2QvAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 048/161] ixgbevf: add correct exception tracing for XDP
Date:   Tue,  8 Jun 2021 20:26:18 +0200
Message-Id: <20210608175947.099713675@linuxfoundation.org>
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

[ Upstream commit faae81420d162551b6ef2d804aafc00f4cd68e0e ]

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 21092e9ce8b1 ("ixgbevf: Add support for XDP_TX action")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 449d7d5b280d..b38860c48598 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1067,11 +1067,14 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 	case XDP_TX:
 		xdp_ring = adapter->xdp_ring[rx_ring->queue_index];
 		result = ixgbevf_xmit_xdp_ring(xdp_ring, xdp);
+		if (result == IXGBEVF_XDP_CONSUMED)
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



