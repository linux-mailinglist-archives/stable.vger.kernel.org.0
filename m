Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B1340EF5C
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242935AbhIQCfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242924AbhIQCfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C89610C8;
        Fri, 17 Sep 2021 02:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846032;
        bh=awLMpc4E9oLBX52XLLgSWSIK62ks08HtPaM9FK5pYVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D88Y8ATRbMOh8aXYsHXl+6W6Gkf30wzGlywua8B4b6z6C86+pFJFWwFW5ISaqHKEa
         6dl9GTXJ3LswpeoypKWxkbyCdgJAhCzUuUwQc2MZzwdTLrSshPAuFMZ4yGXCU9O+km
         WbPpwju36IiP5RTz3nsIeEiZx/D8N/XxAva4Rg2eytANCEvCyxiQsIDXImDQ09J03a
         ZwZKn35SxD242++mo605Ix7tCpqiZIEsL56E5dTDSy8RDmrhJ5i1UjoqZVfpOPPETa
         JbskcgMqLicsxD4Y4nm7SBqp6qfAvyfGEyIHG5Jj5OedZi6HlgCSM1/BGbkk0jKNiy
         9tMqGCnwWFvmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Jacob <Anson.Jacob@amd.com>, Aric Cyr <aric.cyr@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, aurabindo.pillai@amd.com,
        Rodrigo.Siqueira@amd.com, joshua.aberback@amd.com,
        Bhawanpreet.Lakha@amd.com, bindu.r@amd.com,
        Dmytro.Laktyushkin@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 05/21] drm/amd/display: Fix memory leak reported by coverity
Date:   Thu, 16 Sep 2021 22:32:59 -0400
Message-Id: <20210917023315.816225-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 03388a347fe7cf7c3bdf68b0823ba316d177d470 ]

Free memory allocated if any of the previous allocations failed.

>>>     CID 1487129:  Resource leaks  (RESOURCE_LEAK)
>>>     Variable "vpg" going out of scope leaks the storage it points to.

Addresses-Coverity-ID: 1487129: ("Resource leaks")

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
index dc7823d23ba8..dd38796ba30a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -510,8 +510,12 @@ static struct stream_encoder *dcn303_stream_encoder_create(enum engine_id eng_id
 	vpg = dcn303_vpg_create(ctx, vpg_inst);
 	afmt = dcn303_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt)
+	if (!enc1 || !vpg || !afmt) {
+		kfree(enc1);
+		kfree(vpg);
+		kfree(afmt);
 		return NULL;
+	}
 
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios, eng_id, vpg, afmt, &stream_enc_regs[eng_id],
 			&se_shift, &se_mask);
-- 
2.30.2

