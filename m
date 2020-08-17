Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700822476D6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgHQPXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgHQPXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:23:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6FE220825;
        Mon, 17 Aug 2020 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677800;
        bh=5nvVShMLBwuUp6LU+hHsIvdvQMl7FDGzUFNL3/E2l6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfvnmjP5NW6ufMNWwmhoqpBEsFe1+NQ5jBFett3S2z022S2ufZIX2NAKrAUcOGRQl
         slK7OU8n13ebnY//7Qh/D22enUNyxzYLW2AqhYlttpLgxwouFb9Oq/mu4krSsGA+Qf
         9238/rhAmpua6Cm3xoXgEppa9DqXi5CO0lOqRFag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 112/464] drm/amdgpu/display bail early in dm_pp_get_static_clocks
Date:   Mon, 17 Aug 2020 17:11:05 +0200
Message-Id: <20200817143839.171303204@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 376814f5fcf1aadda501d1413d56e8af85d19a97 ]

If there are no supported callbacks.  We'll fall back to the
nominal clocks.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1170
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
index a2e1a73f66b81..7cee8070cb113 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
@@ -530,6 +530,8 @@ bool dm_pp_get_static_clocks(
 			&pp_clk_info);
 	else if (adev->smu.ppt_funcs)
 		ret = smu_get_current_clocks(&adev->smu, &pp_clk_info);
+	else
+		return false;
 	if (ret)
 		return false;
 
-- 
2.25.1



