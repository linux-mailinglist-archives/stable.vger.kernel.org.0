Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287DC26F347
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgIRDFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbgIRCEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ECA223119;
        Fri, 18 Sep 2020 02:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394664;
        bh=f8gRk8eAyptuVsstm1uPSzF0miGBAcPzNLfF8INKp44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzuhfYwEojeUcWNHQwQwLq0XYRbt7pNkcRY7gvW4tP+4ImBMYBoJvRP4eJnszZ6u3
         02MuZpCCHoFxS7TCJIe++5pUQspmqm01h0S9wA+jjxYtmKbeOduW8Gd4SK+PjQ+Egv
         pbDwDEBbFhPduHPVHKCIJXMUdtsEnWEzkclxnsVE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Clements <john.clements@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 158/330] drm/amdgpu: increase atombios cmd timeout
Date:   Thu, 17 Sep 2020 21:58:18 -0400
Message-Id: <20200918020110.2063155-158-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Clements <john.clements@amd.com>

[ Upstream commit 1b3460a8b19688ad3033b75237d40fa580a5a953 ]

mitigates race condition on BACO reset between GPU bootcode and driver reload

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: John Clements <john.clements@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index dd30f4e61a8cd..cae426c7c0863 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -744,8 +744,8 @@ static void atom_op_jump(atom_exec_context *ctx, int *ptr, int arg)
 			cjiffies = jiffies;
 			if (time_after(cjiffies, ctx->last_jump_jiffies)) {
 				cjiffies -= ctx->last_jump_jiffies;
-				if ((jiffies_to_msecs(cjiffies) > 5000)) {
-					DRM_ERROR("atombios stuck in loop for more than 5secs aborting\n");
+				if ((jiffies_to_msecs(cjiffies) > 10000)) {
+					DRM_ERROR("atombios stuck in loop for more than 10secs aborting\n");
 					ctx->abort = true;
 				}
 			} else {
-- 
2.25.1

