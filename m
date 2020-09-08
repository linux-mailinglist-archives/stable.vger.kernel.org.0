Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E29261E9F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgIHTxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbgIHPrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:47:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDCE247FE;
        Tue,  8 Sep 2020 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579822;
        bh=yQDsG4Dukt9Zl7PbICuxCz2UQrfZce1uCsChE6idIWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WghZCykpfBygmcevXnNI5n+paTBdt9qd3roSQIJtbsGHUM7KHc75qN95QOfwHNkFx
         YBSbtvXSd3KgFox2J6+mRTr7P8AZGaUITAf0uEFplUJc/3+KMly25JWLXvP32hUYVp
         TCiLWsy1SPkpYZy5UBhBwwgOrEdQaFXAZvhuAmf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/129] drm/amd/display: Retry AUX write when fail occurs
Date:   Tue,  8 Sep 2020 17:24:19 +0200
Message-Id: <20200908152230.613105567@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit ef67d792a2fc578319399f605fbec2f99ecc06ea ]

[Why]
In dm_dp_aux_transfer() now, we forget to handle AUX_WR fail cases. We
suppose every write wil get done successfully and hence some AUX
commands might not sent out indeed.

[How]
Check if AUX_WR success. If not, retry it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 28a6c7b2ef4bb..2f858507ca702 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -101,7 +101,7 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
-	if (payload.write)
+	if (payload.write && result >= 0)
 		result = msg->size;
 
 	if (result < 0)
-- 
2.25.1



