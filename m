Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528DC13F93B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406390AbgAPTXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:23:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730635AbgAPQxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF0721582;
        Thu, 16 Jan 2020 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193582;
        bh=iIeP+WJZUUTPVSaBgeB7+7rh6VBmmZIcQvVjeJlK2xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4i+soLM8eNLM0+ILS7C5k5/Z20tMT4oDDg/SBzfUUFSoVtF0hHxNTE+BJGNSw/7d
         hQ2ktvkzNlezit/cVyxN2rUDUK5n9cQtWBdxOGdGdtCYCHM8hqLCUby8/JeAVTCfwe
         0foSulnEsJOaJ7tP/kHAm9inZtXI1K4QtvB355hk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 124/205] media: aspeed-video: Fix memory leaks in aspeed_video_probe
Date:   Thu, 16 Jan 2020 11:41:39 -0500
Message-Id: <20200116164300.6705-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit c3df30a01da4955e04fa068c503cd784b31dad92 ]

In the implementation of aspeed_video_probe() the allocated memory for
video should be released if either devm_ioremap_resource()
or aspeed_video_init() or aspeed_video_setup_video() fails. Replace
kzalloc() with devm_kzalloc to avoid explicit release for video.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index 096a7c9a8963..4eaaf39b9223 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1658,7 +1658,8 @@ static int aspeed_video_probe(struct platform_device *pdev)
 {
 	int rc;
 	struct resource *res;
-	struct aspeed_video *video = kzalloc(sizeof(*video), GFP_KERNEL);
+	struct aspeed_video *video =
+		devm_kzalloc(&pdev->dev, sizeof(*video), GFP_KERNEL);
 
 	if (!video)
 		return -ENOMEM;
-- 
2.20.1

