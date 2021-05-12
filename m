Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD637CE6B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhELRFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhELQn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B3B61E66;
        Wed, 12 May 2021 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836037;
        bh=W/J91zfDrdR0y/WdBhCTUeoQUxTGdyFIdokr28/iwrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ey2Mha9uBlFxrGhze/aJbB00Xqm+zOgwB6YE9mx+ETd+ZgzU0vVG6T6Ttm45pa/eM
         LRkWjrK5sIAK9TqxXNcJqKU9ReBqwYMNKBSJuJHlMoqGhHfW6p7olbH3bDxwRW0Ne9
         /SEQeiDHES7P16lpiihonvQ5O+JXIuUN1RHevNYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 584/677] drm/amd/pm: fix error code in smu_set_power_limit()
Date:   Wed, 12 May 2021 16:50:30 +0200
Message-Id: <20210512144856.790475346@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 42c4dbe3e362..ec0037a21331 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2086,6 +2086,7 @@ int smu_set_power_limit(struct smu_context *smu, uint32_t limit)
 		dev_err(smu->adev->dev,
 			"New power limit (%d) is over the max allowed %d\n",
 			limit, smu->max_power_limit);
+		ret = -EINVAL;
 		goto out;
 	}
 
-- 
2.30.2



