Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C068C127E3F
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfLTOjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfLTOaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 937D1206CB;
        Fri, 20 Dec 2019 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852207;
        bh=0uH/IchrsHYxfzfwr7jz2PTjjfJWnG8AXFV5wuLtNGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWD1vKuM/auhj8N5AHyuqkU0ymiwfQJJTljACht9louP2GJIUdj1/nicM3ebdnjiJ
         S1K9T2i0BPFqS8d5/VbNOhmedYO6GBjWswhv5uKVVIZ1LcgYcQR3VCTTRgUIvXF9XP
         xsxDkIbnOB1zjMI9Zbvdl4b8j8oKMKB6IC8IqRF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Nikola Cornij <Nikola.Cornij@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 09/52] drm/amd/display: Change the delay time before enabling FEC
Date:   Fri, 20 Dec 2019 09:29:11 -0500
Message-Id: <20191220142954.9500-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Leo (Hanghong) Ma" <hanghong.ma@amd.com>

[ Upstream commit 28fa24ad14e8f7d23c62283eaf9c79b4fd165c16 ]

[why]
DP spec requires 1000 symbols delay between the end of link training
and enabling FEC in the stream. Currently we are using 1 miliseconds
delay which is not accurate.

[how]
One lane RBR should have the maximum time for transmitting 1000 LL
codes which is 6.173 us. So using 7 microseconds delay instead of
1 miliseconds.

Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Reviewed-by: Nikola Cornij <Nikola.Cornij@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index f5742719b5d9b..b6e68e9c81d11 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3490,7 +3490,14 @@ void dp_set_fec_enable(struct dc_link *link, bool enable)
 	if (link_enc->funcs->fec_set_enable &&
 			link->dpcd_caps.fec_cap.bits.FEC_CAPABLE) {
 		if (link->fec_state == dc_link_fec_ready && enable) {
-			msleep(1);
+			/* Accord to DP spec, FEC enable sequence can first
+			 * be transmitted anytime after 1000 LL codes have
+			 * been transmitted on the link after link training
+			 * completion. Using 1 lane RBR should have the maximum
+			 * time for transmitting 1000 LL codes which is 6.173 us.
+			 * So use 7 microseconds delay instead.
+			 */
+			udelay(7);
 			link_enc->funcs->fec_set_enable(link_enc, true);
 			link->fec_state = dc_link_fec_enabled;
 		} else if (link->fec_state == dc_link_fec_enabled && !enable) {
-- 
2.20.1

