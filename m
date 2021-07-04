Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C6C3BB18C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhGDXMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232088AbhGDXLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B256194E;
        Sun,  4 Jul 2021 23:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440088;
        bh=VcFcH5ns65QNQL6Uh4A/eiq75KTpr/4XR8S+9m8uuIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tggSZIncA4H29GgnAE6zXa7woNtFmVVWJEXuYO7Bzg5btiCrVdTqKkztwjNkxVJ2s
         Km0LqjqZxUH3mha3uW98nyJfycEV4mUGt5L14IbSHF2ywBOBFgilRUF3wrh22qJ2Bh
         ywOuIkFeHr2CW3qs5rgE+Sr4dT73JNfsK9UWNpTLtXamFlMRVT1LnVEBiq8a5XGT1t
         sVwVTa1g26jhvfooPAj4TAwh25AzqZJyVf7Tq4WGNN1ClMIHLRp5cMPpNKSrEmFhmb
         LyLAfFpR845IqPYdJgLDAOeKD0hPuJ8SpzGlVizLqof2zyLqUc69GyyfE0DaAxIDeJ
         XspdOXRsp0RLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 03/70] staging: media: rkvdec: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:06:56 -0400
Message-Id: <20210704230804.1490078-3-sashal@kernel.org>
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

[ Upstream commit e90812c47b958407b54d05780dc483fdc1b57a93 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index 1263991de76f..b630e161d4ce 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -691,7 +691,7 @@ static void rkvdec_device_run(void *priv)
 	if (WARN_ON(!desc))
 		return;
 
-	ret = pm_runtime_get_sync(rkvdec->dev);
+	ret = pm_runtime_resume_and_get(rkvdec->dev);
 	if (ret < 0) {
 		rkvdec_job_finish_no_pm(ctx, VB2_BUF_STATE_ERROR);
 		return;
-- 
2.30.2

