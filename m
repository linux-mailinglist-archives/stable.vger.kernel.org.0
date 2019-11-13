Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6699FA3AC
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKMCLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbfKMB6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49AAF2245A;
        Wed, 13 Nov 2019 01:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610325;
        bh=fPTTL918haYPzKywCNCsAU+vg6L7/gNh4/5v3ts11vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1i3eadg7TxvrIskxUaOzfViwkjGytc20FBVD4GDyVH2DgM9EvyLToGgY8VVFYl40d
         IpbaW4FKKlMOh2DSpNMLmHaHxqbPCw4iKhms+3sKGLRSGBSr9pQjO/yzlZKAOiUFEc
         /yGb+r5GwuxXc/4mMJCW7ZB2HFZxlqxdc1sJ8k+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajmohan Mani <rajmohan.mani@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 086/115] media: dw9714: Fix error handling in probe function
Date:   Tue, 12 Nov 2019 20:55:53 -0500
Message-Id: <20191113015622.11592-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 95af4fc99cd04..c1273bcd59011 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -182,7 +182,8 @@ static int dw9714_probe(struct i2c_client *client)
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

