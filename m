Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1F83D5E49
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhGZPGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235849AbhGZPGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F32EC60F9B;
        Mon, 26 Jul 2021 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314403;
        bh=6/T5rSekCA5PMCs8QOl93sbic9Xh+adSe4+h/w3o6k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/s+gTcVqaNprhRTGhIf3h2iqNQ9fMVG/09eVaPuylvt8+CDfq5GTmJe6xMX2EpVz
         pxUTHGZX5bVmr6HshGMbhRuKURebsNUO+70UooaPNkHmdLbeLDmBjL0XhKUicqhlxt
         a94Mm6A/TtD/7kjcwJspAEOLnWNY6KF08zk+e7yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/82] igb: Fix use-after-free error during reset
Date:   Mon, 26 Jul 2021 17:38:35 +0200
Message-Id: <20210726153829.304219345@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 50fa0401c701..36c656736811 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3962,6 +3962,8 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 					       DMA_TO_DEVICE);
 		}
 
+		tx_buffer->next_to_watch = NULL;
+
 		/* move us one more past the eop_desc for start of next pkt */
 		tx_buffer++;
 		i++;
-- 
2.30.2



