Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A82368D07
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbfGONzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731943AbfGONzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:55:45 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6FD72083D;
        Mon, 15 Jul 2019 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198944;
        bh=ZWaBUMLCgXFKFGVnnO8hXpKxZj7qzIwA6QnvWHk8ns8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05VikzdbG0grCay0hOtlihnKAgKiP1Lv5vWHeC6RDE9uPjbpcQFgNBNljKRO75YbP
         bjldoT6csaBQlpklzc2jREuY9szTln1bbGCZ+fyA3WKE/VJXEgHKYwsQrjTUnKFtzl
         QdRMzs5CsStI+Ay46oi0FNIfPc7A5PE9QRv8w+sU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Jarzmik <robert.jarzmik@free.fr>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 148/249] media: mt9m111: fix fw-node refactoring
Date:   Mon, 15 Jul 2019 09:45:13 -0400
Message-Id: <20190715134655.4076-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Jarzmik <robert.jarzmik@free.fr>

[ Upstream commit 8d4e29a51a954b43e06d916772fa4f50b7e5bbd6 ]

In the patch refactoring the fw-node, the mt9m111 was broken for all
platform_data based platforms, which were the first aim of this
driver. Only the devicetree platform are still functional, probably
because the testing was done on these.

The result is that -EINVAL is systematically return for such platforms,
what this patch fixes.

[Sakari Ailus: Rework this to resolve a merge conflict and use dev_fwnode]

Fixes: 98480d65c48c ("media: mt9m111: allow to setup pixclk polarity")
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/mt9m111.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 362c3b93636e..5a642b5ad076 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -1245,9 +1245,11 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
-	ret = mt9m111_probe_fw(client, mt9m111);
-	if (ret)
-		return ret;
+	if (dev_fwnode(&client->dev)) {
+		ret = mt9m111_probe_fw(client, mt9m111);
+		if (ret)
+			return ret;
+	}
 
 	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(mt9m111->clk))
-- 
2.20.1

