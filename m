Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D3C3E5D28
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242611AbhHJORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242614AbhHJOQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD52561008;
        Tue, 10 Aug 2021 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604963;
        bh=ixnNRBzBMRUstrfz7/QL7Rs11C2V3vFa7QdKKFaNhZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2iirXyXccCSh7l7dxwXNMcx59oplPPXZI/zsFgCc1zonbARHBHmea3wx4VLybdn2
         Qk0xjNoMyKnV6Rr80Y2sjD1shcxU+TrMIqGD6QNDGQgBt3S6KXiirqRTS25tA8yyDg
         i6Vt773USOsKFxSmUTAS4h/+I+j+vr9puqOnkcUqqej/q6iojogFOwOzuBt6K4MUb1
         TzvX1uO/2WaRKU3a/5yCFKBS2QBHrEjZrY3LkLRjN6C47kAZswR5w5Sb/2BF+TMkqi
         UtREmjHFQJRtmaLO//crVgXeUuN1/oR1Zac4lAtTAhyNnA41LgnEhbBA54n0pQNA6+
         rv0yMPmIqjetg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bing Guo <bing.guo@amd.com>, Martin Leung <martin.leung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 19/20] drm/amd/display: Fix Dynamic bpp issue with 8K30 with Navi 1X
Date:   Tue, 10 Aug 2021 10:15:37 -0400
Message-Id: <20210810141538.3117707-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
MIME-Version: 1.0
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

