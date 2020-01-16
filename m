Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86913F4EC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392669AbgAPSwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389388AbgAPRIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4300E2467E;
        Thu, 16 Jan 2020 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194501;
        bh=tlmDH8kBdbeHXD70yHSMesbYf928vFPBOSsTluSKbI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyU8WZ5oOfj1m1AWdlTU2JL/lWk60/OYaIAQ/HTgyg1aog5djP0wR6x96fEh7uNRH
         TTCNmgO2qGgUseShl4NOGDTVixFfBDnXWVtDcJDuJ4FhBD5Zvd2K7F6JW4ILXdNtgN
         vzCk2PEg1UYefgxAXAf42RbK+J2p3L9unSVtN3r8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 397/671] media: vivid: fix incorrect assignment operation when setting video mode
Date:   Thu, 16 Jan 2020 12:00:35 -0500
Message-Id: <20200116170509.12787-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bbbc1b6938a5..b24596697f57 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -155,7 +155,7 @@ static int _vivid_fb_check_var(struct fb_var_screeninfo *var, struct vivid_dev *
 	var->nonstd = 0;
 
 	var->vmode &= ~FB_VMODE_MASK;
-	var->vmode = FB_VMODE_NONINTERLACED;
+	var->vmode |= FB_VMODE_NONINTERLACED;
 
 	/* Dummy values */
 	var->hsync_len = 24;
-- 
2.20.1

