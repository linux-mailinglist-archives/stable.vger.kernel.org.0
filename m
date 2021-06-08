Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2673A01FB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbhFHS6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235086AbhFHS41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B21A46143B;
        Tue,  8 Jun 2021 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177735;
        bh=Ln7XM+9UIYmi5Q3U8U4/7CEUVL8g+oE4KB/oHk4PHgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFgOXaCLEou/Vk0f3LdAyyzrRmsNq9qdH5kPl8UNmL/jFTH9WpWVIk8CGB7s5LTfj
         VwN6USuLCYhJ4NUDM2gceJvs4LyJdklPGQba0sTg1px/WwUdupF+ETHmcRjaypIpGP
         2wbLurXJVxxveorLbndiCCDavV0KXm0ItZM+Yfrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/137] ice: handle the VF VSI rebuild failure
Date:   Tue,  8 Jun 2021 20:26:27 +0200
Message-Id: <20210608175943.999818850@linuxfoundation.org>
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

From: Haiyue Wang <haiyue.wang@intel.com>

[ Upstream commit c7ee6ce1cf60b7fcdbdd2354d377d00bae3fa2d2 ]

VSI rebuild can be failed for LAN queue config, then the VF's VSI will
be NULL, the VF reset should be stopped with the VF entering into the
disable state.

Fixes: 12bb018c538c ("ice: Refactor VF reset")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 374ccce2a784..c9f82fd3cf48 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1341,7 +1341,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	}
 
 	ice_vf_pre_vsi_rebuild(vf);
-	ice_vf_rebuild_vsi_with_release(vf);
+
+	if (ice_vf_rebuild_vsi_with_release(vf)) {
+		dev_err(dev, "Failed to release and setup the VF%u's VSI\n", vf->vf_id);
+		return false;
+	}
+
 	ice_vf_post_vsi_rebuild(vf);
 
 	return true;
-- 
2.30.2



