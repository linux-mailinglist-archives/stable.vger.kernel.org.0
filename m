Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D56323CD4
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhBXM4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:56:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhBXMx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:53:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46AB64F1B;
        Wed, 24 Feb 2021 12:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171081;
        bh=gftKk1v/Nzl6DahF5lzpD5Z+bu6E7udThqN4RYyJWys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWDljO6DGPGLsAs969t2qExS4wK+dAPysib2vwKv3+mm240Jw2+wM4BXHg7zrarc4
         h4PfnOU7S77MOyZwIT74J7TE9EIhZUBoy3a6JMgRtPPiPaQbem4ZO6YS3Pq5b7cSza
         c8xCAAz5qWLHciumy/VC64P2t7bARHDTZ/pMAdPDdr8hI853EL6d7fdZim2nM5O0ts
         hOEdeBNQ2cfXMwB4hLZMneLy9YMLHoJ7fejIsi8LRuSe/B5NNJcH5Y7q1y2xyIsEg+
         miHAr1X+ONvFJb+bwc+fgLkIgonJs1asVDLAjA+VTKQCJL+LuaVGhjRffuN417AYTk
         1ZUItz5FcV1cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 40/67] media: uvcvideo: Allow entities with no pads
Date:   Wed, 24 Feb 2021 07:49:58 -0500
Message-Id: <20210224125026.481804-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index ddb9eaa11be71..5ad5282641350 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1028,7 +1028,10 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
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
@@ -1044,7 +1047,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 
 	for (i = 0; i < num_inputs; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
-	if (!UVC_ENTITY_IS_OTERM(entity))
+	if (!UVC_ENTITY_IS_OTERM(entity) && num_pads)
 		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
 
 	entity->bNrInPins = num_inputs;
-- 
2.27.0

