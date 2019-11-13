Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965E1FA509
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfKMByb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbfKMByb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB9120674;
        Wed, 13 Nov 2019 01:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610070;
        bh=ffHEVW4A2f6ZX2xTIUsYIgMSIjS3ATEQZ/xFAekb1sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqGMZ+s2OSSm04LFeF/k82rDnobTZCN5vzxXZ5TWXVg/m5BUzFtjbuGzLEDI5jGbd
         iKWOfkdjmsUTbr8v2CNkLxU3nf/sdeRqttu0erElxBvAe1HLY+2s1g9AaFxbAfwW8L
         f1nEhn/sRE8FBH8yNn4i2lozLJDR7BnVRyNwJ1XM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 149/209] media: dw9807-vcm: Fix probe error handling
Date:   Tue, 12 Nov 2019 20:49:25 -0500
Message-Id: <20191113015025.9685-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 9e5b5081fa117ae34eca94b63b1cb6d43dc28f10 ]

v4l2_async_unregister_subdev() may not be called without
v4l2_async_register_subdev() being called first. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9807-vcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9807-vcm.c b/drivers/media/i2c/dw9807-vcm.c
index 8ba3920b6e2f4..5477ba326d681 100644
--- a/drivers/media/i2c/dw9807-vcm.c
+++ b/drivers/media/i2c/dw9807-vcm.c
@@ -218,7 +218,8 @@ static int dw9807_probe(struct i2c_client *client)
 	return 0;
 
 err_cleanup:
-	dw9807_subdev_cleanup(dw9807_dev);
+	v4l2_ctrl_handler_free(&dw9807_dev->ctrls_vcm);
+	media_entity_cleanup(&dw9807_dev->sd.entity);
 
 	return rval;
 }
-- 
2.20.1

