Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00B7FA513
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbfKMCUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbfKMBy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB6BE222CD;
        Wed, 13 Nov 2019 01:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610069;
        bh=sYQwy0mr+/sqRpZnuVp/y88pnLT1G0lmL9bwKXQivFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYPKSFiMwRquy2p5/p3Bju5BikQQ3RecymDJ1KIlnBPTe4enyQ6hPuALICFKAOJBe
         YMStE1FLzAMvz5TSxVIWwM4sF3a37C/T94N0BO1HKPYzCe2icTMT8hiRU6okpA1hh6
         ykZ6U+eSKQ0Elx72t0KLv6fGuWED0K8Y3uDPYrtE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajmohan Mani <rajmohan.mani@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 148/209] media: dw9714: Fix error handling in probe function
Date:   Tue, 12 Nov 2019 20:49:24 -0500
Message-Id: <20191113015025.9685-148-sashal@kernel.org>
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

