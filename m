Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35020106DCC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbfKVLDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731415AbfKVLDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7892075E;
        Fri, 22 Nov 2019 11:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420599;
        bh=ffHEVW4A2f6ZX2xTIUsYIgMSIjS3ATEQZ/xFAekb1sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/U3I5rt0IIwWAP8wQh8JX1AH5eLHyys+VC36olQwvnieN2FgXkEFRfoEnaSiQQx+
         21dSfhEdex/ZPeuaVdUnnBnfRUd1jL7K6nd+lHMnm6tYcCTEP6U+4+hafV/SSo9EnC
         X1kyE6JuIzJIWwks7nPNnR98KKnOrioYv++sGd2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/220] media: dw9807-vcm: Fix probe error handling
Date:   Fri, 22 Nov 2019 11:28:45 +0100
Message-Id: <20191122100924.240678353@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



