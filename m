Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21B3323DEC
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbhBXNUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhBXNLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:11:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A69164E6F;
        Wed, 24 Feb 2021 12:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171329;
        bh=JLdY6mO9wFBXvwUwH0t05F3l6gYMmG/wKxRG6/umEsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpudaQLhneGaNDMWs0AT6p7fpuOC8CSxq7gAcqtFLCZLs8msTLm57Y7ajKdw1Crl2
         /j8F1NitF2reKoUj1Y1DyWiOxfh9cbJk/hG9xoW+9pnpw/eVC5FCOlo+nnbdY5OYLF
         1Bs41CsaXTrbi5OSlLFVK/48CvvjFX51zdC3Ym0JqIHbdBlhaPLgtCZMNqgdcZvKpi
         f6BH/7JV3Bb+ej3mMFVFMHPAsMvyEQnFy1ElNT4LevUGrIhS6GeOGrrVtmsxKlUinq
         lh1+W8/pmt2nApZUI9BZ0vsKRX/+ZoomA8dCj+jPB2O4YL35eqGo9vVWdQM83vHB4L
         1oYnYV8AaFPwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/16] media: uvcvideo: Allow entities with no pads
Date:   Wed, 24 Feb 2021 07:55:08 -0500
Message-Id: <20210224125514.483935-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
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
index 5899593dabaf6..aaaee039fb30c 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -904,7 +904,10 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
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
@@ -920,7 +923,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 
 	for (i = 0; i < num_inputs; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
-	if (!UVC_ENTITY_IS_OTERM(entity))
+	if (!UVC_ENTITY_IS_OTERM(entity) && num_pads)
 		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
 
 	entity->bNrInPins = num_inputs;
-- 
2.27.0

