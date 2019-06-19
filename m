Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FCD4C42D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFSXvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:51:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:53325 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfFSXvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 19:51:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 16:51:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="162363795"
Received: from anusha.jf.intel.com ([10.54.75.56])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2019 16:51:54 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Amber Lin <Amber.Lin@amd.com>, stable@vger.kernel.org
Subject: [PATCH 1/21] drm/amdgpu/soc15: skip reset on init
Date:   Wed, 19 Jun 2019 16:42:04 -0700
Message-Id: <20190619234224.7681-2-anusha.srivatsa@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619234224.7681-1-anusha.srivatsa@intel.com>
References: <20190619234224.7681-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

Not necessary on soc15 and breaks driver reload on server cards.

Acked-by: Amber Lin <Amber.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 4900e4958dec..b7e594c2bfb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -730,6 +730,11 @@ static bool soc15_need_reset_on_init(struct amdgpu_device *adev)
 {
 	u32 sol_reg;
 
+	/* Just return false for soc15 GPUs.  Reset does not seem to
+	 * be necessary.
+	 */
+	return false;
+
 	if (adev->flags & AMD_IS_APU)
 		return false;
 
