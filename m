Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1693FDB65
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245466AbhIAMlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344592AbhIAMjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9870C61179;
        Wed,  1 Sep 2021 12:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499728;
        bh=Xds0caNBGsvrEbSX4KgRyhhNwjd2j0kw4FUUFbk0lEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnWD//nSo+tYJLgBbPCW67QDRRbj4kz9bqoAqlxyS6g92a3HvidEz4w6rhkGU39IF
         CJZ2JKuxYcS1Qd5GQUv/bsw4NwEpJMJwt2riVZrAa2gk5S1Kzw4WYym608AbS4dzCx
         nU3OSvQrz+Z7SqlYszQw2XwOPbf5Clcnc2DzW8bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Toshiki Nishioka <toshiki.nishioka@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/103] igc: Use num_tx_queues when iterating over tx_ring queue
Date:   Wed,  1 Sep 2021 14:27:39 +0200
Message-Id: <20210901122301.534031704@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
index 66f181d12578..013dd2955381 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4761,7 +4761,7 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < IGC_MAX_TX_QUEUES; i++) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
 			if (e->gate_mask & BIT(i))
 				queue_uses[i]++;
 
@@ -4818,7 +4818,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 		end_time += e->interval;
 
-		for (i = 0; i < IGC_MAX_TX_QUEUES; i++) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
 			struct igc_ring *ring = adapter->tx_ring[i];
 
 			if (!(e->gate_mask & BIT(i)))
-- 
2.30.2



