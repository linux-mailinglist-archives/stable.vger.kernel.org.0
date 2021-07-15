Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3583CA70C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhGOSwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhGOSvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7482613DF;
        Thu, 15 Jul 2021 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374901;
        bh=+EjrSCLm7Socqe+OOWOjIGaOHL39kZtz9vJx6xZ1JIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqgwTljVbQjAGk/yl/1FFzEoISz6jK9adjNOBOI7dmy5iIQ1b5Pv+tLhaQBuSZ5CK
         8suO0b0zmIievY2ZOxj26F6GDMjVX8XlvWlSURJapifxbx69ywTlNImtMSgq0milDH
         N8vz/wYJjDMyNZ44OGw4GjmRyL4Fz40yUkfo59Rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/215] ice: fix clang warning regarding deadcode.DeadStores
Date:   Thu, 15 Jul 2021 20:37:09 +0200
Message-Id: <20210715182609.520475877@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 7e94090ae13e1ae5fe8bd3a9cd08136260bb7039 ]

clang generates deadcode.DeadStores warnings when a variable
is used to read a value, but then that value isn't used later
in the code. Fix this warning.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a7975afecf70..14eba9bc174d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3492,13 +3492,9 @@ static int
 ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		    struct ice_ring_container *rc)
 {
-	struct ice_pf *pf;
-
 	if (!rc->ring)
 		return -EINVAL;
 
-	pf = rc->ring->vsi->back;
-
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc->itr_setting);
@@ -3510,7 +3506,7 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		ec->tx_coalesce_usecs = rc->itr_setting & ~ICE_ITR_DYNAMIC;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(pf), "Invalid c_type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", c_type);
 		return -EINVAL;
 	}
 
-- 
2.30.2



