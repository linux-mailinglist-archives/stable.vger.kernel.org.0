Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7143D6148
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhGZPab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237454AbhGZP3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 587F66101B;
        Mon, 26 Jul 2021 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315668;
        bh=p2Glw1OG0FY5YwbRfq/ayuEiaN6cgWITvEJRucwCJhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1uDt31xaXhlfY6C6uwpf/7WSE/p/tdo43EqeMLBRzIj5+x8whfmp+8ReXw4NiMA5
         kvHxvMnIJzYtJZ/QjUDoCL/OBFKo7e/MCc93SWZ+jIntyL5AXcz76QoaWmSD3Z3XJh
         VQDu7vwpKRPl9sEksfFHQJi1ybZmvMrPBvvYui7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 002/223] igb: Fix use-after-free error during reset
Date:   Mon, 26 Jul 2021 17:36:34 +0200
Message-Id: <20210726153846.326596416@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 7b292608db23ccbbfbfa50cdb155d01725d7a52e ]

Cleans the next descriptor to watch (next_to_watch) when cleaning the
TX ring.

Failure to do so can cause invalid memory accesses. If igb_poll() runs
while the controller is reset this can lead to the driver try to free
a skb that was already freed.

(The crash is harder to reproduce with the igb driver, but the same
potential problem exists as the code is identical to igc)

Fixes: 7cc6fd4c60f2 ("igb: Don't bother clearing Tx buffer_info in igb_clean_tx_ring")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reported-by: Erez Geva <erez.geva.ext@siemens.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 7b1885f9ce03..ed7ec27df8c2 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4835,6 +4835,8 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 					       DMA_TO_DEVICE);
 		}
 
+		tx_buffer->next_to_watch = NULL;
+
 		/* move us one more past the eop_desc for start of next pkt */
 		tx_buffer++;
 		i++;
-- 
2.30.2



