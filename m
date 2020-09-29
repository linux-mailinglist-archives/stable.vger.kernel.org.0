Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5056D27CDE7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbgI2Mrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbgI2LEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:04:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A19C20C09;
        Tue, 29 Sep 2020 11:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377449;
        bh=XO91kag5Q6XfDIlS8s8GXt9cwhzf2kZxdMNcZgYwiuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoforYoD3ptMhSPq7rl090VGadAnCiYKrhlFV+S47JHwfZMmxPwjA01hbgqIet8B+
         +AmZAAmjWBgaSafu5zs2pdiPBBuOZZHTLtuYWIBGak6MozSv2Tr2V36JmSdeiRZ2xM
         cAl6fvIWLcXcW20wK3DUfzxfX12EnqHe+9+PTl7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        John Clements <john.clements@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 40/85] drm/amdgpu: increase atombios cmd timeout
Date:   Tue, 29 Sep 2020 13:00:07 +0200
Message-Id: <20200929105930.230633955@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



