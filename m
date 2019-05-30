Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588292F6AE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfE3E6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbfE3DJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:50 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BAD424493;
        Thu, 30 May 2019 03:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185789;
        bh=i9z4KHR11Up/9y1I6Td8Ei325Q0bHiPkdTRW7D/gym0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMcg61i8bY+ISgjt1I1Pf8fwMeoD3S//RvUE+pLubam/KH114EdWyiYpPJ4+E3kyh
         CMPJD0HJkmaiRPNpRKBbezQ9MWEIUFbvXf6gFyBvjS3id7U7bA/cj+6UG2Aj9hQpUp
         beCHAgd3RJ/n066oHEPWfg0/GcZnDiUlqV40JVOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 060/405] ice: Preserve VLAN Rx stripping settings
Date:   Wed, 29 May 2019 20:00:58 -0700
Message-Id: <20190530030543.985405676@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e80e76db6c5bbc7a8f8512f3dc630a2170745b0b ]

When Tx insertion is set, we are not accounting for the state of Rx
stripping.  This causes Rx stripping to be enabled any time Tx
insertion is changed, even when it's supposed to be disabled.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fa61203bee269..b710545cf7d1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1848,6 +1848,10 @@ int ice_vsi_manage_vlan_insertion(struct ice_vsi *vsi)
 	 */
 	ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_MODE_ALL;
 
+	/* Preserve existing VLAN strip setting */
+	ctxt->info.vlan_flags |= (vsi->info.vlan_flags &
+				  ICE_AQ_VSI_VLAN_EMOD_M);
+
 	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID);
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
-- 
2.20.1



