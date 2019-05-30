Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63C42EF49
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbfE3DyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbfE3DTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A8D724875;
        Thu, 30 May 2019 03:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186361;
        bh=wYieHLNEe73XiLDDBxsSVdJEWZEFWkLJP+IOnNb45lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiJmzr2KGyf/M4vm6WxMnNB8vkLk2DfZW1NlLcC635VKnawSVQl7CigLMCLf4O007
         XXzIWcFnVIZ4YvgBn2DGhY29ilNRx3BjDOeFUYUMRf0bUKy1+OPxaez4pZ3rSKezek
         fIAK0lZs5+RoiTDv44MF34k9yj/4ayQ6thMqYu88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/193] i40e: dont allow changes to HW VLAN stripping on active port VLANs
Date:   Wed, 29 May 2019 20:06:02 -0700
Message-Id: <20190530030503.845678754@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index 5d47a51e74eb8..39029a12a2337 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2499,6 +2499,10 @@ void i40e_vlan_stripping_enable(struct i40e_vsi *vsi)
 	struct i40e_vsi_context ctxt;
 	i40e_status ret;
 
+	/* Don't modify stripping options if a port VLAN is active */
+	if (vsi->info.pvid)
+		return;
+
 	if ((vsi->info.valid_sections &
 	     cpu_to_le16(I40E_AQ_VSI_PROP_VLAN_VALID)) &&
 	    ((vsi->info.port_vlan_flags & I40E_AQ_VSI_PVLAN_MODE_MASK) == 0))
@@ -2529,6 +2533,10 @@ void i40e_vlan_stripping_disable(struct i40e_vsi *vsi)
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



