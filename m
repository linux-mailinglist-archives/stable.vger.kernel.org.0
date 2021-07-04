Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22F3BB18A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhGDXMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232100AbhGDXLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CAB61941;
        Sun,  4 Jul 2021 23:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440090;
        bh=JqY4SiH2kiDGdE/b30pk5GzvlmzpdykOaKKs2cllb4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzXytif+rfSemklehvOzqQFH5AQTpqg+gys1Y54MM5PGwyyAmqML+2lxdJkMnPFbr
         4XF7lcd5l5vmqys9/mjnHsZSzov8MJ642pIWuQ0UR/nrk2XXiDJ8lYdcgW87vLVEX9
         HQBpcIZq70sXrGreaDhTz9a3+bGRLJ2bjPEqgHaN1A1YpkjkgoRilfWUrEHWsLsr3A
         8JiB8w5RNvf2of8PonRBZL0odWXYF6uTNChbihGzhXnYPODDGJjz5rV8IvxavnDrIa
         OR4Jk8lrlYKebApVXU1uFMKn9qEom+bElUIUaAY7y//HRpjRqXeRUF9G00Q/lswlah
         zOn/qf2XiQ13A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/70] media: marvel-ccic: fix some issues when getting pm_runtime
Date:   Sun,  4 Jul 2021 19:06:57 -0400
Message-Id: <20210704230804.1490078-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

