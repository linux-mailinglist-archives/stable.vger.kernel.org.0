Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA532A597A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbgKCUlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729934AbgKCUlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A40622226;
        Tue,  3 Nov 2020 20:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436075;
        bh=6D9VE4v3ufIQL1YLkBfnxzjUVIA3Z4NKpkz5j8Xkx+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaFflSmx94z/XW7pyYy6y4Gka/GVXknjTCUSQfag2OXuq0cCuil6oUsBHvtKthZJU
         IZwtGqqBQVYgPq6FZSkYT3sg6tCLwQTk0uodCbKW/I1rv8OFlOOXiP6RDGyCuZMlZV
         UaC40HN/4NrnLdocPdaS9m6tc5TN87c60XWNTve4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 091/391] media: imx274: fix frame interval handling
Date:   Tue,  3 Nov 2020 21:32:22 +0100
Message-Id: <20201103203353.092548309@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 49b20d981d723fae5a93843c617af2b2c23611ec ]

1) the numerator and/or denominator might be 0, in that case
   fall back to the default frame interval. This is per the spec
   and this caused a v4l2-compliance failure.

2) the updated frame interval wasn't returned in the s_frame_interval
   subdev op.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx274.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 6011cec5e351d..e6aa9f32b6a83 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1235,6 +1235,8 @@ static int imx274_s_frame_interval(struct v4l2_subdev *sd,
 	ret = imx274_set_frame_interval(imx274, fi->interval);
 
 	if (!ret) {
+		fi->interval = imx274->frame_interval;
+
 		/*
 		 * exposure time range is decided by frame interval
 		 * need to update it after frame interval changes
@@ -1730,9 +1732,9 @@ static int imx274_set_frame_interval(struct stimx274 *priv,
 		__func__, frame_interval.numerator,
 		frame_interval.denominator);
 
-	if (frame_interval.numerator == 0) {
-		err = -EINVAL;
-		goto fail;
+	if (frame_interval.numerator == 0 || frame_interval.denominator == 0) {
+		frame_interval.denominator = IMX274_DEF_FRAME_RATE;
+		frame_interval.numerator = 1;
 	}
 
 	req_frame_rate = (u32)(frame_interval.denominator
-- 
2.27.0



