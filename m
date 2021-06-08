Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69BA3A01F8
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhFHS6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237027AbhFHS4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C94613F9;
        Tue,  8 Jun 2021 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177729;
        bh=OgKfNeI2oG7uHvlnPSOFO1pQizsjZQuqll09ekzwXO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwpCYM8SZIV4cgXICvJW9if/NW4W4J7fS0N2lUku6AecqjSWixKA5Dl1NgYOcvL8u
         oPqI0gtHwo5DO7ibZAFisJuMWfvJ86tO3MgTZpq1yjGkb8FrV6ox5vFFbw49w/h3ia
         f2v9lC7h5WnUKeoYL6g7A9cCn/PtdXLgDsuz41ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/137] ice: Fix allowing VF to request more/less queues via virtchnl
Date:   Tue,  8 Jun 2021 20:26:25 +0200
Message-Id: <20210608175943.933631997@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit f0457690af56673cb0c47af6e25430389a149225 ]

Commit 12bb018c538c ("ice: Refactor VF reset") caused a regression
that removes the ability for a VF to request a different amount of
queues via VIRTCHNL_OP_REQUEST_QUEUES. This prevents VF drivers to
either increase or decrease the number of queue pairs they are
allocated. Fix this by using the variable vf->num_req_qs when
determining the vf->num_vf_qs during VF VSI creation.

Fixes: 12bb018c538c ("ice: Refactor VF reset")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e1384503dd4d..fb20c6971f4c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -192,6 +192,8 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		break;
 	case ICE_VSI_VF:
 		vf = &pf->vf[vsi->vf_id];
+		if (vf->num_req_qs)
+			vf->num_vf_qs = vf->num_req_qs;
 		vsi->alloc_txq = vf->num_vf_qs;
 		vsi->alloc_rxq = vf->num_vf_qs;
 		/* pf->num_msix_per_vf includes (VF miscellaneous vector +
-- 
2.30.2



