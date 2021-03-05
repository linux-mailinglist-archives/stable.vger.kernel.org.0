Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC18932EA7F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhCEMit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233072AbhCEMig (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:38:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA17564FF0;
        Fri,  5 Mar 2021 12:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947916;
        bh=HyXNKzlEerydnVeJ0HfUOD7a5QP60KoqNzEpC574pPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HS9rSJTmnX7cKKJ/UkAQWSuTkPaBPFtA3a4Ls8rhCRwgMTO906PHbP7pE9dGT8+0c
         X57ifMEoR10OMDDEEjBDdhYJelbQPC/33vlyywGxElEzvPHa+FpxEVRVsJX6KyFKHN
         WXmTcSUCRj7z8gbGygUOLjRjsDTW45ivswX7ylFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/52] media: uvcvideo: Allow entities with no pads
Date:   Fri,  5 Mar 2021 13:22:05 +0100
Message-Id: <20210305120855.341940501@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 38c73cdbef70..998ce712978a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -940,7 +940,10 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
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
@@ -956,7 +959,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 
 	for (i = 0; i < num_inputs; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
-	if (!UVC_ENTITY_IS_OTERM(entity))
+	if (!UVC_ENTITY_IS_OTERM(entity) && num_pads)
 		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
 
 	entity->bNrInPins = num_inputs;
-- 
2.30.1



