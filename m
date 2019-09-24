Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDABFBCCCD
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403801AbfIXQmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392940AbfIXQmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6EF220872;
        Tue, 24 Sep 2019 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343331;
        bh=p/LTZv2Rg4AcXfx4nYRbWpJmu7o4xkjBC4qUBZfeDW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZk1iqXagr46juZzlk1YrEUJDtmf7fCI5MSeBLzWj4UiF/pNT2wY2ExSE08wr0/dg
         RR2a6jFxbQmoRip+PodmcB3pIu7lx6AoY8q0yG+DpjGoOD6Ya1nw18cMB9gpiQnuPm
         3gzlMU10bzOgyXoS5V7SRb3z3KWjB/js80euZ6xw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikola Cornij <nikola.cornij@amd.com>,
        Nevenko Stupar <Nevenko.Stupar@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 09/87] drm/amd/display: Power-gate all DSCs at driver init time
Date:   Tue, 24 Sep 2019 12:40:25 -0400
Message-Id: <20190924164144.25591-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 75c35000235f3662f2810e9a59b0c8eed045432e ]

[why]
DSC should be powered-on only on as-needed basis, i.e. if the mode
requires it

[how]
Loop over all the DSCs at driver init time and power-gate each

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index d810c8940129b..2627e0a98a96a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -585,6 +585,10 @@ static void dcn20_init_hw(struct dc *dc)
 		}
 	}
 
+	/* Power gate DSCs */
+	for (i = 0; i < res_pool->res_cap->num_dsc; i++)
+		dcn20_dsc_pg_control(hws, res_pool->dscs[i]->inst, false);
+
 	/* Blank pixel data with OPP DPG */
 	for (i = 0; i < dc->res_pool->timing_generator_count; i++) {
 		struct timing_generator *tg = dc->res_pool->timing_generators[i];
-- 
2.20.1

