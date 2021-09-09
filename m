Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7554057D5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353476AbhIINm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356619AbhIIMzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2AD063253;
        Thu,  9 Sep 2021 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188692;
        bh=sQw9MZjQniyUBF22K2BBv1mR9r1y/Ody4+hAHNxdgZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CG8DdKq+UfH7tLdkBQWfdypmG/4fdAaZT4Qve7xQ1bdyR2sVBoqH+O05rNl/e3Zsv
         d3XdWVoSqCfj7LUoLO8Vt9MrnmaGqKzDJMgXdq1NKJWAU4zJjhUIybs0agrrALCJc0
         zr1Ka0QrmaonItyYqrj2Wj0KWH/oxoHckTfAx2UGOpLbcBKm2OxJaD1tOFH7dsGSwP
         3W8lmEKwVhss3mihy01gZWhA57QotfkbXfzzSYhYdtbV1MgF8GIDYu/uSj7MYw9WW5
         TUx1lLMOrxwTvopYjRT9j9g5zLZm+45xbDXW7U5kX8i63NF/5gwkZZsNYuWfAlBwCu
         QjDhBR/0hDO6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Umang Jain <umang.jain@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/74] media: imx258: Limit the max analogue gain to 480
Date:   Thu,  9 Sep 2021 07:56:49 -0400
Message-Id: <20210909115726.149004-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit f809665ee75fff3f4ea8907f406a66d380aeb184 ]

The range for analog gain mentioned in the datasheet is [0, 480].
The real gain formula mentioned in the datasheet is:

	Gain = 512 / (512 – X)

Hence, values larger than 511 clearly makes no sense. The gain
register field is also documented to be of 9-bits in the datasheet.

Certainly, it is enough to infer that, the kernel driver currently
advertises an arbitrary analog gain max. Fix it by rectifying the
value as per the data sheet i.e. 480.

Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx258.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index 68ce63333744..85395813c0f2 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -46,7 +46,7 @@
 /* Analog gain control */
 #define IMX258_REG_ANALOG_GAIN		0x0204
 #define IMX258_ANA_GAIN_MIN		0
-#define IMX258_ANA_GAIN_MAX		0x1fff
+#define IMX258_ANA_GAIN_MAX		480
 #define IMX258_ANA_GAIN_STEP		1
 #define IMX258_ANA_GAIN_DEFAULT		0x0
 
-- 
2.30.2

