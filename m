Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CABD3F64DC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhHXRID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238847AbhHXRGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8102161462;
        Tue, 24 Aug 2021 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824382;
        bh=ixnNRBzBMRUstrfz7/QL7Rs11C2V3vFa7QdKKFaNhZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzutxEc5OEWE3cbFaudLI3ibCG2Y+00RV19p6O51G3oBsCn9udornT/LIN9pUyNTd
         2xMaRscm6XzwETJ/8Y/BgARd3sSxW5tEGQX9VXO1cWwJCupgzA0h1vEBOPdyA7yJx2
         PR1kyF6bO1JOhL5vMdiJnbBf3ZCexVrJNxLneMZd1nu53bwTn/bwrIZxXXEOWBtN2p
         8WzOowajc8BaSpC4Z/ZLmaX/pS8CAa0Svh3Tnki0Vm7OTGbDvLZM1Z6T9LGb+JgDYZ
         h2j/lBwMvSmmMGSdaj4rk/poctNt5j/5MfzD7Sgzit5SBzfMgCBFz7BkLpG618fx2J
         O5xroETaUu/og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bing Guo <bing.guo@amd.com>, Martin Leung <martin.leung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/98] drm/amd/display: Fix Dynamic bpp issue with 8K30 with Navi 1X
Date:   Tue, 24 Aug 2021 12:58:02 -0400
Message-Id: <20210824165908.709932-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bing Guo <bing.guo@amd.com>

[ Upstream commit 06050a0f01dbac2ca33145ef19a72041206ea983 ]

Why:
In DCN2x, HW doesn't automatically divide MASTER_UPDATE_LOCK_DB_X
by the number of pipes ODM Combined.

How:
Set MASTER_UPDATE_LOCK_DB_X to the value that is adjusted by the
number of pipes ODM Combined.

Reviewed-by: Martin Leung <martin.leung@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Bing Guo <bing.guo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index d8b18c515d06..e3cfb442a062 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -357,7 +357,7 @@ void optc2_lock_doublebuffer_enable(struct timing_generator *optc)
 
 	REG_UPDATE_2(OTG_GLOBAL_CONTROL1,
 			MASTER_UPDATE_LOCK_DB_X,
-			h_blank_start - 200 - 1,
+			(h_blank_start - 200 - 1) / optc1->opp_count,
 			MASTER_UPDATE_LOCK_DB_Y,
 			v_blank_start - 1);
 }
-- 
2.30.2

