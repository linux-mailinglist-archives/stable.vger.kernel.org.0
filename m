Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812FE412591
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384008AbhITSqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382750AbhITSmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A6C61AD2;
        Mon, 20 Sep 2021 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159113;
        bh=g4eGBlnRG6fPLk2XoxMXa24CVhwkz+Ttj833hlqG8Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxvU5MtetcsDNJDsjI9qvUI6GecD5+hMDwbDL5btZrgqBzrXHYtqSEU+j9ID4krLG
         63Vst7y9MFj+QSpiZgt6RDSHjO54hh8bWYMHY+4mfqr40f3Ck38ZJ1WTqkEwHjc+xI
         IsZMpwxTaL40kefBgTDJegYW3P268KtGwGHkt2fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongxin Liu <yongxin.liu@windriver.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 082/168] ice: Correctly deal with PFs that do not support RDMA
Date:   Mon, 20 Sep 2021 18:43:40 +0200
Message-Id: <20210920163924.334287100@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit bfe84435090a6c85271b02a42b1d83fef9ff7cc7 ]

There are two cases where the current PF does not support RDMA
functionality.  The first is if the NVM loaded on the device is set
to not support RDMA (common_caps.rdma is false).  The second is if
the kernel bonding driver has included the current PF in an active
link aggregate.

When the driver has determined that this PF does not support RDMA, then
auxiliary devices should not be created on the auxiliary bus.  Without
a device on the auxiliary bus, even if the irdma driver is present, there
will be no RDMA activity attempted on this PF.

Currently, in the reset flow, an attempt to create auxiliary devices is
performed without regard to the ability of the PF.  There needs to be a
check in ice_aux_plug_dev (as the central point that creates auxiliary
devices) to see if the PF is in a state to support the functionality.

When disabling and re-enabling RDMA due to the inclusion/removal of the PF
in a link aggregate, we also need to set/clear the bit which controls
auxiliary device creation so that a reset recovery in a link aggregate
situation doesn't try to create auxiliary devices when it shouldn't.

Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h     | 2 ++
 drivers/net/ethernet/intel/ice/ice_idc.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index eadcb9958346..3c4f08d20414 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -695,6 +695,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
 {
 	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
 		ice_plug_aux_dev(pf);
 	}
 }
@@ -707,5 +708,6 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
 	ice_unplug_aux_dev(pf);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 1f2afdf6cd48..adcc9a251595 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -271,6 +271,12 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 	struct auxiliary_device *adev;
 	int ret;
 
+	/* if this PF doesn't support a technology that requires auxiliary
+	 * devices, then gracefully exit
+	 */
+	if (!ice_is_aux_ena(pf))
+		return 0;
+
 	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
 	if (!iadev)
 		return -ENOMEM;
-- 
2.30.2



