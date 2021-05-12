Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190B737CA62
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhELQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236058AbhELQU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9088A61D92;
        Wed, 12 May 2021 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834391;
        bh=czTVWHDsEPT3bcVc8PM98DjjHldqBVUTMPfLg68Z0kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aa1unEejsPrhTMq6Sw4q+i6FZJYNYnX9knt10WurFMoI8zKbq3jkODpIpLFOGN4c3
         CLbhMWgv/zN/ND4BlSu1nb1K9gmPEoJXH7kZNHqgjBMUNClCTkB4W5gfOTGeUm+Ak5
         qdWdZ1ZNb5C6ttdVegensCa7CS52hRXZHGoQM8UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 517/601] drm/amd/pm: fix error code in smu_set_power_limit()
Date:   Wed, 12 May 2021 16:49:54 +0200
Message-Id: <20210512144844.882894992@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit bbdfe5aaef3c1d5c5e62fa235ef13f064e4c1c17 ]

We should return -EINVAL instead of success if the "limit" is too high.

Fixes: e098bc9612c2 ("drm/amd/pm: optimize the power related source code layout")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index e84c737e3967..57b5a9e96893 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1931,6 +1931,7 @@ int smu_set_power_limit(struct smu_context *smu, uint32_t limit)
 		dev_err(smu->adev->dev,
 			"New power limit (%d) is over the max allowed %d\n",
 			limit, smu->max_power_limit);
+		ret = -EINVAL;
 		goto out;
 	}
 
-- 
2.30.2



