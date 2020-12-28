Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89F42E3FF4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439197AbgL1OW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437893AbgL1OVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6281E22B2E;
        Mon, 28 Dec 2020 14:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165245;
        bh=5zn/4xyB1eu5gYq4y6UvWcr7Apf3HUkruUXsWMQBIZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSRUstEipRUM6ql2dMRS4XkScUJEjardLrBqG6j31oPXRSJrSMWS7gKccVrOHS83/
         NZFy+mVLO+UTg7BJu5qyTcuWORpsLTPhosfc1V/QAziMRP8/+dAMiyWNyXHr09gyZs
         +aVBdUXLKAsL4y1PJD9rSWE1ldpTMz4MJKkUobek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 463/717] i40e, xsk: clear the status bits for the next_to_use descriptor
Date:   Mon, 28 Dec 2020 13:47:41 +0100
Message-Id: <20201228125043.154251286@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 64050b5b8706d304ba647591b06e1eddc55e8bd9 ]

On the Rx side, the next_to_use index points to the next item in the
HW ring to be refilled/allocated, and next_to_clean points to the next
item to potentially be processed.

When the HW Rx ring is fully refilled, i.e. no packets has been
processed, the next_to_use will be next_to_clean - 1. When the ring is
fully processed next_to_clean will be equal to next_to_use. The latter
case is where a bug is triggered.

If the next_to_use bits are not cleared, and the "fully processed"
state is entered, a stale descriptor can be processed.

The skb-path correctly clear the status bit for the next_to_use
descriptor, but the AF_XDP zero-copy path did not do that.

This change adds the status bits clearing of the next_to_use
descriptor.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 567fd67e900ef..e402c62eb3137 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -219,8 +219,11 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	} while (count);
 
 no_buffers:
-	if (rx_ring->next_to_use != ntu)
+	if (rx_ring->next_to_use != ntu) {
+		/* clear the status bits for the next_to_use descriptor */
+		rx_desc->wb.qword1.status_error_len = 0;
 		i40e_release_rx_desc(rx_ring, ntu);
+	}
 
 	return ok;
 }
-- 
2.27.0



