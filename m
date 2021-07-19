Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55B3CDB67
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbhGSOmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243555AbhGSOkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DCA66024A;
        Mon, 19 Jul 2021 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708053;
        bh=vXYDH9K+6se0soj7y+zLJcB1T3Flabi/5hQ0OnzmT0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+DE67ZqKyLKrUOHLTZdanTwlXIOSuwOXA7n21U2s6ipHxshxU9RIwM8n7GujY9PD
         fTvzSFrCF2bzqIdJ96qwyy5f4dxEuXoi9BTW9oi1SdLydWRAwBbbkQbWIXSbgNNd+U
         m2SYERd3M9Z+t5TQkHyDBHLMv50pZta+EEbLAvYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Zhang <Jack.Zhang1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        Emily Deng <Emily.Deng@amd.com>
Subject: [PATCH 4.14 162/315] drm/amd/amdgpu/sriov disable all ip hw status by default
Date:   Mon, 19 Jul 2021 16:50:51 +0200
Message-Id: <20210719144948.223090870@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index bc746a6e0ecc..076b22c44122 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1823,7 +1823,7 @@ static int amdgpu_sriov_reinit_early(struct amdgpu_device *adev)
 		AMD_IP_BLOCK_TYPE_IH,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(ip_order); i++) {
+	for (i = 0; i < adev->num_ip_blocks; i++) {
 		int j;
 		struct amdgpu_ip_block *block;
 
-- 
2.30.2



