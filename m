Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA5E147D52
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388353AbgAXJ73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387655AbgAXJ73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:59:29 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B687420709;
        Fri, 24 Jan 2020 09:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859968;
        bh=Obif+UBlBSM9oYuWYrkmAST6OuNiL8o9oR3skCw6FHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ3N0KAao9CHGTj9CELGCwEAoeFT7D9n7eAWwJ8mKVjPIKCdxCqvIBIgOCGMRly9S
         jySmnmFtOU8rKF3TMEBy8FJY1AVY2xihUqI+1QmBByp4BX9u992thl2SQltGwLRvuO
         LHyYyTGepU1uqhZLNQ18IWv/xD7qHrBISD4CYYQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 230/343] media: vivid: fix incorrect assignment operation when setting video mode
Date:   Fri, 24 Jan 2020 10:30:48 +0100
Message-Id: <20200124092950.406283595@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit d4ec9550e4b2d2e357a46fdc65d8ef3d4d15984c ]

The assigment of FB_VMODE_NONINTERLACE to var->vmode should be a
bit-wise or of FB_VMODE_NONINTERLACE instead of an assignment,
otherwise the previous clearing of the FB_VMODE_MASK bits of
var->vmode makes no sense and is redundant.

Addresses-Coverity: ("Unused value")
Fixes: ad4e02d5081d ("[media] vivid: add a simple framebuffer device for overlay testing")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-osd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-osd.c b/drivers/media/platform/vivid/vivid-osd.c
index bdc380b14e0c4..a95b7c56569e3 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -167,7 +167,7 @@ static int _vivid_fb_check_var(struct fb_var_screeninfo *var, struct vivid_dev *
 	var->nonstd = 0;
 
 	var->vmode &= ~FB_VMODE_MASK;
-	var->vmode = FB_VMODE_NONINTERLACED;
+	var->vmode |= FB_VMODE_NONINTERLACED;
 
 	/* Dummy values */
 	var->hsync_len = 24;
-- 
2.20.1



