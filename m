Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5512C6E7
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbfL2Rvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732130AbfL2Rvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 366A5207FF;
        Sun, 29 Dec 2019 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641899;
        bh=xfqAEOXP8WL0uY3FmB+kfUgO7QT/ivSS/iu6YVabdDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijf7pV1kP/X9CAzU/655USn+K+VDzynTXzkOXDP1rn2kuPmJVrR1Od8fx/aFgG07G
         yCriZ2OraYFcS/KAuzEVfyIqBtDcWEOTW+oGsnyZC5JhMTDSke3xPsB0IGxBgtr3ga
         QEZgUkYA3zxPg1Vx1D/8bAUE3i1ikUFt5NPQ+TQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 258/434] ice: Check for null pointer dereference when setting rings
Date:   Sun, 29 Dec 2019 18:25:11 +0100
Message-Id: <20191229172719.070656145@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

[ Upstream commit eb0ee8abfeb9ff4b98e8e40217b8667bfb08587a ]

Without this check rebuild vsi can lead to kernel panic.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 214cd6eca405..2408f0de95fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3970,8 +3970,13 @@ int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_txq(vsi, i) {
-		vsi->tx_rings[i]->netdev = vsi->netdev;
-		err = ice_setup_tx_ring(vsi->tx_rings[i]);
+		struct ice_ring *ring = vsi->tx_rings[i];
+
+		if (!ring)
+			return -EINVAL;
+
+		ring->netdev = vsi->netdev;
+		err = ice_setup_tx_ring(ring);
 		if (err)
 			break;
 	}
@@ -3996,8 +4001,13 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_rxq(vsi, i) {
-		vsi->rx_rings[i]->netdev = vsi->netdev;
-		err = ice_setup_rx_ring(vsi->rx_rings[i]);
+		struct ice_ring *ring = vsi->rx_rings[i];
+
+		if (!ring)
+			return -EINVAL;
+
+		ring->netdev = vsi->netdev;
+		err = ice_setup_rx_ring(ring);
 		if (err)
 			break;
 	}
-- 
2.20.1



