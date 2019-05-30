Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9E12EF4A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfE3DyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731867AbfE3DTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D064424858;
        Thu, 30 May 2019 03:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186360;
        bh=UsriQawRmItfQgDQoCaAAj1BgkXuglOS8wvbCwk4fBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhoZgpqWUu+ML35mNdqc8KGx3mxhbBPIHXTYzi4p3ROWi6do+EHrtWLq7vrk3jkyp
         OvZrKAYdATb1HTUNk40KdoVYSF7RnD5eKbrv4N4bDIo/63OgidLJcILvek024pUUM8
         SxjPGt7XMMfm9dM9zkLEGNRZNfF3Zb2fxDdSLXBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Ludkiewicz <adam.ludkiewicz@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 107/193] i40e: Able to add up to 16 MAC filters on an untrusted VF
Date:   Wed, 29 May 2019 20:06:01 -0700
Message-Id: <20190530030503.706926174@linuxfoundation.org>
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

[ Upstream commit 06b6e2a2333eb3581567a7ac43ca465ef45f4daa ]

This patch fixes the problem with the driver being able to add only 7
multicast MAC address filters instead of 16. The problem is fixed by
changing the maximum number of MAC address filters to 16+1+1 (two extra
are needed because the driver uses 1 for unicast MAC address and 1 for
broadcast).

Signed-off-by: Adam Ludkiewicz <adam.ludkiewicz@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 4a85a24ced1c8..bdb7523216000 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2029,8 +2029,10 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
 				      (u8 *)&stats, sizeof(stats));
 }
 
-/* If the VF is not trusted restrict the number of MAC/VLAN it can program */
-#define I40E_VC_MAX_MAC_ADDR_PER_VF 12
+/* If the VF is not trusted restrict the number of MAC/VLAN it can program
+ * MAC filters: 16 for multicast, 1 for MAC, 1 for broadcast
+ */
+#define I40E_VC_MAX_MAC_ADDR_PER_VF (16 + 1 + 1)
 #define I40E_VC_MAX_VLAN_PER_VF 8
 
 /**
-- 
2.20.1



