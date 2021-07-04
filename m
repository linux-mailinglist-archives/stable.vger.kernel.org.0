Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A162E3BB0C3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhGDXJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231646AbhGDXJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79CED61283;
        Sun,  4 Jul 2021 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439986;
        bh=Lz+/JlLUf0y6vdpM5zzN5Pg+5vyv1ERRqgWrhzFUI5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lls0rlpXPa9rgkC/6n/DQ0rbomZ/+doSazSrvSUpI49RARjy8hyWVICo0PkYciTXj
         3FZyYsM9gdZR60dxOsqi386QsEsxX78zxHsgAy1mFHDEO/5GQkPwPmJGK10DFErNUS
         WgbydxMaNqzcjUBIeFCtfzDeOTu6YO+h71I2jUa/U/y3b84F2vKidSow7wGPXjuD6I
         t5Z1NTLWXpQqeSj5eu34kF9xF8ztj6T58dGDlP0g/DtJ12LxAarumYT3JCg7KhGwDy
         W9cRelz0wInqqCWfDyGn4Q/lV41LwEECVY5BpdfGigO9Fsl3Gh16apARsWd1zIb9rS
         azWM0+AYx/VHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 07/80] media: s5p: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:05:03 -0400
Message-Id: <20210704230616.1489200-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
 drivers/media/cec/platform/s5p/s5p_cec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/s5p/s5p_cec.c b/drivers/media/cec/platform/s5p/s5p_cec.c
index 2a3e7ffefe0a..2250c1cbc64e 100644
--- a/drivers/media/cec/platform/s5p/s5p_cec.c
+++ b/drivers/media/cec/platform/s5p/s5p_cec.c
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

