Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659EE1330FC
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgAGU4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbgAGU4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84EF220880;
        Tue,  7 Jan 2020 20:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430599;
        bh=FeMBBwF0CZhj+G8NDFZ4UpsqfiA3Hos10a4ep0BUI+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTgZoeSMS58O3+vJlfus1hjoCKPTLb00J04AyvnuzIP5018P9pMfaMIiLlzukzK0P
         qY2Kj5d5y4JWlPtl54/GaGAYNxDzqwd2iVvBD4YSJ4mlYpTDJ5XZzLjd9cBdjGZLJR
         MmCxINPd3pMzebVcjTzi2MYOGmM/LDwddwrtM3CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Nikola Cornij <Nikola.Cornij@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/191] drm/amd/display: Change the delay time before enabling FEC
Date:   Tue,  7 Jan 2020 21:52:09 +0100
Message-Id: <20200107205333.507167091@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo (Hanghong) Ma <hanghong.ma@amd.com>

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
index 5a583707d198..0ab890c927ec 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3492,7 +3492,14 @@ void dp_set_fec_enable(struct dc_link *link, bool enable)
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



