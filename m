Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844FAF6386
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfKJCvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbfKJCvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52585227C3;
        Sun, 10 Nov 2019 02:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354283;
        bh=p/RmlmT67lAOqkWvbQoRuTpPBUPePImcyuLhOl2dT7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrR6MvKv43u1p10I2UZcKBMJXCNLprXiegfieOb6rFK5HHF1S0RiJA9kK2lquqzIP
         YYdS4gCIDO5635ONfHupdbtj+Zk5alER1WuoySC3XiktewXAikpV03U2YUpyuOkdzS
         iPRuap8ttcDyWtvNMy8SyzUro1rI4EvoCQAUBTw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.4 25/40] media: davinci: Fix implicit enum conversion warning
Date:   Sat,  9 Nov 2019 21:50:17 -0500
Message-Id: <20191110025032.827-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 4158757395b300b6eb308fc20b96d1d231484413 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/media/platform/davinci/vpbe_display.c:524:24: warning: implicit
conversion from enumeration type 'enum osd_v_exp_ratio' to different
enumeration type 'enum osd_h_exp_ratio' [-Wenum-conversion]
                        layer_info->h_exp = V_EXP_6_OVER_5;
                                          ~ ^~~~~~~~~~~~~~
1 warning generated.

This appears to be a copy and paste error judging from the couple of
lines directly above this statement and the way that height is handled
in the if block above this one.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpbe_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6d91422c4e4c7..a9cd8c7a7b347 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -520,7 +520,7 @@ vpbe_disp_calculate_scale_factor(struct vpbe_display *disp_dev,
 		else if (v_scale == 4)
 			layer_info->v_zoom = ZOOM_X4;
 		if (v_exp)
-			layer_info->h_exp = V_EXP_6_OVER_5;
+			layer_info->v_exp = V_EXP_6_OVER_5;
 	} else {
 		/* no scaling, only cropping. Set display area to crop area */
 		cfg->ysize = expected_ysize;
-- 
2.20.1

