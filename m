Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6621D40E753
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347319AbhIPRbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352834AbhIPR25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0E161BFA;
        Thu, 16 Sep 2021 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810765;
        bh=5q32yhkAPNYcJ0/bDJ0z9LkFtm4G9muoIUDrfS6+4sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiOUxoRKPzoF2sa1p0dpjt7DY1yTInH74YFr7o/sfsyu09hdNbmgUAb7ObDuad69Z
         RCilctc9cerH5E9uyMyhpH/AOKS6WWR5JO1t4ZXMWGlLCbwVwKZAn1KCUED+yzQ7Qp
         +q+vL2IC8SKtCbse7/reqUyT29W9KJt0r2LnbMbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 259/432] media: TDA1997x: fix tda1997x_query_dv_timings() return value
Date:   Thu, 16 Sep 2021 18:00:08 +0200
Message-Id: <20210916155819.604868633@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3a191e257fad..ef726faee2a4 100644
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



