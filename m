Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF05119C2D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLJWNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbfLJWDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C222077B;
        Tue, 10 Dec 2019 22:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015397;
        bh=Xn7iAqfoCsLox+/IrFYxLetscd1uILTzaw9+3bfwoRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IumcMHuxSxqcTdhDrxUABItso3MjaeFPC3999aS/M0bgqDRDzA33Ze75qfByzaR/X
         hkKxLViQ/oHGx/Cg21lsr87ZpzpRaXwVMMJpADwyE48E87rO56y3ct9N6rnHDRBopU
         RFvjnB/agWwW9bYt2Mb3MhiWllmPJPnrG56x9wwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 013/130] media: i2c: ov2659: fix s_stream return value
Date:   Tue, 10 Dec 2019 17:01:04 -0500
Message-Id: <20191210220301.13262-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit 85c4043f1d403c222d481dfc91846227d66663fb ]

In ov2659_s_stream() return value for invoked function should be checked
and propagated.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2659.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index ce23f436e130d..04d493aea45eb 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1203,11 +1203,15 @@ static int ov2659_s_stream(struct v4l2_subdev *sd, int on)
 		goto unlock;
 	}
 
-	ov2659_set_pixel_clock(ov2659);
-	ov2659_set_frame_size(ov2659);
-	ov2659_set_format(ov2659);
-	ov2659_set_streaming(ov2659, 1);
-	ov2659->streaming = on;
+	ret = ov2659_set_pixel_clock(ov2659);
+	if (!ret)
+		ret = ov2659_set_frame_size(ov2659);
+	if (!ret)
+		ret = ov2659_set_format(ov2659);
+	if (!ret) {
+		ov2659_set_streaming(ov2659, 1);
+		ov2659->streaming = on;
+	}
 
 unlock:
 	mutex_unlock(&ov2659->lock);
-- 
2.20.1

