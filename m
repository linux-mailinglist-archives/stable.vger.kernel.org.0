Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED8612C788
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbfL2Rna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730484AbfL2Rn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55B02206A4;
        Sun, 29 Dec 2019 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641408;
        bh=vhuP7OMP4iiJ6M6gVjJF7OPbuLtw1t3tCsxa6xcODGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWhRRpPEPRhtMWP7yyz0Ivbwy0wu0EIc5+dgrdz8olfpkD8HmdxuQQfI0lhUZzzF7
         77nABhA+CYP0Lff9w1hPzjp+06mBPfyx3UH1y3PhrBEUBmqpn5mp1BPVFvVJrYNZix
         oZkr7tEr51SpZIdqahxIHic6C5TZ+BEfx4Lk3iUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehyun Chung <jaehyun.chung@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/434] drm/amd/display: OTC underflow fix
Date:   Sun, 29 Dec 2019 18:21:45 +0100
Message-Id: <20191229172705.382904435@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehyun Chung <jaehyun.chung@amd.com>

[ Upstream commit 785908cf19c9eb4803f6bf9c0a7447dc3661d5c3 ]

[Why] Underflow occurs on some display setups(repro'd on 3x4K HDR) on boot,
mode set, and hot-plugs with. Underflow occurs because mem clk
is not set high after disabling pstate switching. This behaviour occurs
because some calculations assumed displays were synchronized.

[How] Add a condition to check if timing sync is disabled so that
synchronized vblank can be set to false.

Signed-off-by: Jaehyun Chung <jaehyun.chung@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 6b2f2f1a1c9c..3980c7b78259 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1765,7 +1765,7 @@ int dcn20_populate_dml_pipes_from_context(
 			pipe_cnt = i;
 			continue;
 		}
-		if (!resource_are_streams_timing_synchronizable(
+		if (dc->debug.disable_timing_sync || !resource_are_streams_timing_synchronizable(
 				res_ctx->pipe_ctx[pipe_cnt].stream,
 				res_ctx->pipe_ctx[i].stream)) {
 			synchronized_vblank = false;
-- 
2.20.1



