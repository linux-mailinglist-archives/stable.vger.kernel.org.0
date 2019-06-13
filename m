Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0360143F75
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732249AbfFMP51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731505AbfFMIui (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB02120851;
        Thu, 13 Jun 2019 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415837;
        bh=uz75LieGNqizsVbiK595rPV0Y5C+lbCAJI48RNMXAFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbOorSpafSODhHlJgYlozjFAB9nD4l6eabHuoX5rJD/CaXzKUoQTXuWynGeajps4V
         h+tz6rGK+/q+nGmNWz7gOona8zZOhivai+BMJxv8uiapfRxctmqw1YylT77ZN1q24I
         s5vQDcMbdBKBZy47lDTIB2xHAWzFtX91kdxtopBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christopher N Bednarz <christopher.n.bednarz@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 140/155] ice: Do not set LB_EN for prune switch rules
Date:   Thu, 13 Jun 2019 10:34:12 +0200
Message-Id: <20190613075700.519695780@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b58dafbc6f1089942c1e74b8ab9c616fe06dbfac ]

LB_EN for prune switch rules was causing all TX traffic
to loopback to the internal switch and dropped.  When
running bi-directional stress workloads with RDMA
the RDPU would hang blocking tx and rx traffic.

Signed-off-by: Christopher N Bednarz <christopher.n.bednarz@intel.com>
Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index e40d5f34d59d..c5f6cfecc042 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -643,7 +643,12 @@ static void ice_fill_sw_info(struct ice_hw *hw, struct ice_fltr_info *fi)
 	     fi->fltr_act == ICE_FWD_TO_VSI_LIST ||
 	     fi->fltr_act == ICE_FWD_TO_Q ||
 	     fi->fltr_act == ICE_FWD_TO_QGRP)) {
-		fi->lb_en = true;
+		/* Setting LB for prune actions will result in replicated
+		 * packets to the internal switch that will be dropped.
+		 */
+		if (fi->lkup_type != ICE_SW_LKUP_VLAN)
+			fi->lb_en = true;
+
 		/* Set lan_en to TRUE if
 		 * 1. The switch is a VEB AND
 		 * 2
-- 
2.20.1



