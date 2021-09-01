Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6408B3FDC1E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbhIAMqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345674AbhIAMoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A45261156;
        Wed,  1 Sep 2021 12:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499946;
        bh=OAm03vm4hTKjAxOEVjAFVjlLbXz5uEbS8KvH8NpLo+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Krt/kUd75XM57nAmU9tZ4uW95fY3vaDbAguZUyBVGtm77w1EjMYcrt0RBK3MK93xk
         19fth9m7qJKAO30yzgz6mcUAhvidWLFfzCUh/vJ2lNZkk8fCpUHgEofsiM9N+8URB0
         kxLQqaW5xNvCDXw2d8VvvOngHsemzNBGiiBnUAHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Toshiki Nishioka <toshiki.nishioka@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 044/113] igc: Use num_tx_queues when iterating over tx_ring queue
Date:   Wed,  1 Sep 2021 14:27:59 +0200
Message-Id: <20210901122303.454088228@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toshiki Nishioka <toshiki.nishioka@intel.com>

[ Upstream commit 691bd4d7761992914a0e83c27a4ce57d01474cda ]

Use num_tx_queues rather than the IGC_MAX_TX_QUEUES fixed number 4 when
iterating over tx_ring queue since instantiated queue count could be
less than 4 where on-line cpu count is less than 4.

Fixes: ec50a9d437f0 ("igc: Add support for taprio offloading")
Signed-off-by: Toshiki Nishioka <toshiki.nishioka@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3db86daf3568..9b85fdf01297 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5080,7 +5080,7 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < IGC_MAX_TX_QUEUES; i++) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
 			if (e->gate_mask & BIT(i))
 				queue_uses[i]++;
 
@@ -5137,7 +5137,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 		end_time += e->interval;
 
-		for (i = 0; i < IGC_MAX_TX_QUEUES; i++) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
 			struct igc_ring *ring = adapter->tx_ring[i];
 
 			if (!(e->gate_mask & BIT(i)))
-- 
2.30.2



