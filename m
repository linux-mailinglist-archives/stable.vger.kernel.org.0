Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E016926EE2C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgIRC0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbgIRCQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95F92376F;
        Fri, 18 Sep 2020 02:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395352;
        bh=XO91kag5Q6XfDIlS8s8GXt9cwhzf2kZxdMNcZgYwiuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNCF69x+ExrDT3J54kyBO4k0Y78Bz4ROREo7JUt9tUorUt3qAZWZchGNfmD80b4iJ
         n/zOju2e46besTfW3aESOiLCXfOEplay5rfk7KsurX2VgfsJZ8dhQXvb3AGOkzHh5O
         KDa4qCXl1AaLcdgxKRWpH8GVUM8wV+DMzGjiF0Is=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Clements <john.clements@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 47/90] drm/amdgpu: increase atombios cmd timeout
Date:   Thu, 17 Sep 2020 22:14:12 -0400
Message-Id: <20200918021455.2067301-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
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
index 1b50e6c13fb3f..5fbf99d600587 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -748,8 +748,8 @@ static void atom_op_jump(atom_exec_context *ctx, int *ptr, int arg)
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

