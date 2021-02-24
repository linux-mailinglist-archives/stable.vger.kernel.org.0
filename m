Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A57323D39
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhBXNGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232954AbhBXNAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:00:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C537164F4B;
        Wed, 24 Feb 2021 12:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171175;
        bh=gftKk1v/Nzl6DahF5lzpD5Z+bu6E7udThqN4RYyJWys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6tZivyMKNFOPBsITOg46PnsVz79FjVNh0HtLTnuL7nsHBqVGe+bys2j55CBxPmxb
         IR7NANkD6KcJ1bEFOdOgLXdOwspAt1ylZfX1WIkA2BtAnJpKuVcxLsXowMv42Lc2mU
         UzjxQu2+rsj+nkdKKe1nkHS78SesI189OlIK1irvQNhkbwM9urNHzUXKSgss+3eeQw
         MTZmFhZsMK6m9xsqQ3/BVK75mfRW2mri7OLYJJxhuI0q1+uzNYN6NfnFiGTMSDUr6+
         6b0hdXF+sylj1LRuM//diwmlHdLaPlaZSbWzsQ49mw/9I0d+EDWuQ3z+PMfzVP63+E
         8BvIsuWFv2Abw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/56] media: uvcvideo: Allow entities with no pads
Date:   Wed, 24 Feb 2021 07:51:48 -0500
Message-Id: <20210224125212.482485-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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

