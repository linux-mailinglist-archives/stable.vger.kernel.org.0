Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657C620132C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392994AbgFSP6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404209AbgFSPTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8D9E206DB;
        Fri, 19 Jun 2020 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579979;
        bh=3YAXEK4s/GPg8WqzWmTln3TcNkCmuYxwrw8nQ+1yss8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FCsCzLyLQOVZRe0Pl0ic9nc3oaAtsl770fvdBVBTRa9X0J1NOBrUckLVjIYJuR60
         n/tD1CH1ZCm9j3Pb+KBJVontlRz8kro/x1zHXJ3Aylikh8hCaBpDMQcv8UKGYvRDqN
         pcOpUdz8ySNszKDhHS53wqNWg3lmcEylwX06j0T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 049/376] media: i2c: imx219: Fix a bug in imx219_enum_frame_size
Date:   Fri, 19 Jun 2020 16:29:27 +0200
Message-Id: <20200619141712.675319974@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit b2bbf1aac61186ef904fd28079e847d3feadb89e ]

When enumerating the frame sizes, the value sent to
imx219_get_format_code should be fse->code
(the code from the ioctl) and not imx219->fmt.code
which is the code set currently in the driver.

Fixes: 22da1d56e982 ("media: i2c: imx219: Add support for RAW8 bit bayer format")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index cb03bdec1f9c..86e0564bfb4f 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -781,7 +781,7 @@ static int imx219_enum_frame_size(struct v4l2_subdev *sd,
 	if (fse->index >= ARRAY_SIZE(supported_modes))
 		return -EINVAL;
 
-	if (fse->code != imx219_get_format_code(imx219, imx219->fmt.code))
+	if (fse->code != imx219_get_format_code(imx219, fse->code))
 		return -EINVAL;
 
 	fse->min_width = supported_modes[fse->index].width;
-- 
2.25.1



