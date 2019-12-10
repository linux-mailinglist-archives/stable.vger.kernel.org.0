Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38A1196FB
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfLJVJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbfLJVJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBCD3246AC;
        Tue, 10 Dec 2019 21:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012189;
        bh=p4Ouzi2dQxXDQpMa6jd+uJ+hILDlMBsHNOy9APzS59k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHjbqSKYOiXcnpkoTKKJQU07CPOWVTvQCspubSXECTFO5SYGnDpbUOLfeQMCRq/id
         FvlkODOPlH0IMpD9Kcn14aZJF5BECQ003XT04kr8czD/aOrC+ZnaMvzoObJsxhtLc/
         RbjIDD55rXE2RgrjCscwJBCgLXTVjNxnQ0IJRpYA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 145/350] media: aspeed: set hsync and vsync polarities to normal before starting mode detection
Date:   Tue, 10 Dec 2019 16:04:10 -0500
Message-Id: <20191210210735.9077-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>

[ Upstream commit 5b3f3c41c5c791c1c22cd91655e7ef4b2a1dff7c ]

Sometimes it detects a weird resolution such as 1024x287 when the
actual resolution is 1024x768. To resolve such an issue, this
commit adds clearing for hsync and vsync polarity register bits
at the beginning of the first mode detection. This is recommended
in the datasheet.

Signed-off-by: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index eb12f37930629..84e0650106f51 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -741,6 +741,8 @@ static void aspeed_video_get_resolution(struct aspeed_video *video)
 		}
 
 		set_bit(VIDEO_RES_DETECT, &video->flags);
+		aspeed_video_update(video, VE_CTRL,
+				    VE_CTRL_VSYNC_POL | VE_CTRL_HSYNC_POL, 0);
 		aspeed_video_enable_mode_detect(video);
 
 		rc = wait_event_interruptible_timeout(video->wait,
-- 
2.20.1

