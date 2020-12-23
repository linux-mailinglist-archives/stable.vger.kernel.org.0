Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A302F2E1229
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgLWCTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgLWCTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB15722257;
        Wed, 23 Dec 2020 02:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689944;
        bh=kFY3jfaSGn9wP3jpuMECk2u7kpTMi3nSn4DQgzodpoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjh0HBgxmPMK2IlWLrrNO3YjSM7Q5F6HMBZM7S9AtwqVdZV4Sr+/yGUFiq5rHSDAV
         fji+RugJ6ZxrrG3nv3fBPS9+rCoDGA9+lPJO4Iq6c8D/NOuQmKUlCj41X/ee/46WjZ
         vpI/W2h8pmKF7ehj/uGPh2jxiNGtpN5IAQm+pBZFDQRHN+16HMefVWma8FZUAK/b7A
         YjO/e9dH9c1tEELGrGY5dm76hQhrBUQlPw1QAsqWUKvd7YdNIXn6hJ3+EzMrY0wyjM
         dmVQq+vYXafb3FeT0C17i7scOUCfQk+/xxfl2fDDU22T29yhsncpih7pK9BqEe3NLf
         kl3w/uHgYQfxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 039/130] media: isif: reset global state
Date:   Tue, 22 Dec 2020 21:16:42 -0500
Message-Id: <20201223021813.2791612-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index e2e7ab7b7f45b..29434f076c047 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1075,10 +1075,14 @@ static int isif_probe(struct platform_device *pdev)
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
@@ -1096,8 +1100,11 @@ static int isif_remove(struct platform_device *pdev)
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

