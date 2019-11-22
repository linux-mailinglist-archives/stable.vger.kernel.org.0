Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6B106DCB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfKVLDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbfKVLDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C882073F;
        Fri, 22 Nov 2019 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420593;
        bh=sYQwy0mr+/sqRpZnuVp/y88pnLT1G0lmL9bwKXQivFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZp5DSDUhZ7jOV2XH4GJI4jb/VTvnLSWEcAUroi7El6m6hCOHU2pfOKWq7wRjT7RE
         /LP+vfhY1wz0Nn9N+zsHyM5pNEwlFXsb9kDSdvsVh96+og8Oh/Huh/SRHx4+Kx7RL2
         mAVB7Bq/aq6uWFzP7mAYRv3G8of6gM6CSYtwFk1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajmohan Mani <rajmohan.mani@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/220] media: dw9714: Fix error handling in probe function
Date:   Fri, 22 Nov 2019 11:28:44 +0100
Message-Id: <20191122100924.155041370@linuxfoundation.org>
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

From: Rajmohan Mani <rajmohan.mani@intel.com>

[ Upstream commit f9a0b14240a2d0bd196d35e8aac73df6eabd6382 ]

Fixed the case where v4l2_async_unregister_subdev()
is called unnecessarily in the error handling path
in probe function.

Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9714.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 91fae01d052bf..3dc2100470a1c 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -169,7 +169,8 @@ static int dw9714_probe(struct i2c_client *client)
 	return 0;
 
 err_cleanup:
-	dw9714_subdev_cleanup(dw9714_dev);
+	v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
+	media_entity_cleanup(&dw9714_dev->sd.entity);
 	dev_err(&client->dev, "Probe failed: %d\n", rval);
 	return rval;
 }
-- 
2.20.1



