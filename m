Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE2404DED
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhIIMHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243054AbhIIMDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5374961246;
        Thu,  9 Sep 2021 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188008;
        bh=XcIrP2j1CH1GVKuWS9cRF+bNGRLvYg1YpeIgxHSn9J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPWtj0LgliQCEn8jdkp30/Qi8zQFDLD+i9krcbVEEF/3HfmFlqmiQnv7DNnEQpUgk
         id8hwfn2q99aXN+HYALziz/jNsL5/877fSjYVEB0vtpKB2IdRszEblt/RJcL69lGbv
         iQnT1a24adv//S5FbZ4C4vXkjRHLqHF5ZuowUMGQc+439H9BBksWB8mpFyGeUyyHUS
         wpbBDwLZTqz69yHxDnd2tdhHduUywA7MOl4ucE5u6jRO6qkZk+N1+MDPuLIOuJlji6
         MO44CG5sphPFYL4vrPfNTiRmMUiVg0jxrDjFWamoqhMPFFan3KAn7X/AAE1PzbkeIg
         vIBAdrsOC8A2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 009/219] media: ti-vpe: cal: fix error handling in cal_camerarx_create
Date:   Thu,  9 Sep 2021 07:43:05 -0400
Message-Id: <20210909114635.143983-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 918d6d120a60c2640263396308eeb2b6afeb0cd6 ]

cal_camerarx_create() doesn't handle error returned from
cal_camerarx_sd_init_cfg(). Fix this.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/cal-camerarx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/cal-camerarx.c b/drivers/media/platform/ti-vpe/cal-camerarx.c
index cbe6114908de..63d13bcc83b4 100644
--- a/drivers/media/platform/ti-vpe/cal-camerarx.c
+++ b/drivers/media/platform/ti-vpe/cal-camerarx.c
@@ -842,7 +842,9 @@ struct cal_camerarx *cal_camerarx_create(struct cal_dev *cal,
 	if (ret)
 		goto error;
 
-	cal_camerarx_sd_init_cfg(sd, NULL);
+	ret = cal_camerarx_sd_init_cfg(sd, NULL);
+	if (ret)
+		goto error;
 
 	ret = v4l2_device_register_subdev(&cal->v4l2_dev, sd);
 	if (ret)
-- 
2.30.2

