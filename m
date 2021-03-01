Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB0B328DB8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240989AbhCATQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239556AbhCATKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:10:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D87F365198;
        Mon,  1 Mar 2021 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618680;
        bh=Xdp7RkbAmR5eSRDTFJg/JPFqPfFBtL/+DLixpAY9Mpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDdJ5UTBm/BSzpuZv7CTPI6acKvr5D7erU2v+8viXa5noKMSZNiYEAwxl5sfLHFNJ
         qCa5lAPGbFbnFOVZW0MVTmRBh8SeT8xPw0Xa7HbnrZa14JG3CbYKlrItPv8iAwegZc
         9sFz7QSqpjYiL7ywyI0mBa0+V/e/P3UuqGVnByJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/663] media: ti-vpe: cal: fix write to unallocated memory
Date:   Mon,  1 Mar 2021 17:07:06 +0100
Message-Id: <20210301161150.593841931@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 5a402af5e19f215689e8bf3cc244c21d94eba3c4 ]

The asd allocated with v4l2_async_notifier_add_fwnode_subdev() must be
of size cal_v4l2_async_subdev, otherwise access to
cal_v4l2_async_subdev->phy will go to unallocated memory.

Fixes: 8fcb7576ad19 ("media: ti-vpe: cal: Allow multiple contexts per subdev notifier")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/cal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 59a0266b1f399..2eef245c31a17 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -406,7 +406,7 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
  */
 
 struct cal_v4l2_async_subdev {
-	struct v4l2_async_subdev asd;
+	struct v4l2_async_subdev asd; /* Must be first */
 	struct cal_camerarx *phy;
 };
 
@@ -472,7 +472,7 @@ static int cal_async_notifier_register(struct cal_dev *cal)
 		fwnode = of_fwnode_handle(phy->sensor_node);
 		asd = v4l2_async_notifier_add_fwnode_subdev(&cal->notifier,
 							    fwnode,
-							    sizeof(*asd));
+							    sizeof(*casd));
 		if (IS_ERR(asd)) {
 			phy_err(phy, "Failed to add subdev to notifier\n");
 			ret = PTR_ERR(asd);
-- 
2.27.0



