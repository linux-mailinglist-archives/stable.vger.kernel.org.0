Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07143BB26C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhGDXPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbhGDXOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 351B661405;
        Sun,  4 Jul 2021 23:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440183;
        bh=aZU4r3G57Y5xXD1IZkS1KN+47+dzWYcVJPYC0sf3gXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ5lRidDeNydWQ8yidmxRtYdGhJ4OTvN2VZ7Z1EnFj/gg2lp+35gtG/qsBazeU9G+
         /WIUDwMQChbTX4F6BJcsOIC9JATJoZDGH58wpYXyOw6GM9Y55WYfrRL6L9SGUe1mKb
         79r7ThqLGav9gFiHtxkiYeaDqq2VqXT5SUEh4iBNAXfydrPE/y/7EKHZlY62Tde6iy
         XHRgxrsBgwR7PRj3H/ljndte37WMA57Z6b8OG3wurDDLDNm/R+UAj3ahiTlATfGTY3
         YkZTOpZJ6D6kfWkRwN2PPwTvt4KzhI8QajJ/kBq9LvnsNOb/aYiSuGJXIIdSxL5IMx
         k2vSHo3V1v/QQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/50] media: s5p: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:08:51 -0400
Message-Id: <20210704230938.1490742-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit fdc34e82c0f968ac4c157bd3d8c299ebc24c9c63 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, check if the PM runtime error was caught at
s5p_cec_adap_enable().

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-cec/s5p_cec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 6ddcc35b0bbd..5e80352f506b 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -35,10 +35,13 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
 
 static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
+	int ret;
 	struct s5p_cec_dev *cec = cec_get_drvdata(adap);
 
 	if (enable) {
-		pm_runtime_get_sync(cec->dev);
+		ret = pm_runtime_resume_and_get(cec->dev);
+		if (ret < 0)
+			return ret;
 
 		s5p_cec_reset(cec);
 
-- 
2.30.2

