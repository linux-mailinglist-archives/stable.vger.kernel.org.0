Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C62413E701
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390685AbgAPRNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390729AbgAPRNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549B3246AA;
        Thu, 16 Jan 2020 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194801;
        bh=ayTV0SyUH0e2bABLL/2P8fDxp82lebQiM6N7Y8tD5Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bngEY89dxoMr+tvTWdHEw0wrmfHx4zVUc0R6g0fgSpLaGNbdOIDsGuEmIBRX3qcvW
         f92MfDRxSzpe+9XzIpEJYXP1x8rSBZwQaa7zpQUo/UVm8gcX3EQNyEzZjkOZEGJmNJ
         /BTNu54RIf/wC7w8h8LuXzkzmEu9RUvdZrOQynbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 612/671] media: rcar-vin: Fix incorrect return statement in rvin_try_format()
Date:   Thu, 16 Jan 2020 12:04:10 -0500
Message-Id: <20200116170509.12787-349-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit a0862a40364e2f87109317e31c51c9d7bc89e33f ]

While refactoring code the return statement became corrupted, fix it by
returning the correct return code.

Reported-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Fixes: 897e371389e77514 ("media: rcar-vin: simplify how formats are set and reset"
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 5a54779cfc27..1236e6e8228c 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -196,6 +196,7 @@ static int rvin_try_format(struct rvin_dev *vin, u32 which,
 	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		goto done;
+	ret = 0;
 
 	v4l2_fill_pix_format(pix, &format.format);
 
@@ -230,7 +231,7 @@ static int rvin_try_format(struct rvin_dev *vin, u32 which,
 done:
 	v4l2_subdev_free_pad_config(pad_cfg);
 
-	return 0;
+	return ret;
 }
 
 static int rvin_querycap(struct file *file, void *priv,
-- 
2.20.1

