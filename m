Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B643451099
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243093AbhKOSuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242946AbhKOSsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 387B763395;
        Mon, 15 Nov 2021 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999664;
        bh=gk9i/QMV6qjMsowELFGQHJlWlPx2evps556UGxorL5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmiYLE/m9Ih3ZQs+6AHSE2p9OWyPpSdGLXMdwnXvDzM/u2cZnCMB1n8R6vbq5BDSt
         +B9F7E9SSQp4BUn5GbI7l9dLTHCh40BTQX8iKo0p9lZqTmMxuXOC7kqipjVC0bzU4m
         HHpwcvuT7rkqJTo9cpLdrykk9sS1MiVSb943pqno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 379/849] media: meson-ge2d: Fix rotation parameter changes detection in ge2d_s_ctrl()
Date:   Mon, 15 Nov 2021 17:57:42 +0100
Message-Id: <20211115165433.069177393@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4b9e3e8af4b336eefca1f1ee535bc4b6734ed6aa ]

There is likely a typo here. To be consistent, we should compare
'fmt.height' with 'ctx->out.pix_fmt.height', not 'ctx->out.pix_fmt.width'.

Instead of fixing the test, just remove it and copy 'fmt' unconditionally.

Fixes: 59a635327ca7 ("media: meson: Add M2M driver for the Amlogic GE2D Accelerator Unit")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/meson/ge2d/ge2d.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/meson/ge2d/ge2d.c b/drivers/media/platform/meson/ge2d/ge2d.c
index a1393fefa8aea..9b1e973e78da3 100644
--- a/drivers/media/platform/meson/ge2d/ge2d.c
+++ b/drivers/media/platform/meson/ge2d/ge2d.c
@@ -779,11 +779,7 @@ static int ge2d_s_ctrl(struct v4l2_ctrl *ctrl)
 		 * If the rotation parameter changes the OUTPUT frames
 		 * parameters, take them in account
 		 */
-		if (fmt.width != ctx->out.pix_fmt.width ||
-		    fmt.height != ctx->out.pix_fmt.width ||
-		    fmt.bytesperline > ctx->out.pix_fmt.bytesperline ||
-		    fmt.sizeimage > ctx->out.pix_fmt.sizeimage)
-			ctx->out.pix_fmt = fmt;
+		ctx->out.pix_fmt = fmt;
 
 		break;
 	}
-- 
2.33.0



