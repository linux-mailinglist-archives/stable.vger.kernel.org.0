Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B03F65A3
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhHXRPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235316AbhHXRNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:13:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585D761A63;
        Tue, 24 Aug 2021 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824491;
        bh=8bwAjELKBHfEtCgO7fakYsnNJbvNAarkcSTfOot+Cqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUpYGCt2sAXyj/tcVcf68DKJD1nbxvSrupi69ZWCqhGQPjPYOTuWkYB7qoFnBgGYt
         t1vjnw8oGDZqYtmMwbKrDj/oEaB2ouik4NIzuu5+5fehAQw78MHkIZ2KHySxhVrrkR
         hL63yYAyc7opU1AL9jIHAi7FGDGfDVhiqv9NWm6LtWSwc+0xjXChUNUH38WqeLcBA2
         uHvNQsPL2AWvWPSU2ExZNQee023Pkbc1Xzzab4pOjN7xASZGRMcb8oPFzwDQz9UTh8
         EzCyEviLUvxc+HnpAxxkdThJ4emhwFKIJt/UywFf03ZuQtyndcW/WaimBI2N7M38rZ
         By8j2XCR3pUeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bing Guo <bing.guo@amd.com>, Martin Leung <martin.leung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/61] drm/amd/display: Fix Dynamic bpp issue with 8K30 with Navi 1X
Date:   Tue, 24 Aug 2021 13:00:28 -0400
Message-Id: <20210824170106.710221-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 8d5cfd5357c7..03e207333953 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -362,7 +362,7 @@ void optc2_lock_doublebuffer_enable(struct timing_generator *optc)
 
 	REG_UPDATE_2(OTG_GLOBAL_CONTROL1,
 			MASTER_UPDATE_LOCK_DB_X,
-			h_blank_start - 200 - 1,
+			(h_blank_start - 200 - 1) / optc1->opp_count,
 			MASTER_UPDATE_LOCK_DB_Y,
 			v_blank_start - 1);
 }
-- 
2.30.2

