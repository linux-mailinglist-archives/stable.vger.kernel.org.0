Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AFABA920
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390921AbfIVTLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405384AbfIVS6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:58:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C69A5214D9;
        Sun, 22 Sep 2019 18:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178704;
        bh=e0OsJVXdRup6T509mAuK/fbZ1RieDXJfxSYWGYLNNhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=demiMWVPDGRTmIK+BV/5+F9+utXXhko6Zs811kmTnZT8U8EU0ic69E9Vt/p58E62v
         imD7BjlHzElxS7lZFC0D3wXEanRq+eIPFeV+06YX/eCnjJMt2N/ohCOVd1gEHs7Azl
         jchGCDgEf5rspWlf48iayAoQIMMPNLuYGWfijEL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 41/89] media: omap3isp: Don't set streaming state on random subdevs
Date:   Sun, 22 Sep 2019 14:56:29 -0400
Message-Id: <20190922185717.3412-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 7ef57be07ac146e70535747797ef4aee0f06e9f9 ]

The streaming state should be set to the first upstream sub-device only,
not everywhere, for a sub-device driver itself knows how to best control
the streaming state of its own upstream sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index c834fea5f9b00..b34b6a604f92f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -727,6 +727,10 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 					s_stream, mode);
 			pipe->do_propagation = true;
 		}
+
+		/* Stop at the first external sub-device. */
+		if (subdev->dev != isp->dev)
+			break;
 	}
 
 	return 0;
@@ -841,6 +845,10 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 						      &subdev->entity);
 			failure = -ETIMEDOUT;
 		}
+
+		/* Stop at the first external sub-device. */
+		if (subdev->dev != isp->dev)
+			break;
 	}
 
 	return failure;
-- 
2.20.1

