Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621653C4811
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhGLGfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237857AbhGLGez (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B7E610FA;
        Mon, 12 Jul 2021 06:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071520;
        bh=JqY4SiH2kiDGdE/b30pk5GzvlmzpdykOaKKs2cllb4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGTIj2TFbJA+C+JeuiQJUD1QNrXhlUU04+fj37rlZwBCf/oQUt+0Du+00yIqiKnNj
         AbdtVVomOjNGGVVQRSkOpisOSivSGv4G5PxzeeMfapbasXfcRzE+xVVj8i8rJ0roxq
         B5d2VFS05LuGJr3ReHETLIKFJfG7uLhoDSJlQIXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/593] media: marvel-ccic: fix some issues when getting pm_runtime
Date:   Mon, 12 Jul 2021 08:04:23 +0200
Message-Id: <20210712060854.546438880@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit e7c617cab7a522fba5b20f9033ee98565b6f3546 ]

Calling pm_runtime_get_sync() is bad, since even when it
returns an error, pm_runtime_put*() should be called.
So, use instead pm_runtime_resume_and_get().

While here, ensure that the error condition will be checked
during clock enable an media open() calls.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 34266fba824f..e56c5e56e824 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -918,6 +918,7 @@ static int mclk_enable(struct clk_hw *hw)
 	struct mcam_camera *cam = container_of(hw, struct mcam_camera, mclk_hw);
 	int mclk_src;
 	int mclk_div;
+	int ret;
 
 	/*
 	 * Clock the sensor appropriately.  Controller clock should
@@ -931,7 +932,9 @@ static int mclk_enable(struct clk_hw *hw)
 		mclk_div = 2;
 	}
 
-	pm_runtime_get_sync(cam->dev);
+	ret = pm_runtime_resume_and_get(cam->dev);
+	if (ret < 0)
+		return ret;
 	clk_enable(cam->clk[0]);
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
@@ -1611,7 +1614,9 @@ static int mcam_v4l_open(struct file *filp)
 		ret = sensor_call(cam, core, s_power, 1);
 		if (ret)
 			goto out;
-		pm_runtime_get_sync(cam->dev);
+		ret = pm_runtime_resume_and_get(cam->dev);
+		if (ret < 0)
+			goto out;
 		__mcam_cam_reset(cam);
 		mcam_set_config_needed(cam, 1);
 	}
-- 
2.30.2



