Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8374405475
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355476AbhIIM6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356640AbhIIMze (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C2D63257;
        Thu,  9 Sep 2021 11:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188695;
        bh=Z9sSP17i27mBeCEXH6PRF33vDzI8TkxhnJ+k46c0IV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZU39iB/YaHoXTOVLNgLSlD90GwhoB9FN9dclPwr6icMbPKTdwqa3CRxS115cK7cGF
         o33mEdyZqX4wQiX27L6IFuCIiFaV/LTyX2AumILSTL/GKwE4EPspwNGTeKVkgTx/Jr
         0auc3N3RvjAtqVZxER/s1Xgyh0shPNVuenyUW+J/qj8WKupJ46MNFGHZg+TRgnM2LN
         UEdUF06Yil1DSq0266ffShPbU8eaVIuXbL9EUeqIBuRLAAPx07Gu9seqCmbZDPwpSV
         WmS4wVPLjOogfp55NRHy5kTbtiyZ8WB9I3gwrnVuPyzp21xwWUvEJHJHPiUEejrmHG
         oNNJhj50uVk3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/74] media: TDA1997x: fix tda1997x_query_dv_timings() return value
Date:   Thu,  9 Sep 2021 07:56:51 -0400
Message-Id: <20210909115726.149004-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Hałasa <khalasa@piap.pl>

[ Upstream commit 7dee1030871a48d4f3c5a74227a4b4188463479a ]

Correctly propagate the tda1997x_detect_std error value.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tda1997x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index d114ac5243ec..c227fed975a9 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -1695,14 +1695,15 @@ static int tda1997x_query_dv_timings(struct v4l2_subdev *sd,
 				     struct v4l2_dv_timings *timings)
 {
 	struct tda1997x_state *state = to_state(sd);
+	int ret;
 
 	v4l_dbg(1, debug, state->client, "%s\n", __func__);
 	memset(timings, 0, sizeof(struct v4l2_dv_timings));
 	mutex_lock(&state->lock);
-	tda1997x_detect_std(state, timings);
+	ret = tda1997x_detect_std(state, timings);
 	mutex_unlock(&state->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct v4l2_subdev_video_ops tda1997x_video_ops = {
-- 
2.30.2

