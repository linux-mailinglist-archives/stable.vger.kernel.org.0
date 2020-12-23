Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07042E1519
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgLWCrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:47:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbgLWCWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958EE22273;
        Wed, 23 Dec 2020 02:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690098;
        bh=YFCf/K6x0IbCVbZnAKkWfkebrtjn3sDvj8SZ8ephOYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9vesQ6M8M1AL8GMqXdcMBeVuZfjbOSvoRlwjf2mzNct7RBFcBXrljiSDAlKo3+en
         nae34/PBW31fMAs50PuCbFzA8wQPWhqBXNHaCkqhD1t891SZZZcQ4MAmK7zYlyiJyn
         lS+jItFU4AGF7/zzOJIxBewkIV25/L/J7EhazKHGpMBptbOGNTC1volAVMBBoR1kp4
         Bmggz1imyjJzHZwRZjGsNKntcl5tDwy8CB/qKvQLPo6i1ihUtPCQ8XJPqCE5RXtjGR
         XFFMaIy7Jfxx2XBvLaujQgeEnK3Yupo9hFfPnqZ6HDURHTYnXvgTQXQgWmPNsnuxy6
         gnnXhMl6dJsQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/87] media: isif: reset global state
Date:   Tue, 22 Dec 2020 21:20:04 -0500
Message-Id: <20201223022103.2792705-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 6651dba2bd838f34cf5a1e84229aaa579b1a94fe ]

isif_probe() invokes iounmap() on error handling paths, but it does not
reset the global state. So, later it can invoke iounmap() even when
ioremap() fails. This is the case also for isif_remove(). The patch
resets the global state after invoking iounmap() to avoid this.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/isif.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index 80fa60a4c4489..d91634d529bb3 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1084,10 +1084,14 @@ static int isif_probe(struct platform_device *pdev)
 	release_mem_region(res->start, resource_size(res));
 	i--;
 fail_nobase_res:
-	if (isif_cfg.base_addr)
+	if (isif_cfg.base_addr) {
 		iounmap(isif_cfg.base_addr);
-	if (isif_cfg.linear_tbl0_addr)
+		isif_cfg.base_addr = NULL;
+	}
+	if (isif_cfg.linear_tbl0_addr) {
 		iounmap(isif_cfg.linear_tbl0_addr);
+		isif_cfg.linear_tbl0_addr = NULL;
+	}
 
 	while (i >= 0) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
@@ -1105,8 +1109,11 @@ static int isif_remove(struct platform_device *pdev)
 	int i = 0;
 
 	iounmap(isif_cfg.base_addr);
+	isif_cfg.base_addr = NULL;
 	iounmap(isif_cfg.linear_tbl0_addr);
+	isif_cfg.linear_tbl0_addr = NULL;
 	iounmap(isif_cfg.linear_tbl1_addr);
+	isif_cfg.linear_tbl1_addr = NULL;
 	while (i < 3) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (res)
-- 
2.27.0

