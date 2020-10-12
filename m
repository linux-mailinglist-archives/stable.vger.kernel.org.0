Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C3028B864
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgJLNwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D77E22248;
        Mon, 12 Oct 2020 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510415;
        bh=y0U/F0YjnhoSfqzuWVCQ2N/yVFHQjp6Lc7MXTaRvUP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLC3iXK0cXhBsbTtH7P5Sb5ExS8sJVdRT9yoA6LMxG9PzFe39wkpfh5UMvm3EMpSr
         pL0PCWvOUV7QxsJvDjAzu6gBU54tkhyo/MN8amH/1J9nC6ERG6jHZMY08yWYJGgLVD
         HhdvEgob3DGT+KniW5lWT1NshGZs0TIKai1LfHxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Flora Cui <flora.cui@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 049/124] drm/amd/display: fix return value check for hdcp_work
Date:   Mon, 12 Oct 2020 15:30:53 +0200
Message-Id: <20201012133149.225917042@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit 898c7302f4de1d91065e80fc46552b3ec70894ff ]

max_caps might be 0, thus hdcp_work might be ZERO_SIZE_PTR

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 949d10ef83040..6dd1f3f8d9903 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -568,7 +568,7 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct
 	int i = 0;
 
 	hdcp_work = kcalloc(max_caps, sizeof(*hdcp_work), GFP_KERNEL);
-	if (hdcp_work == NULL)
+	if (ZERO_OR_NULL_PTR(hdcp_work))
 		return NULL;
 
 	hdcp_work->srm = kcalloc(PSP_HDCP_SRM_FIRST_GEN_MAX_SIZE, sizeof(*hdcp_work->srm), GFP_KERNEL);
-- 
2.25.1



