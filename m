Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68EC323E21
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhBXNZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236139AbhBXNOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414E564FB1;
        Wed, 24 Feb 2021 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171354;
        bh=/N/4xehBqJRcJQkTrxkQLd8I8UzldUf3l8vEzIEIYzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b89TCFVoV+vdAVrMV05jyBJz3g2WVWEjNCZp8UEsWxo/vnxKvK/b/RrZpRJrevRtt
         JkjncAomrf/5Mg+aEDskyv+98ylAdPAwS/t251R9k0q8H4QHZ3Vf+lm1WdnhJPQRoU
         gaNL6DOOkU7TfCpTckS9mKdHxf610yorPQ8MxqD6lkdbxfu5aUadMLFffx3DwUHBSP
         HqxWc7AHAJPzUT6z+YBbNVuEYUpZS+kIK+ooDAp9CJ3+x1fhlSyWM3HFagsxBucD/h
         WrCsFi/1jn3Ui039El4YWryAU2RL41jha6Sy+Hnp7MfZSYfnETGBBo3lnOfgwKWiOo
         0MDC22aJRDxjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/12] media: uvcvideo: Allow entities with no pads
Date:   Wed, 24 Feb 2021 07:55:38 -0500
Message-Id: <20210224125540.484221-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125540.484221-1-sashal@kernel.org>
References: <20210224125540.484221-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 7532dad6634031d083df7af606fac655b8d08b5c ]

Avoid an underflow while calculating the number of inputs for entities
with zero pads.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 9803135f2e593..96e9c25926e17 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -869,7 +869,10 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 	unsigned int i;
 
 	extra_size = roundup(extra_size, sizeof(*entity->pads));
-	num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
+	if (num_pads)
+		num_inputs = type & UVC_TERM_OUTPUT ? num_pads : num_pads - 1;
+	else
+		num_inputs = 0;
 	size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
 	     + num_inputs;
 	entity = kzalloc(size, GFP_KERNEL);
@@ -885,7 +888,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 
 	for (i = 0; i < num_inputs; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
-	if (!UVC_ENTITY_IS_OTERM(entity))
+	if (!UVC_ENTITY_IS_OTERM(entity) && num_pads)
 		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
 
 	entity->bNrInPins = num_inputs;
-- 
2.27.0

