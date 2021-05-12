Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643C837CD5D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhELQyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243811AbhELQmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A9261C37;
        Wed, 12 May 2021 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835636;
        bh=EkWio/zdcoWzXWelAZxlqo34TaE3Rt3gEfgyM6y4FHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNc58E09p03lqatVxTPoZCKOpWcxKRgp9yrrb/NEn2zt9yfG2TFcuU3j5Rvx0Y86w
         A2ChsQZL8/7K4dMbrFGZuljiIjzLWYFdRVNxV3t6ztY8l+c3z+6tmh4gXfwPhyY26u
         nLoIDO7EpFxb7jWP1fFYrEMlBD9vt427tV2bn8dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 425/677] media: meson-ge2d: fix rotation parameters
Date:   Wed, 12 May 2021 16:47:51 +0200
Message-Id: <20210512144851.465122671@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 87e780db2253a1759822c2c9ea207135fcc059de ]

With these settings, 90deg and 270deg rotation leads to inverted
vertical, fix them to have correct rotation.

Fixes: 59a635327ca7 ("media: meson: Add M2M driver for the Amlogic GE2D Accelerator Unit")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/meson/ge2d/ge2d.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/meson/ge2d/ge2d.c b/drivers/media/platform/meson/ge2d/ge2d.c
index 153612ca96fc..a1393fefa8ae 100644
--- a/drivers/media/platform/meson/ge2d/ge2d.c
+++ b/drivers/media/platform/meson/ge2d/ge2d.c
@@ -757,7 +757,7 @@ static int ge2d_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		if (ctrl->val == 90) {
 			ctx->hflip = 0;
-			ctx->vflip = 0;
+			ctx->vflip = 1;
 			ctx->xy_swap = 1;
 		} else if (ctrl->val == 180) {
 			ctx->hflip = 1;
@@ -765,7 +765,7 @@ static int ge2d_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctx->xy_swap = 0;
 		} else if (ctrl->val == 270) {
 			ctx->hflip = 1;
-			ctx->vflip = 1;
+			ctx->vflip = 0;
 			ctx->xy_swap = 1;
 		} else {
 			ctx->hflip = 0;
-- 
2.30.2



