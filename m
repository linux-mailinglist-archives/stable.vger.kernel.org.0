Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3C32059E2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgFWRoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbgFWRfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 892AB20774;
        Tue, 23 Jun 2020 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933725;
        bh=rddvpDfFVekss7/Pg3s+lxXRzrKvxWRTL8sw+yvTBNE=;
        h=From:To:Cc:Subject:Date:From;
        b=0poEAU+iLCFJpeQ1zms+YPfpUUd1elRRkx+EcDDwo8aNtHVdmJO65pIT1CACkahAO
         I///GMi1Cf/Z/Uhy24zYGlFqEwGj32u21seozwBiMFV55g4qpSU3kiVDANVc/mV6/3
         QDqkXcgW+xC9ovZU3UvGHh+XtGVNzUtlWDhpY6Oo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 01/28] sata_rcar: handle pm_runtime_get_sync failure cases
Date:   Tue, 23 Jun 2020 13:34:56 -0400
Message-Id: <20200623173523.1355411-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit eea1238867205b9e48a67c1a63219529a73c46fd ]

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_rcar.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index 980aacdbcf3b4..141ac600b64c8 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -907,7 +907,7 @@ static int sata_rcar_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
-		goto err_pm_disable;
+		goto err_pm_put;
 
 	host = ata_host_alloc(dev, 1);
 	if (!host) {
@@ -937,7 +937,6 @@ static int sata_rcar_probe(struct platform_device *pdev)
 
 err_pm_put:
 	pm_runtime_put(dev);
-err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
 }
@@ -991,8 +990,10 @@ static int sata_rcar_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(dev);
 		return ret;
+	}
 
 	if (priv->type == RCAR_GEN3_SATA) {
 		sata_rcar_init_module(priv);
@@ -1017,8 +1018,10 @@ static int sata_rcar_restore(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(dev);
 		return ret;
+	}
 
 	sata_rcar_setup_port(host);
 
-- 
2.25.1

