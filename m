Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24012C52E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfL2Re3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbfL2Re3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:34:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588F121D7E;
        Sun, 29 Dec 2019 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640868;
        bh=0uIBBGWugDnYEAcXZq1W7yPfBYR4A4GTFNtN/6NmIBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhVWkwWI0rFLIW419whgGFRyTgSoJ+beaCRRvhAK3K/QW+9AomWcky42kEIJQNYWv
         ERVLpVE9TpdjgdDnzCyQnE4DWbj49cwuwuOCX7ffU3dsORQGRQizRmbD/jmM2JfE3x
         S01wca6/nBpjjvtJK3bv7gV8cYBv5qudNohcweco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Candice Li <Candice.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/219] drm/amdgpu: disallow direct upload save restore list from gfx driver
Date:   Sun, 29 Dec 2019 18:18:55 +0100
Message-Id: <20191229162528.855860294@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 58f46d4b65021083ef4b4d49c6e2c58e5783f626 ]

Direct uploading save/restore list via mmio register writes breaks the security
policy. Instead, the driver should pass s&r list to psp.

For all the ASICs that use rlc v2_1 headers, the driver actually upload s&r list
twice, in non-psp ucode front door loading phase and gfx pg initialization phase.
The latter is not allowed.

VG12 is the only exception where the driver still keeps legacy approach for S&R
list uploading. In theory, this can be elimnated if we have valid srcntl ucode
for VG12.

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Candice Li <Candice.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 782411649816..28794b1b15c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2187,7 +2187,8 @@ static void gfx_v9_0_init_pg(struct amdgpu_device *adev)
 	 * And it's needed by gfxoff feature.
 	 */
 	if (adev->gfx.rlc.is_rlc_v2_1) {
-		gfx_v9_1_init_rlc_save_restore_list(adev);
+		if (adev->asic_type == CHIP_VEGA12)
+			gfx_v9_1_init_rlc_save_restore_list(adev);
 		gfx_v9_0_enable_save_restore_machine(adev);
 	}
 
-- 
2.20.1



