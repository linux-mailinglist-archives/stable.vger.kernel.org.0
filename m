Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD233A009F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhFHSp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235365AbhFHSnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:43:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8644B61442;
        Tue,  8 Jun 2021 18:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177361;
        bh=pd5R80x10t4iMd9B2/849rrCx8yDnlMSlwOZF+OL50w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tplSIxI5c4QFAgiGhVvYaroEb3327GEMNg//7bWu6bkjWaAS1phKgOtL+VBqZwhH
         veslqV6F021ZwjQbfFMkak+D75T9Qihss/aizQKiuuRV+QLIqDO65Xkdob30rD31DH
         NjifgPGYkte7bxmHj9VWpRBedMqTf8QDa4hg9eIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/78] ice: write register with correct offset
Date:   Tue,  8 Jun 2021 20:26:53 +0200
Message-Id: <20210608175936.078963999@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 395594563b29fbcd8d9a4f0a642484e5d3bb6db1 ]

The VF_MBX_ARQLEN register array is per-PF, not global, so we should not
use the absolute VF ID as an index. Instead, use the per-PF VF ID.

This fixes an issue with VFs on PFs other than 0 not seeing reset.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e92a00a61755..360c0f7e0384 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -390,7 +390,7 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 	 * by the time we get here.
 	 */
 	if (!is_pfr)
-		wr32(hw, VF_MBX_ARQLEN(vf_abs_id), 0);
+		wr32(hw, VF_MBX_ARQLEN(vf->vf_id), 0);
 
 	/* In the case of a VFLR, the HW has already reset the VF and we
 	 * just need to clean up, so don't hit the VFRTRIG register.
-- 
2.30.2



