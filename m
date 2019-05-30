Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C82F0E9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfE3EI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731074AbfE3DRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:19 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4AE246BE;
        Thu, 30 May 2019 03:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186239;
        bh=FjfK/RamjqEShfTjBAQ5NavTeA4udxDVHYeDtM2xaqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idGxML0pZvkP0we+6tl4DJRqw937Jec2qy15Rb4gpdGT7y2phSvcTa1xrFJZ3oDhY
         A8M9LuxtCTwXabY1fNyr8FvHVJLLwmvW8gez2A/z99Op9LKgFz5B1pivRARjx5A/RA
         pZliycdHZXcyujJcpPWGzm9tHejes+zW0XCAOrmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/276] i40e: dont allow changes to HW VLAN stripping on active port VLANs
Date:   Wed, 29 May 2019 20:05:08 -0700
Message-Id: <20190530030534.974271194@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bfb0ebed53857cfc57f11c63fa3689940d71c1c8 ]

Modifying the VLAN stripping options when a port VLAN is configured
will break traffic for the VSI, and conceptually doesn't make sense,
so don't allow this.

Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f81ad0aa8b095..df8808cd7e114 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2654,6 +2654,10 @@ void i40e_vlan_stripping_enable(struct i40e_vsi *vsi)
 	struct i40e_vsi_context ctxt;
 	i40e_status ret;
 
+	/* Don't modify stripping options if a port VLAN is active */
+	if (vsi->info.pvid)
+		return;
+
 	if ((vsi->info.valid_sections &
 	     cpu_to_le16(I40E_AQ_VSI_PROP_VLAN_VALID)) &&
 	    ((vsi->info.port_vlan_flags & I40E_AQ_VSI_PVLAN_MODE_MASK) == 0))
@@ -2684,6 +2688,10 @@ void i40e_vlan_stripping_disable(struct i40e_vsi *vsi)
 	struct i40e_vsi_context ctxt;
 	i40e_status ret;
 
+	/* Don't modify stripping options if a port VLAN is active */
+	if (vsi->info.pvid)
+		return;
+
 	if ((vsi->info.valid_sections &
 	     cpu_to_le16(I40E_AQ_VSI_PROP_VLAN_VALID)) &&
 	    ((vsi->info.port_vlan_flags & I40E_AQ_VSI_PVLAN_EMOD_MASK) ==
-- 
2.20.1



