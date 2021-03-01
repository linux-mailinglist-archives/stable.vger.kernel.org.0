Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37448328666
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhCARJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236542AbhCARDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BFC164F57;
        Mon,  1 Mar 2021 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616744;
        bh=mnDo72+ePxEKb50JijZpx/O4nzijQnw2sOxbbWuVGbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF5RQKMzsqgn80n0pVeJcd9baqLwAv8X03pH4kpMx8MW/13zo80l5AQn8RZDQSF4y
         /44Dfqbz91zRWvtvBB0wHJcpWGBajPQNfQC75legvUYhW+WoEOyn5zEtXJ6RviZSWi
         Kr/kyxG5iyQkeNOt8PlUiH7Jq7VwO9iS2LXznqHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/247] media: i2c: ov5670: Fix PIXEL_RATE minimum value
Date:   Mon,  1 Mar 2021 17:11:40 +0100
Message-Id: <20210301161035.602663841@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo@jmondi.org>

[ Upstream commit dc1eb7c9c290cba52937c9a224b22a400bb0ffd7 ]

The driver currently reports a single supported value for
V4L2_CID_PIXEL_RATE and initializes the control's minimum value to 0,
which is very risky, as userspace might accidentally use it as divider
when calculating the time duration of a line.

Fix this by using as minimum the only supported value when registering
the control.

Fixes: 5de35c9b8dcd1 ("media: i2c: Add Omnivision OV5670 5M sensor support")
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5670.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 53dd30d96e691..62dfdcb6e0bd6 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2081,7 +2081,8 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 
 	/* By default, V4L2_CID_PIXEL_RATE is read only */
 	ov5670->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov5670_ctrl_ops,
-					       V4L2_CID_PIXEL_RATE, 0,
+					       V4L2_CID_PIXEL_RATE,
+					       link_freq_configs[0].pixel_rate,
 					       link_freq_configs[0].pixel_rate,
 					       1,
 					       link_freq_configs[0].pixel_rate);
-- 
2.27.0



