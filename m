Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245472E3DE3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437908AbgL1OV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502218AbgL1OVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BBCF206D4;
        Mon, 28 Dec 2020 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165242;
        bh=tz/dodCeW1DHdwoGekz2Ot5tcOa7R/FRsYGAIh+bSLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/ERgqEMHJwqKqZlbv5Quy+25QXjVf1AeSTZEWJ2STLNcxJyMpJP7cCNiJESmpXBu
         XQIPjn0kpfXYfI+SjflmYkIl8zUzcbzqmG+SUnVwIOw/p5UMzIOIUo9AwQ3VmOSs4l
         HbsHQCruuF1EGyNY6IQ4xJDfgMSyA28Bhx80f3vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/717] ice, xsk: clear the status bits for the next_to_use descriptor
Date:   Mon, 28 Dec 2020 13:47:40 +0100
Message-Id: <20201228125043.105740628@linuxfoundation.org>
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

[ Upstream commit 8d14768a7972b92c73259f0c9c45b969d85e3a60 ]

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

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054c..98101a8e2952d 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -446,8 +446,11 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		}
 	} while (--count);
 
-	if (rx_ring->next_to_use != ntu)
+	if (rx_ring->next_to_use != ntu) {
+		/* clear the status bits for the next_to_use descriptor */
+		rx_desc->wb.status_error0 = 0;
 		ice_release_rx_desc(rx_ring, ntu);
+	}
 
 	return ret;
 }
-- 
2.27.0



