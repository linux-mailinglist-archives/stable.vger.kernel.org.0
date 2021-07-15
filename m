Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E1C3CA821
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhGOS6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241650AbhGOS5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8201613DA;
        Thu, 15 Jul 2021 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375287;
        bh=43o12DKparZTph3QHIxzT2RGZNQMhr45ctVvpCSwr1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKQjbiPFboQ1SUrcE+rIPx94CW3AqXXL49O7tUgNe09M88U25IO/ypTvHyJhpdhOE
         APHCRtS9SZS+XlUbEiHQAXpzTkheU7zJ6++0LodHKS2n/sgHvE5ixVBRsNhDNsuJyp
         gyUKTpcOcAOHmnbAk2D0yYRUP+j+1ShIgsEUxRW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Zhang <Jack.Zhang1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        Emily Deng <Emily.Deng@amd.com>
Subject: [PATCH 5.12 005/242] drm/amd/amdgpu/sriov disable all ip hw status by default
Date:   Thu, 15 Jul 2021 20:36:07 +0200
Message-Id: <20210715182552.717060921@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Zhang <Jack.Zhang1@amd.com>

[ Upstream commit 95ea3dbc4e9548d35ab6fbf67675cef8c293e2f5 ]

Disable all ip's hw status to false before any hw_init.
Only set it to true until its hw_init is executed.

The old 5.9 branch has this change but somehow the 5.11 kernrel does
not have this fix.

Without this change, sriov tdr have gfx IB test fail.

Signed-off-by: Jack Zhang <Jack.Zhang1@amd.com>
Review-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 85d90e857693..a32b41e4c24e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2818,7 +2818,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 		AMD_IP_BLOCK_TYPE_IH,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(ip_order); i++) {
+	for (i = 0; i < adev->num_ip_blocks; i++) {
 		int j;
 		struct amdgpu_ip_block *block;
 
-- 
2.30.2



