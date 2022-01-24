Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5377D499283
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381636AbiAXUVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43686 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346645AbiAXURr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:17:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CA9261491;
        Mon, 24 Jan 2022 20:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC97C340E8;
        Mon, 24 Jan 2022 20:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055466;
        bh=BNw15DMNEo5jqLE6Y6CE4dQGroEOmFccGBlIu/rczgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5TBXNdmOOmjP4nc22WAh+3V9WPexcho57XMV2mSc3urSl7mLe0VZRfCmRlAHb3da
         gxt2CQXPt4iSulumeNcLTCePOeorT4yS75+eYfxQJBp6xKimgaGm5pfF5/f4azPINe
         hkVR2ILGJCSazPtI42gM/3x3YVrgVKvi663eGdhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/846] media: i2c: Re-order runtime pm initialisation
Date:   Mon, 24 Jan 2022 19:34:38 +0100
Message-Id: <20220124184106.539538029@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit d2484fbf780762f6f9cc3abb7a07ee42dca2eaa3 ]

The kerneldoc for pm_runtime_set_suspended() says:

"It is not valid to call this function for devices with runtime PM
enabled"

To satisfy that requirement, re-order the calls so that
pm_runtime_enable() is the last one.

Fixes: 11c0d8fdccc5 ("media: i2c: Add support for the OV8865 image sensor")
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2899,8 +2899,8 @@ static int ov8865_probe(struct i2c_clien
 
 	/* Runtime PM */
 
-	pm_runtime_enable(sensor->dev);
 	pm_runtime_set_suspended(sensor->dev);
+	pm_runtime_enable(sensor->dev);
 
 	/* V4L2 subdev register */
 


