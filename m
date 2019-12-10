Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333321193BF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfLJVJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbfLJVJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C4EB246AC;
        Tue, 10 Dec 2019 21:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012195;
        bh=Xs9azZUSBFSp7gdmcJkMreRRH1oyq6EQNLWJYKL6CiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD3lv8oVwNzV1+EAAbOpkjgbV1gq2N+z8bPWYM+lMkMxEqU4ipcitR14ZZaAL7cuL
         JethQisTTEdaKzI9ycpNhDTywDeP1UoeUUaJ8ZoFmfxZ3HUrvMC2vlLPbwNOTeTEt7
         PUj0flppHVIKD990v0rqyU9Vd5bci5Y+gDgoU9hA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>, Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 149/350] media: ov5640: Make 2592x1944 mode only available at 15 fps
Date:   Tue, 10 Dec 2019 16:04:14 -0500
Message-Id: <20191210210735.9077-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit 981e445454531c9d5ac5d3fa8c0f1bd55262d001 ]

The sensor data sheet clearly state that 2592x1944 only works at 15 fps
make sure we don't try to miss configure the pll out of acceptable
range.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 500d9bbff10b5..18dd2d717088b 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1611,6 +1611,11 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 	    !(mode->hact == 640 && mode->vact == 480))
 		return NULL;
 
+	/* 2592x1944 only works at 15fps max */
+	if ((mode->hact == 2592 && mode->vact == 1944) &&
+	    fr > OV5640_15_FPS)
+		return NULL;
+
 	return mode;
 }
 
-- 
2.20.1

