Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78A83BB1AE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhGDXMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhGDXLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C3656192E;
        Sun,  4 Jul 2021 23:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440094;
        bh=C3Ov4ianFu541hRs+Iw/NiebssbLO9+heVHd2Tx/eXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyZi9KVVmWQRg3rBTzqhTVsBNfjcPkXj6RMGA896Q5oSmeqZangO70VGMjcNwfCZN
         TWLns3C1bczI2wMBmMRzpt3wjaIpzE2aRovgyeqAI31dz4ZS6CUSqLM5loNdBR37wT
         VWW6pZkUumTDrV8LfrG7DdWjPK42UiWzUYYl0spjJYFiRnWoRcdTPVSI/+Q0c54Y53
         Kvpi9HK9V2rhTQuF5Wsu2jyYxyvFu/VbnnlbKshQXwSucsFyQLHHUQSGQUbB8j3Kw3
         bypNETr3Pu8hLIAjtZPmAiD8NlM1LMPWHFThUVQePddiru47qJ/7qGNbVra31+UIFN
         Ev29sQDSJ06+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/70] media: sh_vou: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:07:01 -0400
Message-Id: <20210704230804.1490078-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 6e8b1526db164c9d4b9dacfb9bc48e365d7c4860 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, check if the PM runtime error was caught at open time.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sh_vou.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index b22dc1d72527..7d30e0c9447e 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1133,7 +1133,11 @@ static int sh_vou_open(struct file *file)
 	if (v4l2_fh_is_singular_file(file) &&
 	    vou_dev->status == SH_VOU_INITIALISING) {
 		/* First open */
-		pm_runtime_get_sync(vou_dev->v4l2_dev.dev);
+		err = pm_runtime_resume_and_get(vou_dev->v4l2_dev.dev);
+		if (err < 0) {
+			v4l2_fh_release(file);
+			goto done_open;
+		}
 		err = sh_vou_hw_init(vou_dev);
 		if (err < 0) {
 			pm_runtime_put(vou_dev->v4l2_dev.dev);
-- 
2.30.2

