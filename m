Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CDA475EDB
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbhLORZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245690AbhLORY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C41DC061401;
        Wed, 15 Dec 2021 09:24:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF4B9B82032;
        Wed, 15 Dec 2021 17:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EB6C36AE2;
        Wed, 15 Dec 2021 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589065;
        bh=ow9ElXHwLjBAtozuohvt+zfqgSgEjHKmBHarp6sE6bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XLIRAgyQWhkO3Obsw1tBWt+uff4aB5zOUDfiIkimfI0TfQ4/fwrTwO4NeV7c5mW8
         W2S4z7CyHXniy04nHTt19OfFZUL5sHo5BB1Ff4Pd6OVM4e6wOaXO6ws4jARy3NSQpb
         3mZ7pMfmotzKH53iKUPMBfHVhtaS0yLUTwSOjPfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yahui Cao <yahui.cao@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/42] ice: fix FDIR init missing when reset VF
Date:   Wed, 15 Dec 2021 18:20:57 +0100
Message-Id: <20211215172027.202116027@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yahui Cao <yahui.cao@intel.com>

[ Upstream commit f23ab04dd6f703e282bb2d51fe3ae14f4b88a628 ]

When VF is being reset, ice_reset_vf() will be called and FDIR
resource should be released and initialized again.

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 8c223beeb6b8a..a78e8f00cf71b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1569,6 +1569,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		ice_vc_set_default_allowlist(vf);
 
 		ice_vf_fdir_exit(vf);
+		ice_vf_fdir_init(vf);
 		/* clean VF control VSI when resetting VFs since it should be
 		 * setup only when VF creates its first FDIR rule.
 		 */
@@ -1695,6 +1696,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	}
 
 	ice_vf_fdir_exit(vf);
+	ice_vf_fdir_init(vf);
 	/* clean VF control VSI when resetting VF since it should be setup
 	 * only when VF creates its first FDIR rule.
 	 */
-- 
2.33.0



