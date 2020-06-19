Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6720133A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392644AbgFSP7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392397AbgFSPTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A1A3218AC;
        Fri, 19 Jun 2020 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579958;
        bh=OMuK4o8Ehu5BM1rbVHdg6XjAxzAvk11aTBSgHZG4xWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijb5k+3aEwiIoWZCpWPbD1X4gPttbbYVs/SgTuCWuZCzEhmVJFA6B5cV2Nfoa7SBl
         Pr2MCjsseeN/Gq0P5Hbzpu4carzZbGKyG21V9BG/O9VYlfJlULw95R7nd3cEzJjTkI
         ulKxKA/vxPp2Hrx6KhXa4m2PVk1f+aK3oGX0xO4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Surabhi Boob <surabhi.boob@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 068/376] ice: Fix memory leak
Date:   Fri, 19 Jun 2020 16:29:46 +0200
Message-Id: <20200619141713.573491445@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

[ Upstream commit 1aaef2bc4e0a5ce9e4dd86359e6a0bf52c6aa64f ]

Handle memory leak on filter management initialization failure.

Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2c0d8fd3d5cd..09b374590ffc 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -322,6 +322,7 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 static enum ice_status ice_init_fltr_mgmt_struct(struct ice_hw *hw)
 {
 	struct ice_switch_info *sw;
+	enum ice_status status;
 
 	hw->switch_info = devm_kzalloc(ice_hw_to_dev(hw),
 				       sizeof(*hw->switch_info), GFP_KERNEL);
@@ -332,7 +333,12 @@ static enum ice_status ice_init_fltr_mgmt_struct(struct ice_hw *hw)
 
 	INIT_LIST_HEAD(&sw->vsi_list_map_head);
 
-	return ice_init_def_sw_recp(hw);
+	status = ice_init_def_sw_recp(hw);
+	if (status) {
+		devm_kfree(ice_hw_to_dev(hw), hw->switch_info);
+		return status;
+	}
+	return 0;
 }
 
 /**
-- 
2.25.1



