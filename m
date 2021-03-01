Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33BD328E2A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhCATZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235778AbhCATSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FAFC6531A;
        Mon,  1 Mar 2021 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620605;
        bh=Xdp7RkbAmR5eSRDTFJg/JPFqPfFBtL/+DLixpAY9Mpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpnuMZyh834Be0duE0uG9Ra4e/ML0XMGcPtutSm1/6AkrN/iSdM43ihOFptqM6wbz
         OKxUXqsdtwv8nVVXUPPgpOkRFdu4r1YsyVnmUNkVswydtjDCxGEPKaHLKS2hkUUmGz
         RyyNZ97It0IdA+nsLx73hAXeE9ZaeJWd2J7LXW/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 214/775] media: ti-vpe: cal: fix write to unallocated memory
Date:   Mon,  1 Mar 2021 17:06:22 +0100
Message-Id: <20210301161212.198862532@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



