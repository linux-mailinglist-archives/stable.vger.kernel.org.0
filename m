Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E343A031B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhFHTMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238072AbhFHTKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE4A6194B;
        Tue,  8 Jun 2021 18:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178131;
        bh=F8QbrgkMST0zP7QLN7KoTtf9MfzQVxIpGnkdlrKDGIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rj8Mb+8RBLRhLK/MkaLA7ZRMvlo5QIfDPRZ94vBou+lPNGhLKAlOau9nY1mwqIqQ2
         dp32nbJO7o9IalT1x7Fk/QRK5GLrzV9VM+ObGsYOmBZkId/TTKAKmx2nwbA02SsPc8
         GCOYQtrNELHb7DCMJu9cgLbYQdm6H6KcLIn4gyoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 054/161] ice: handle the VF VSI rebuild failure
Date:   Tue,  8 Jun 2021 20:26:24 +0200
Message-Id: <20210608175947.299647110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 0f2a4d48574e..48dee9c5d534 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1377,7 +1377,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
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



